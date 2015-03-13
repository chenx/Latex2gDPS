%{ 
/* 
 * pn.y
 *
 * yacc input file to convert a LATEX file into gDPS.
 * Usage: ./pn infile, where infile ends in ".i" but not required.
 *
 * @Author: Xin Chen
 * @Created on: Feb. 26, 2007
 * @Last modified: November 11, 2007
 */
#include "pn.h"
#include "symbol_table.h"
#include "lstr.h"

#define SYMBOL_LEN 1024

int OPT_ALIAS;

typedef struct {
  char val[SYMBOL_LEN];
  int type;
} yystype;

#define YYSTYPE yystype
extern YYSTYPE yylval;

typedef int BOOL; 
BOOL PNDEBUG = 1;


//#define YYDEBUG 1
int yyparse(void);
int yylex(void);
void yyerror(char *mes);

HashTbl * h; // symbol table.
int is_LHS = 0; // left or right side of the formular.
char LHS[SYMBOL_LEN];

int typeOfFormula = 0; /* 1 - base, 2 - opt function */

/* Function declarations. */
static void writeComment(FILE * fp, char * msg);


// if is an indexed item, return the array format string.
// else return NULL.
char * formatIndexedItem(char * s) {
  char * pos;
  char * p;
  int len;
  if (NULL == s || (len = strlen(s)) == 0) return NULL;
  if ((pos = strstr(s, "_{")) != NULL && 
      s[len - 1] == '}') { // is indexed item.
    PN_NEW(p, char, len + 1);
    strncpy(p, s, pos - s);
    p[pos - s] = 0;
    strcat(p, "[");
    strcat(p, pos + 2);
    p[strlen(p) - 1] = ']';
    //printf("lll: %s\n", p);
    return p;
  }

  return NULL;
}


// write the element s, if the OPT_ALIAS switch is on
// and s has an alias, write it instead of s.
// 
// Note: sometimes s is more than one token. e.g., when
// is a parameter of a function call, then it's possible to be
// like "(d, S SETUNION {d})", in that case it needs to be 
// broken down into pieces.
char * getAlias(char * s) {
  HashNode * n;
  char * p;

  if (OPT_ALIAS) {
    n = HashTbl_find(h, s);
    if (n != NULL && n->alias != NULL && strcmp(n->alias, "") != 0) {
      return n->alias;
    }
  }

  if ((p = formatIndexedItem(s)) != NULL) { return p; }
  return s; 
}


// write a comment in the gDPS output file.
static void writeComment(FILE * ofp, char * msg) {
  fprintf(ofp, "%s%s", "//", msg);
}


DPFE * create_DPFE() {
  DPFE * d;
  PN_NEW(d, DPFE, 1);
  d->gf = NULL;
  PN_NEW(d->opt_fxn, DPFE_OPT_FUNCTION, 1);
  d->base = NULL;
  d->base_list_tail = NULL;
  d->module_name = "";
  d->module_type = MT_UNKNOWN;
  d->module_goal = NULL;
  d->module_base = NULL;
  d->params_struct = NULL; 
  d->params_struct_list_tail = NULL;

  d->opt_fxn->OPT = NULL;
  d->opt_fxn->decision_variable = NULL;
  d->opt_fxn->decision_space = NULL;
  d->opt_fxn->terms = NULL;
  d->opt_fxn->terms_tail = NULL;
  d->opt_fxn->cond = NULL;

  return d;
}

GoalFunction * create_GoalFunction(char * function_name) {
  GoalFunction * g;
  PN_NEW(g, GoalFunction, 1);
  PN_NEW(g->f_name, char, 1 + strlen(function_name));
  strcpy(g->f_name, function_name);
  g->params = NULL;
  return g;
}

SymbolNode * create_SymbolNode(char * symbol) {
  SymbolNode * n;
  PN_NEW(n, SymbolNode, 1);
  PN_NEW(n->symbol, char, strlen(symbol) + 1);
  strcpy(n->symbol, symbol);
  n->type = _NON;
  n->next = NULL;
  return n;
}

void free_SymbolNode(SymbolNode * n) {
  free(n->symbol);
  free(n);
}


/* assumption: param_list is delimited by "," */
void get_params(GoalFunction * g, char * param_list) {
  SymbolNode * tail;
  char * p;
  //printf("param_list %s\n", param_list);
  if (param_list == NULL) return;
  p = strtok(param_list, ", \t\n");
  if (p == NULL) return;

  tail = g->params = create_SymbolNode(p);
  //printf("add param %s\n", p);

  while ((p = strtok(NULL, ", \t\n")) != NULL) {
    tail->next = create_SymbolNode(p);
    //printf("add param %s\n", p);
    tail = tail->next;
  }
}


void write_SymbolList(SymbolList list) {
  SymbolNode * a = list;
  for (a = list; a != NULL; a = a->next) {
    if (a != list) printf(", ");
    printf("%s", a->symbol);
  }
}


void write_GoalFunction_params(FILE * fp, SymbolList list) {
  SymbolNode * a;
  if (fp == NULL) return;
  a = list;
  for (a = list; a != NULL; a = a->next) {
    if (a != list) fprintf(fp, ", ");
    fprintf(fp, "%s", getAlias(a->symbol));
  }
}


TermNode * create_TermNode(char * term, TermType type) {
  TermNode * n;
  PN_NEW(n, TermNode, 1);
  n->term = create_SymbolNode(term);
  n->type = type;
  n->label = 0;
  n->prev = NULL;
  n->next = NULL;
  return n;
}

void add_opt_fxn_term(DPFE_OPT_FUNCTION * f, 
                      char * term, TermType type) {
  if (f->terms == NULL) {
    f->terms_tail = f->terms = create_TermNode(term, type);
  } else {
    f->terms_tail->next = create_TermNode(term, type);
    f->terms_tail->next->prev = f->terms_tail; // back pointer.
    f->terms_tail = f->terms_tail->next;
  }
}


/*
 * @param param_list: a list of function parameters separated by ",".
 * Don't consider the situation like {"a", "b,c"}
 */
int getParamListLen(const char * param_list) {
  int pt, count;
  if (NULL == param_list || strlen(param_list) == 0) return 0;

  count = 1;
  for (pt = strlen(param_list); pt >= 0; pt --) {
    if (param_list[pt] == ',') count ++;
  }
  return count;
}


/*
 * @input - str, an array list: "..; ..; ..; .."
 * @return - int size. Stores the number of arrays.
 */
int getMatrixSize(const char * str) {
  int size = 0;
  char * pos;
  if (NULL == str || strlen(str) == 0) return 0;

  for (pos = (char *) str; pos != NULL; pos = strchr(pos, ';')) {
    pos ++; // advance one position to ignore the ";".
    size ++;  // count number of arrays.
  }
  //printf("array list (size = %d): %s\n", size, str);
  return size;
}


/*
 * @input - str, an array list: "..; ..; ..; .."
 * @output - int * size. Stores the number of arrays.
 * @return - a pointer to the matrix.
 */
char ** getMatrix(char * str, int * size) {
  int i;
  char * pos;
  char ** matrix;

  if (NULL == str || strlen(str) == 0) return NULL;
  if ((* size = getMatrixSize(str)) == 0) { return NULL; }

  PN_NEW(matrix, char *, * size);
  i = 0;
  for (pos = strtok(str, ";"); pos != NULL; pos = strtok(NULL, ";")) {
    matrix[i] = str_dup(pos);  
    matrix[i] = trim(matrix[i], " \t\n,");
    i ++;
  }

  return matrix;
}


/*
 * Add a new ModuleBase to the end of d->ModuleBase list.
 */
void get_ModuleBase(DPFE * d, char * val) {
  //puts("getMB.start");
  ModuleBase * mb, * mb_end;
  PN_NEW(mb, ModuleBase, 1);
  PN_NEW(mb->base, char, strlen(val) + 1);
  strcpy(mb->base, val);

  if ((mb_end = d->module_base) == NULL) { 
    d->module_base = mb; 
  } else { 
    for (; mb_end != NULL; mb_end = mb_end->next) {
      if (mb_end->next == NULL) break;
    }
    mb_end->next = mb; 
  }

  //puts("getMB.end");
}


/*
 * Add a new DPFE_BASE object to the head of d->base list.
 * Also fill its value field here.
 */
void add_DPFE_BASE(DPFE * d, char * val) {
  DPFE_BASE * db;
  PN_NEW(db, DPFE_BASE, 1);
  PN_NEW(db->value, SymbolNode, 1);
  PN_NEW(db->value->symbol, char, strlen(val) + 1);
  strcpy(db->value->symbol, val);
  db->next = NULL;
    
  if (d->base == NULL) { // insert first DPFE base.
    d->base = db;
    d->base_list_tail = db;
  } else { // insert db at the end of base list.
    d->base_list_tail->next = db;
    d->base_list_tail = db;
  }
}


/*
 * Add a new cond object to the first object in the d->base list.
 */
void add_DPFE_BASE_cond(DPFE * d, char * cond) {
  ConditionNode * cn;
  PN_NEW(cn, ConditionNode, 1);
  PN_NEW(cn->condition, SymbolNode, 1);
  PN_NEW(cn->condition->symbol, char, strlen(cond) + 1);
  strcpy(cn->condition->symbol, cond);

  cn->next = d->base_list_tail->cond;
  d->base_list_tail->cond = cn;
}


void add_DPFE_OPT_FUNCTION_cond(DPFE * d, char * cond) {
  ConditionNode * cn;
  PN_NEW(cn, ConditionNode, 1);
  PN_NEW(cn->condition, SymbolNode, 1);
  PN_NEW(cn->condition->symbol, char, strlen(cond) + 1);
  strcpy(cn->condition->symbol, cond);

  cn->next = d->opt_fxn->cond;
  d->opt_fxn->cond = cn;
}


void get_DPFE_cond(DPFE * d, int cond_type, char * cond) {
  if (cond_type == 1) { // base
    //printf("BASE cond: %s\n", cond);
    add_DPFE_BASE_cond(d, cond);
  } else if (cond_type == 2) { // opt function
    //printf("OPT cond: %s\n", cond);
    add_DPFE_OPT_FUNCTION_cond(d, cond);
  }
}


%}

%token NUMBER 
%token ID
%token INDEXED_ID
%token EPSILON
%token ALPHA
%token BETA
%token OTHERWISE
%token BEGIN
%token END
%token EQN
%token ARRAY
%token LEFT
%token RIGHT
%token BRACKET_LEFT  
%token BRACKET_RIGHT
%token PERIOD
%token LL
%token DISP_STYLE
%token MIN_HEAD
%token MAX_HEAD
%token NEW_LINE
%token IN
%token DOTS
%token MBOX
%token IF
%token NOTIN
%token NE
%token LE
%token GE
%token GT
%token LT
%token EQ
%token CUP
%token LABEL
%token AND
%token OR
%token INFINITY
%token EMPTY_SET
%token QUAD
%token FXN_NAME

%token MODULE_TYPE
%token MODULE_NAME
%token DIMENSION
%token MODULE_GOAL
%token MODULE_BASE
%token ALIAS
%token DATA_TYPE
%token DECLARATION

%left '+' '-'
%left '*' '/'
%left NEG
%right '^'

%%

program : declaration BEGIN EQN label eqn_body END EQN  
  {
    if (PNDEBUG) printf("input is correct\n"); 
  } 
	;

declaration : BEGIN DECLARATION declaration_list END DECLARATION
  { is_LHS = 1; }
            | BEGIN DECLARATION END DECLARATION
  { is_LHS = 1; }
            ;

declaration_list : declaration_list declaration_item_line
                 | declaration_item_line
                 ;

declaration_item_line : declaration_item NEW_LINE_list
                      | declaration_item
                      ;

declaration_item : module_type
                 | module_name
                 | dimension
                 | datatype
                 | goal
                 | base
                 | alias
                 ;

NEW_LINE_list : NEW_LINE_list NEW_LINE
              | NEW_LINE
              ;

module_type : MODULE_TYPE ':' ID
  {
     setModuleType(dpfe, $3.val);
     if (PNDEBUG) { printf("module type: %s\n", getModuleType(dpfe)); }
  }
            ;

module_name : MODULE_NAME ':' ID
  {
    dpfe->module_name = str_dup($3.val);
  }
            ;

dimension : DIMENSION ':' dimension_list
          ;

dimension_list : dimension_list ',' dimension_item
               | dimension_list ',' NEW_LINE dimension_item
               | dimension_item
               ;

dimension_item : dimension_name EQ '{' array_list2 '}'
  {
    getDimension(dpfe, $1.val, $4.val, DT_MATRIX); // matrix
    HashTbl_insertVarType(h, $1.val, cstr_SET);
  }
               | dimension_name EQ '{' expr_list '}'
  {
    getDimension(dpfe, $1.val, $4.val, DT_ARRAY); // array
    HashTbl_insertVarType(h, $1.val, cstr_SET);
  }
               | dimension_name EQ term
  {
    getDimension(dpfe, $1.val, $3.val, DT_TERM); // term
  }
          ;

array_list2 : array_list ';' expr_list  /* two expr_list or more */
  {
    sprintf($$.val, "%s;%s", $1.val, $3.val);
  }
            ;

array_list : array_list ';' expr_list /* one expr_list or more */
  {
    sprintf($$.val, "%s;%s", $1.val, $3.val);
  }
           | expr_list 
  {
    strcpy($$.val, $1.val);
  }
           ;

dimension_name : term
  { 
    sprintf($$.val, "%s", $1.val);
  }
               ;

datatype : DATA_TYPE ':' datatype_list
          ;

datatype_list : datatype_list ',' datatype_item
              | datatype_item
              ;

datatype_item : ID ID
  {
    if (PNDEBUG) { printf("%s type: %s\n", $2.val, $1.val); }
    HashTbl_insert(h, $2.val);
    HashTbl_insertVarType(h, $2.val, $1.val);
  }
              ;

/* Here don't use the fxn nonterminal since it has side effect. */
goal : MODULE_GOAL ':' FXN_NAME expr_list ')'
  { 
    $3.val[strlen($3.val) - 1] = 0; // remove "("
    if (PNDEBUG) { printf("goal: %s(%s)\n", $3.val, $4.val); }
    PN_NEW(dpfe->module_goal, char, strlen($3.val) + strlen($4.val) + 3);
    sprintf(dpfe->module_goal, "%s(%s)", $3.val, $4.val);
  }
     ;

base : MODULE_BASE ':' module_base_list
     ;

module_base_list : module_base_list ';' NEW_LINE_list module_base
  {
    get_ModuleBase(dpfe, $4.val);
  }
                 | module_base_list ';' module_base
  {
    get_ModuleBase(dpfe, $3.val);
  }
                 | module_base
  {
    get_ModuleBase(dpfe, $1.val);
  }
                 ;

module_base : fxn EQ expr module_base_cond 
  {
    sprintf($$.val, "%s = %s %s", $1.val, $3.val, $4.val);
  }
            ;
             

module_base_cond : /* empty */
  {
    sprintf($$.val, "");
  }
                 | IF module_base_logic_expr
  {
    sprintf($$.val, "WHEN %s", $2.val);
  }
                 ;

module_base_logic_expr : module_base_relation_expr logic_op module_base_relation_expr
  {
    sprintf($$.val, "%s %s %s", $1.val, $2.val, $3.val);
  }
                       | module_base_relation_expr
  {
    sprintf($$.val, "%s", $1.val); 
  }
                       ;

module_base_relation_expr : expr relation_op expr 
  {
    sprintf($$.val, "%s %s %s", $1.val, $2.val, $3.val);
  }
                          | '(' module_base_logic_expr ')'
  {
    sprintf($$.val, "(%s)", $2.val);
  }
                          ;

alias : ALIAS ':' alias_list
      ;

alias_list : alias_list ',' alias_item
           | alias_item
           ;

alias_item : ID EQ ID
  {
    if (PNDEBUG) { printf("%s =~ %s\n", $1.val, $3.val); }
    HashTbl_insert(h, $1.val);
    HashTbl_insertVarAlias(h, $1.val, $3.val);
  }
           ;

label : /* empty */
      | LABEL '{' ID '}'
      ;

eqn_body : fxn EQ fxn_val
         | fxn NEW_LINE_list EQ fxn_val
         ;

fxn : FXN_NAME expr_list ')'
      { 
        //printf("==%s(%s)\n", $1.val, $3.val);
        $1.val[strlen($1.val) - 1] = 0; // remove the end "(".
        HashTbl_setNodeType(HashTbl_insert(h, $1.val), PN_FUNC_NAME);

        if (is_LHS == 1) {
          dpfe->gf = create_GoalFunction($1.val);
          sprintf(LHS, "%s(%s)", $1.val, $2.val);
          HashTbl_setNodeType(HashTbl_insert(h, LHS), PN_FUNC_CALL);
          get_params(dpfe->gf, $2.val);
          is_LHS = 0;
          if (PNDEBUG) {
            printf("LHS function: ");
            printf("%s(", dpfe->gf->f_name); 
            write_SymbolList(dpfe->gf->params);
            printf(")\n");
            printf("RHS starts:\n");
          }
        }
        sprintf($$.val, "%s(%s)", $1.val, $2.val);
      }
    ;

fxn_val : LEFT BRACKET_LEFT formular_array RIGHT PERIOD 
        | formular_item dot /* only one formular on RHS */
        ;

formular_array : BEGIN ARRAY LL formular_lines END ARRAY
               |
               ;

formular_lines : formular_lines formular_line
               | formular_line
               ;

formular_line : formular '&' condition NEW_LINE
  {
    if (PNDEBUG) {
      printf("formular: %s = %s {%s}\n", LHS, $1.val, $3.val);
    }
    typeOfFormula = 0; // after processing a line. turn typeOfFormula off.
  }
              ;

formular : style_formular 
  {
     strcpy($$.val, $1.val);
     typeOfFormula = 2; // opt function.
  }
         | expr           
  {
    strcpy($$.val, $1.val); 
    typeOfFormula = 1; // base.
    //printf("BASE expr: %s\n", $1.val);
    add_DPFE_BASE(dpfe, $1.val);
  }
         ;

style_formular : '{' DISP_STYLE formular_item '}'
  {
    sprintf($$.val, "%s", $3.val);
  }
               ;

formular_item : opt_hd BRACKET_LEFT formular_expr BRACKET_RIGHT
  {
    sprintf($$.val, "%s{ %s }", $1.val, $3.val); 
  }
              ;

formular_expr : formular_expr operator term
  {
    sprintf($$.val, "%s %s %s", $1.val, $2.val, $3.val);
    if (PNDEBUG) printf("1: %s %s %s\n", $1.val, $2.val, $3.val);

    add_opt_fxn_term(dpfe->opt_fxn, $2.val, _T_OPERATOR);
    add_opt_fxn_term(dpfe->opt_fxn, $3.val, $3.type);
  }
     | formular_expr '^' '{' term '}' /* exponentiation operator */
  {
    sprintf($$.val, "%s^{%s}", $1.val, $4.val);
    add_opt_fxn_term(dpfe->opt_fxn, "^", _T_OPERATOR);
    add_opt_fxn_term(dpfe->opt_fxn, $4.val, $4.type);
  }
     | formular_expr term 
  { 
    if (strlen($2.val) > 0) {
      sprintf($$.val, "%s * %s", $1.val, $2.val);
      if (PNDEBUG) printf("2: %s * %s\n", $1.val, $2.val);

      // Add omitted "*" back here.
      HashTbl_setNodeType(HashTbl_insert(h, "*"), PN_OP_ARITH);

      add_opt_fxn_term(dpfe->opt_fxn, "*", _T_OPERATOR);
      add_opt_fxn_term(dpfe->opt_fxn, $2.val, $2.type);
    } else {
      sprintf($$.val, "%s", $1.val);
      if (PNDEBUG) printf("2: %s\n", $1.val);
    }
  }
     | term      
  { 
    sprintf($$.val, "%s", $1.val);
    if (PNDEBUG) printf("3: %s\n", $1.val);

    add_opt_fxn_term(dpfe->opt_fxn, $1.val, $1.type);
  }
     | '|' formular_expr '|'  /* absoluate value */
  {
    sprintf($$.val, "|%s|", $2.val);
  }
     ;

expr : expr operator term
  { 
    sprintf($$.val, "%s %s %s", $1.val, $2.val, $3.val);
  }
     | expr '^' '{' term '}' /* exponentiation operator */
  {
    sprintf($$.val, "%s^{%s}", $1.val, $2.val, $3.val);
  }
     | expr set_operator term
  {
    sprintf($$.val, "%s %s %s", $1.val, $2.val, $3.val);
  }
     | expr term
  { 
    if (strlen($2.val) > 0) {
      sprintf($$.val, "%s * %s", $1.val, $2.val);
    } else {
      sprintf($$.val, "%s", $1.val);
    }
  } 
     | term      
  { 
    sprintf($$.val, "%s", $1.val); 
  }
     | '|' expr '|'  /* absoluate value */
  {
    sprintf($$.val, "|%s|", $2.val);
  }
     | '{' expr_list '}'
  {
    sprintf($$.val, "{%s}", $2.val);
  }
     | '-' term %prec NEG
  {
    sprintf($$.val, "-%s", $2.val);
  } 
     ;

operator : '+' 
  { HashTbl_setNodeType(HashTbl_insert(h, "+"), PN_OP_ARITH); }
         | '-'
  { HashTbl_setNodeType(HashTbl_insert(h, "-"), PN_OP_ARITH); }
         | '*'
  { HashTbl_setNodeType(HashTbl_insert(h, "*"), PN_OP_ARITH); }
         | '/'
  { HashTbl_setNodeType(HashTbl_insert(h, "/"), PN_OP_ARITH); }
         ;

/* id_term: not NUMBER */
term : indexed_term 
  { strcpy($$.val, $1.val);   
    $$.type = _T_INDEX; 
    HashTbl_setNodeType(HashTbl_insert(h, $1.val), PN_INDEXED_VAR);
  }
     | ID 
  { strcpy($$.val, $1.val); $$.type = _T_ID;   
    HashTbl_setNodeType(HashTbl_insert(h, $1.val), PN_VAR);
  }
     | NUMBER 
  { strcpy($$.val, $1.val); $$.type = _T_NUM; }
     | INFINITY
  { strcpy($$.val, "infty"); $$.type = _T_INF; }
     | greece_symbol
  { strcpy($$.val, $1.val); $$.type = _T_GREEK_SYMBOL; }
     | BRACKET_LEFT expr BRACKET_RIGHT /* a set */
  { sprintf($$.val, "{%s}", $2.val); $$.type = _T_SET; 
    HashTbl_setNodeType(HashTbl_insert(h, $$.val), PN_SET);
  }
     | EMPTY_SET
  {
    strcpy($$.val, "{}"); $$.type = _T_SET;
    HashTbl_setNodeType(HashTbl_insert(h, $$.val), PN_SET);
  }
     | DOTS
  {
    strcpy($$.val, "..."); 
    HashTbl_setNodeType(HashTbl_insert(h, $$.val), PN_NONE);
  }
     | fxn
  {
    strcpy($$.val, $1.val); $$.type = _T_FUNC;
    HashTbl_setNodeType(HashTbl_insert(h, $1.val), PN_FUNC_CALL);
  }
     | '(' expr_list ')'
  {
    sprintf($$.val, "(%s)", $2.val);
  }
     | QUAD /* empty space. ignore it. */
  {
    sprintf($$.val, "");
  }
     ;

greece_symbol : EPSILON
  { strcpy($$.val, "epsilon"); }
              | ALPHA
  { strcpy($$.val, "alpha"); }
              | BETA
  { strcpy($$.val, "beta"); }
              ;

indexed_term : INDEXED_ID expr_list '}'
  { sprintf($$.val, "%s%s}", $1.val, $2.val); }
             ;

expr_list : expr_list ',' expr
  { sprintf($$.val, "%s, %s", $1.val, $3.val); }
          | expr
  { strcpy($$.val, $1.val); }
          ;

opt_hd : m_hdr term set_operator set '}'
  {
    sprintf($$.val, "%s(%s %s %s}", $1.val, $2.val, $3.val, $4.val);
    if (PNDEBUG) printf("%s{%s %s %s}\n", $1.val, $2.val, $3.val, $4.val);
    HashTbl_insertVarType(h, $4.val, cstr_SET);

    dpfe->opt_fxn->OPT = create_SymbolNode($1.val);
    dpfe->opt_fxn->decision_variable = create_SymbolNode($2.val);
    dpfe->opt_fxn->decision_operator = create_SymbolNode($3.val);
    dpfe->opt_fxn->decision_space = create_SymbolNode($4.val);
  }
      | m_hdr term '}'
  {
    sprintf($$.val, "%s{%s}", $1.val, $2.val);
    if (PNDEBUG) printf("%s{%s}\n", $1.val, $2.val);

    dpfe->opt_fxn->OPT = create_SymbolNode($1.val);
    dpfe->opt_fxn->decision_variable = create_SymbolNode($2.val);

    // use empty string value, to avoid NULL pointer error.
    dpfe->opt_fxn->decision_operator = create_SymbolNode("");
    dpfe->opt_fxn->decision_space = create_SymbolNode("");
  }
         ;

m_hdr : MIN_HEAD
  {
    strcpy($$.val, "MIN_"); 
    HashTbl_setNodeType(HashTbl_insert(h, "MIN"), PN_FUNC_CALL);
  }
      | MAX_HEAD
  { 
    strcpy($$.val, "MAX_"); 
    HashTbl_setNodeType(HashTbl_insert(h, "MAX"), PN_FUNC_CALL);
  }
      ;

set : expr
  {
    strcpy($$.val, $1.val);
    HashTbl_setNodeType(HashTbl_insert(h, $$.val), PN_SET);
  }
    | BRACKET_LEFT expr ',' DOTS ',' expr BRACKET_RIGHT
  {
    sprintf($$.val, "{%s, ..., %s}", $2.val, $6.val);
    HashTbl_setNodeType(HashTbl_insert(h, $$.val), PN_SET);
  }
    | BRACKET_LEFT expr ',' expr BRACKET_RIGHT
  {
    sprintf($$.val, "{%s, %s}", $2.val, $5.val);
    HashTbl_setNodeType(HashTbl_insert(h, $$.val), PN_SET);
  }
    ;

set_operator : IN     
  { strcpy($$.val, "IN"); 
    HashTbl_setNodeType(HashTbl_insert(h, "IN"), PN_OP_SET);
  }
             | NOTIN  
  { strcpy($$.val, "NOT_IN"); 
    HashTbl_setNodeType(HashTbl_insert(h, "NOT_IN"), PN_OP_SET);
  }
             | CUP /* union */ 
  { 
    strcpy($$.val, "SETUNION"); 
    //printf("cup: %s\n", $$.val); 
    HashTbl_setNodeType(HashTbl_insert(h, "UNION"), PN_OP_SET);
  }
             ;

condition : MBOX '{' IF logic_expr dot '}' dot
  {
    sprintf($$.val, "%s", $4.val);
    get_DPFE_cond(dpfe, typeOfFormula, $$.val);
  }
          | MBOX '{' OTHERWISE dot '}' dot
  {
    sprintf($$.val, "otherwise");
    get_DPFE_cond(dpfe, typeOfFormula, $$.val);
  }
          ;

dot : /* empty */
    | PERIOD
    | ','
    ;

logic_expr : relation_expr logic_op relation_expr
  {
    sprintf($$.val, "%s %s %s", $1.val, $2.val, $3.val);
  }
           | relation_expr
  {
    sprintf($$.val, "%s", $1.val);
  }
           ;

relation_expr : '$' relation_expr_list '$'
  {
    sprintf($$.val, "%s", $2.val); 
  }
              ;

relation_expr_list : expr relation_op expr
  {
    sprintf($$.val, "%s %s %s", $1.val, $2.val, $3.val);
  }
                   | relation_expr_list relation_op expr
  {
    sprintf($$.val, "%s %s %s", $1.val, $2.val, $3.val);
  }
                   ;

logic_op : AND
  {
    strcpy($$.val, "and");
  }
         | OR
  {
    strcpy($$.val, "or");
  }
         ;

relation_op : 
          LT
  { strcpy($$.val, "<"); }
        | GT
  { strcpy($$.val, ">"); }
        | EQ
  { strcpy($$.val, "="); }
        | NE
  { strcpy($$.val, "!="); }
        | LE
  { strcpy($$.val, "<="); }
        | GE
  { strcpy($$.val, ">="); }
        ;

%%

void writeHeader(FILE * fp) {
  fprintf(fp, "BEGIN\n\n");
  fprintf(fp, "  NAME %s;\n\n", dpfe->module_name);
}


void writeFooter(FILE * fp) {
  fprintf(fp, "%s", "END\n");
}


/*
char * _get_symbol_type(SymbolType type) {
  if (type == _NUM) return cstr_INT;
  else if (type == _SET) return cstr_SET;
  else return "";
}
*/


// called in write_parse_result() for debug use only.
void write_dpfe_opt_fxn(DPFE * d) {
  TermNode * t;
  TermNode * list;

  printf("%s{", d->opt_fxn->OPT->symbol);
  printf("%s ", d->opt_fxn->decision_variable->symbol);
  printf("%s ", d->opt_fxn->decision_operator->symbol);
  printf("%s}", d->opt_fxn->decision_space->symbol);

  printf(" { ");
  list = d->opt_fxn->terms;
  for (t = list; t != NULL; t  = t->next) {
    printf("%s ", t->term->symbol);
  }
  printf(" }\n");
}



BOOL isGoalFunc(char * gf_name, char * s) {
  int len = strlen(gf_name);
  if (strncmp(gf_name, s, len) == 0 &&
      s[len] == '(') return 1; 
  return 0;
}


/* write the goal function parameters, plus the decision var. */
void write_DPFE_param_set(FILE * fp, DPFE * d) {
  SymbolNode * n;
  fprintf(fp, "(");
  for (n = d->gf->params; n != NULL; n = n->next) {
    fprintf(fp, "%s, ", getAlias(n->symbol));
  }
  fprintf(fp, "%s)", getAlias(d->opt_fxn->decision_variable->symbol));
}


/* write the goal function parameters. */
void write_DPFE_param_list(FILE * fp, DPFE * d) {
  SymbolNode * n;
  fprintf(fp, "(");
  for (n = d->gf->params; n != NULL; n = n->next) {
    if (n != d->gf->params) fprintf(fp, ", ");
    fprintf(fp, "%s", getAlias(n->symbol));
  }
  fprintf(fp, ")");
}


// format: e.g., c_{v, d}.
// need to break this down into indivisual tokens,
// first by the first "_{", then by "," inside {..}.
void writeIndexedID(FILE * fp, char * s) {
  int i;
  char * p = str_dup(s);
  char * q;
  char * pos = strstr(p, "_{");
  if (pos == NULL) { return; } // shouldn't happen.

  pos[0] = 0; // in the example, now p: c, pos + 1: {v, d}.
  fprintf(fp, getAlias(p));

  p = trim(pos + 1, "{}"); // p: v, d
  for (p = strtok(p, ","); p != NULL; p = strtok(NULL, ",")) {
    fputc('[', fp);
    pos = q = str_dup(p); 
    q = trim(q, " ");
    i = 0;
    if (strstr(q, " ") == NULL) {
      fprintf(fp, getAlias(q));
    } else {
      for (q = strtok(q, " "); q != NULL; q = strtok(NULL, " ")) {
        if (i ++ > 0) fputc(' ', fp);
        fprintf(fp, "%s", getAlias(q));
      }
    }
    free(pos);
    fputc(']', fp);
  }
  free(p);
}


void write_reward_func(FILE * fp, DPFE * d) {
  TermNode * tn;
  TermNode * next;
  int term_count;

  fprintf(fp, "REWARD_FUNCTION:\n");
  fprintf(fp, "  r");
  write_DPFE_param_set(fp, d);
  fprintf(fp, " = \n    ");

  tn = d->opt_fxn->terms;
  term_count = 0;
/*
  for (; tn != NULL; tn = tn->next) {
    if (tn->type == _T_FUNC &&
        isGoalFunc(d->gf->f_name, tn->term->symbol)) {
      // don't write this.
    } else if (tn->type == _T_FUNC) {
      //fprintf(fp, " %s ", getAlias(tn->term->symbol));
      write_params(fp, tn->term->symbol);
      term_count ++;
    } else if (tn->type == _T_OPERATOR) {
      next = tn->next;
      if (next->type == _T_FUNC &&
          isGoalFunc(d->gf->f_name, next->term->symbol)) {
        continue;
      }
      if (term_count == 0 && 
          strcmp("+", tn->term->symbol) == 0) continue;
      fprintf(fp, " %s ", getAlias(tn->term->symbol));
    } else if (tn->type == _T_INDEX) {
      writeIndexedID(fp, tn->term->symbol);
      term_count ++;
    } else {
      fprintf(fp, " %s ", getAlias(tn->term->symbol));
      term_count ++;
    }
  }
*/
  for (; tn != NULL; tn = tn->next) {
    if (tn->label == 0) {
      if (tn->type == _T_FUNC) {
        write_params(fp, tn->term->symbol);
      } else if (tn->type == _T_INDEX) {
        writeIndexedID(fp, tn->term->symbol);
      } else { // operator etc.
        if (term_count == 0 &&
            strcmp("+", tn->term->symbol) == 0) continue;
        fprintf(fp, " %s ", getAlias(tn->term->symbol));
      }
      term_count ++;
    }
  }

  if (term_count == 0) { fprintf(fp, " 0 "); }

  fprintf(fp, ";\n\n");
}


/*
 * Called by write_params() only.
 */
static void output_token(FILE * fp) {
  if (strlen(LSTR) > 0) {
    //printf("output param %s\n", LSTR);
    fprintf(fp, "%s", getAlias(LSTR));
    LSTR[0] = 0; // reset to empty string.
  }
}


/*
 * Called by write_transform_func(DPFE * d).
 *
 * The format is like: (k + 1, j), or (d, S SETUNION {d})
 * 1) quoted by "(" and ")",
 * 2) quoted by "{" and "}"
 * 3) terms are separated by ",",
 * 4) each term may have multiple tokens separated by " ".
 * 5) there are be recursion in this hierarchy.
 * 6) it can be indexed item like a_{2}.
 *
 * Solution:
 * For each token:
 * if it is "(", ")", "{", "}", "," or " ", 
 *   output getAlias(token) and output it;
 * else, output getAlias(token);
 *
 * This can be used to write a general expression too,
 * where the array and indexed items will be appropriately handled.
 */
void write_params(FILE * fp, char * s) {
  char * p = s;
  char c, next_c;
  int isIndexedItem = 0;
  int index_nest_level;
  int nest_level = 0;
  //printf("...................%s\n", s);
  //fprintf(fp, "%s;\n", getAlias(p)); return;
  LSTR_clear();
  LSTR_new();
  
  for (; *p != 0; p ++) {
    c = *p;
    next_c = *(p+1);

    if (c == '_' && next_c == '{' && isIndexedItem == 0) {
      output_token(fp);
      //fprintf(fp, "[");
      LSTR_append_char('[');
      isIndexedItem = 1;
      index_nest_level = nest_level;
      p ++;
    } else if (c == '}' && isIndexedItem == 1 && 
               index_nest_level == nest_level) {
      LSTR_append_char(']');
      isIndexedItem = 0;
      output_token(fp);
    } else if (c == '(' || c == '{') { 
      output_token(fp);
      fprintf(fp, "%c", c);
      nest_level ++;
    } else if (c == ')' || c == '}') {
      output_token(fp);
      fprintf(fp, "%c", c);
      nest_level --;
    } else if (c == ',' || c == ' ') {
      output_token(fp);
      fprintf(fp, "%c", c);
    } else { // add to token
      LSTR_append_char(c);
    }
  }
  // output the last token
  output_token(fp);

  LSTR_clear();
}


static void write_transform_func(FILE * fp, DPFE * d) {
  int len, term_count;
  char * p;
  TermNode * tn;
  TermNode * next;

  fprintf(fp, "TRANSFORMATION_FUNCTION:\n");

  len = strlen(d->gf->f_name); // goal function name len.

  tn = d->opt_fxn->terms;
  term_count = 0;
  for (; tn != NULL; tn = tn->next) {
    if (tn->type == _T_FUNC &&
        isGoalFunc(d->gf->f_name, tn->term->symbol)) {
      term_count ++;
      fprintf(fp, "  t%d", term_count);
      write_DPFE_param_set(fp, d);
      fprintf(fp, " = ");

      p = tn->term->symbol + len; // 
      write_params(fp, p);
      fprintf(fp, ";\n");
    } else {
      // do nothing
    }
  }

  fprintf(fp, "\n\n");
}


void write_DPFE(FILE * fp, DPFE * d) {
  TermNode * tn;
  TermNode * next;
  SymbolNode * n;
  int gf_count;

  fprintf(fp, "DPFE:\n");
  fprintf(fp, "  %s", d->gf->f_name);
  write_DPFE_param_list(fp, d);

  if (strlen(d->opt_fxn->decision_operator->symbol) == 0) {
    fprintf(fp, "\n    = %s{%s}\n",
              getAlias(d->opt_fxn->OPT->symbol),
              getAlias(d->opt_fxn->decision_variable->symbol));
  } else {
    fprintf(fp, "\n    = %s{%s %s decisionSet}\n", 
              getAlias(d->opt_fxn->OPT->symbol), 
              getAlias(d->opt_fxn->decision_variable->symbol),
              getAlias(d->opt_fxn->decision_operator->symbol));
  }

  fprintf(fp, "    {\n      ");
  tn = d->opt_fxn->terms;
  gf_count = 0;
/*
  for (; tn != NULL; tn = tn->next) {
    if (tn->type == _T_FUNC && 
        isGoalFunc(d->gf->f_name, tn->term->symbol)) {
      gf_count ++;
      fprintf(fp, "%s(t%d", getAlias(d->gf->f_name), gf_count);
      write_DPFE_param_set(fp, d);
      fprintf(fp, ") + ");
    } else if (tn->type == _T_OPERATOR) {
      next = tn->next;
      if (next->type == _T_FUNC &&
          isGoalFunc(d->gf->f_name, tn->term->symbol)) {
        fprintf(fp, "%s ", getAlias(tn->term->symbol));
      }
    }
  }
*/
  for (; tn != NULL; tn = tn->next) {
    if (tn->label == 0) { // part of reward function, ignore.
      // ignore.
    } else if (tn->label == -1) {
      if (strcmp(tn->term->symbol, "-") == 1) {
        //fprintf(fp, "%s ", getAlias(tn->term->symbol)); // +-.
        fprintf(fp, "(-1) * ");
      }
    } else {
      if (tn->type == _T_FUNC &&
          isGoalFunc(d->gf->f_name, tn->term->symbol)) {
        fprintf(fp, "%s(t%d", getAlias(d->gf->f_name), tn->label);
        write_DPFE_param_set(fp, d);
        fprintf(fp, ") + ");
      } else {
        fprintf(fp, "%s ", getAlias(tn->term->symbol));
      } // end of else.
    } // end of else.
  }
  fprintf(fp, " r");
  write_DPFE_param_set(fp, d);
  fprintf(fp, "");
  fprintf(fp, "\n    };\n\n");
}


void write_decision_space(FILE * fp) {
  fprintf(fp, "DECISION_SPACE: ");
  fprintf(fp, "decisionSet(");
  write_GoalFunction_params(fp, dpfe->gf->params);
  if (strlen(dpfe->opt_fxn->decision_space->symbol) == 0) {
    fprintf(fp, ") = UNDEFINED\n\n");
  } else {
    fprintf(fp, ") = "); 
    write_params(fp, dpfe->opt_fxn->decision_space->symbol);
    fprintf(fp, ";\n\n");
  }
}


void dump_opt_fxn_term(TermNode * t) {
  if (t == NULL) return;
  printf("%s\t[label=%d]\n", t->term->symbol, t->label);
}
void dump_opt_fxn_terms(TermNode * t) {
  for (; t != NULL; t = t->next) dump_opt_fxn_term(t);
}
void dump_opt_fxn_terms_rev(TermNode * t) {
  for (; t != NULL; t = t->prev) dump_opt_fxn_term(t);
}


// p_label : label of precessor node.
void label_dpfe_opt_fxn_terms(DPFE_OPT_FUNCTION * opt_fxn) {
  int label;
  TermNode *s, * t;
  if (NULL == (t = opt_fxn->terms)) return;
  if (PNDEBUG) {
    //puts("---head to tail:"); dump_opt_fxn_terms(t);
    //puts("---tail to head:"); dump_opt_fxn_terms_rev(opt_fxn->terms_tail);
  }

  label = 1;
  for (; t != NULL; t = t->next) {
    if (t->type == _T_FUNC &&
        isGoalFunc(dpfe->gf->f_name, t->term->symbol)) {
      // label t's [*/^]-connected kneighbors.
      // predecessors
      for (s = t->prev; s != NULL; s = s->prev) {
        if (s->type == _T_OPERATOR && (
            strcmp(s->term->symbol, "+") == 0 ||
            strcmp(s->term->symbol, "-") == 0 )) {
          s->label = -1; // sign of the goal function call!!!
          break;
        }
        s->label = label;
      }
      // successors
      for (; t != NULL; t = t->next) {
        if (t->type == _T_OPERATOR && (
            strcmp(t->term->symbol, "+") == 0 ||
            strcmp(t->term->symbol, "-") == 0 )) break;
        t->label = label;
      }
      if (NULL == t) break;
      label ++;
    }
  }

  if (PNDEBUG) {
    puts("--after labeling--");
    puts("---head to tail:"); dump_opt_fxn_terms(opt_fxn->terms);
    //puts("---tail to head:"); dump_opt_fxn_terms_rev(opt_fxn->terms_tail);
  }
}


void write_parse_result(FILE * fp) {
  SymbolNode * a;
  char * type;

if (PNDEBUG) { puts("start of STATE_TYPE"); }

  fprintf(fp, "STATE_TYPE: (");
  for (a = dpfe->gf->params; a != NULL; a = a->next) {
    if (a != dpfe->gf->params) fprintf(fp, ", ");
    type = getHashNodeTypeName(HashTbl_find(h, a->symbol));
    fprintf(fp, "%s%s%s", type, (strlen(type) > 0)?" ":"", 
            getAlias(a->symbol));
  }
  fprintf(fp, ");\n\n");
if (PNDEBUG) { puts("end of STATE_TYPE"); }

  // DECISION_VAR
  fprintf(fp, "DECISION_VARIABLE: ");
  a = dpfe->opt_fxn->decision_variable;
  if (a != NULL) {
    printf("decision var: %s\n", a->symbol);
    type = getHashNodeTypeName(HashTbl_find(h, a->symbol));
    if (NULL != type) {
      fprintf(fp, "%s%s%s;\n", type, (strlen(type) > 0)?" ":"", 
              getAlias(a->symbol));
    }
  }

  // DECISION SPACE
  write_decision_space(fp);

  write_goal(fp, dpfe);
  write_dpfe_base(fp, dpfe);

  label_dpfe_opt_fxn_terms(dpfe->opt_fxn); // label terms.

  // DPFE
  write_DPFE(fp, dpfe);
if (PNDEBUG) {
  puts("==opt_fxn=="); write_dpfe_opt_fxn(dpfe); // dump
}

  // REWARD_FUNCTION
  write_reward_func(fp, dpfe);

  // TRANSFORM_FUNCTION
  write_transform_func(fp, dpfe);
}


/*
 * If infile ends with suffix ".i", replace it with ".o".
 * Otherwise append ".o" to infile.
 */
char * get_output_filename(char * infile) {
  int len = strlen(infile);
  if (infile[len-1] == 'i') { infile[len-1] = 'o'; }
  else { strcat(infile, ".o"); }
  return infile;
}


char * get_module_name(char * n) {
  if (strncmp(n, "-n=", 3) == 0) {
    return n + 3;
  }
  return "ModuleName";
}


static void writeHelpMsg() {
  puts("Usage: ./pn infile [-ah]");
  puts("  -h - print this help message");
  puts("  -a - turn on the alias feature");
}


static void init() {
  OPT_ALIAS = 0;
  init_const(); // in const.c
}


static int preprocess(int argc, char ** argv) {
  if (argc < 2) {
    printf("Usage: ./pn infile [-ah]\n");
    return -1;
  }
  if (argc == 2 && strcmp(argv[1], "-h") == 0) {
    writeHelpMsg();
    return 0;
  }
  if (argc >= 3) { 
    // always assume that argv[1] is input file, argv[2] is switch.
    if (strcmp(argv[2], "-a") == 0) {
      OPT_ALIAS = 1;
    } else if (strcmp(argv[2], "-h") == 0) {
      writeHelpMsg();
      return 0;
    }
  }
  return 1; // succeed.
}


void write_base(DPFE * d) {
  DPFE_BASE * b;

  if ((b = d->base) == NULL) {
    puts("DPFE BASE is empty");
    return;
  }

  for (; b != NULL; b = b->next) {
    printf("DPFE BASE: %s WHEN %s\n", b->value->symbol, 
                            b->cond->condition->symbol);
  }

  printf("OPT COND: %s\n", d->opt_fxn->cond->condition->symbol);
}


int main(int argc, char ** argv) {
  extern FILE * yyin;
  FILE * fp;
  char * filename;
  int valid;

  init();
  if ((valid = preprocess(argc, argv)) <= 0) return valid;

  if ((yyin = fopen(argv[1], "r")) == NULL) { // open input
    printf("Cannot open input file %s\n", argv[1]);
    return -1;
  }
  filename = get_output_filename(argv[1]);
  if ((fp = fopen(filename, "w")) == NULL) {
    printf("cannot open file %s\n", filename);
    exit(1);
  }
  LSTR = NULL; // to hold very long string.
  LSTR_max_size = 2;
  dpfe = create_DPFE();
  h = HashTbl_create();

  yyparse();
  fclose(yyin);

  if (PNDEBUG) { write_base(dpfe); }

  writeHeader(fp);
  writeGeneralVar(fp, dpfe);
  writeSetVar(fp, dpfe);
  writeGeneralFunctions(fp, dpfe);

  write_parse_result(fp);
  writeFooter(fp);

  fclose(fp);

  HashTbl_dump(h);
  return 0;
}


