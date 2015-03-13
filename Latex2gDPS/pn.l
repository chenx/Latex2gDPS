%{  
/*
 * Xin Chen.
 * @Created on: Feb. 26, 2007
 * @Last modified: April 30, 2007
 */
#include "y.tab.h" 

void get_s();

typedef struct {
  char val[100]; /* should be long enough to hold an expression. */
} yystype;

#define YYSTYPE yystype
extern YYSTYPE yylval;

#define LINE_LEN 128
char line[LINE_LEN]; // for debug print.
int line_ct = 1;
int col = 0;
%}

alph    [a-zA-Z]
digit   [0-9]

%%

"$ModuleName$"         { get_s(); return MODULE_NAME; }
"$ModuleType$"         { get_s(); return MODULE_TYPE; }
"$Dimension$"          { get_s(); return DIMENSION; }
"$ModuleGoal$"         { get_s(); return MODULE_GOAL; }
"$ModuleBase$"         { get_s(); return MODULE_BASE; }
"$Alias$"              { get_s(); return ALIAS; }
"$DataType$"           { get_s(); return DATA_TYPE; }
\\"emptyset"           { get_s(); return EMPTY_SET; }
\{\}                   { get_s(); return EMPTY_SET; }
\\quad                 { get_s(); return QUAD; }
\\alpha                { get_s(); return ALPHA; }
\\beta                 { get_s(); return BETA; }
\\epsilon              { get_s(); return EPSILON; }
\\begin                { get_s(); return BEGIN; }
\\end                  { get_s(); return END; }
\{declaration\}        { get_s(); return DECLARATION; } 
\{equation\}           { get_s(); return EQN; }
\{array\}              { get_s(); return ARRAY; }
\\left                 { get_s(); return LEFT; }
\\right                { get_s(); return RIGHT; }
\\\{                   { get_s(); return BRACKET_LEFT; }
\\\}                   { get_s(); return BRACKET_RIGHT; }
\{l+\}                 { get_s(); return LL; } /* 1 or more l. */
\\displaystyle         { get_s(); return DISP_STYLE; }
\\notin                { get_s(); return NOTIN; }
\\ne                   { get_s(); return NE; }
\\le                   { get_s(); return LE; }
\\ge                   { get_s(); return GE; }
">"                    { get_s(); return GT; }
"<"                    { get_s(); return LT; }
=                      { get_s(); return EQ; }
and                    { get_s(); return AND; }
or                     { get_s(); return OR; }
\\cup                  { get_s(); return CUP; }
\\label                { get_s(); return LABEL; }
\\min"_"\{             { get_s(); return MIN_HEAD; }
\\max"_"\{             { get_s(); return MAX_HEAD; }
\\infty                { get_s(); return INFINITY; }
\\in                   { get_s(); return IN; }
\\ldots                { get_s(); return DOTS; }
\\mbox                 { get_s(); return MBOX; }
\\\\                   { get_s(); return NEW_LINE; }
if                     { get_s(); return IF; }
otherwise              { get_s(); return OTHERWISE; }
"."                    { get_s(); return PERIOD; }
{digit}+               { get_s();
                         strcpy(yylval.val, yytext); 
                         return NUMBER;        }
{alph}({alph}|{digit}|"_")*"_"\{  { get_s();
                               strcpy(yylval.val, yytext);
                               return INDEXED_ID; }
{alph}({alph}|{digit}|"_")*"(" { get_s(); 
                                 strcpy(yylval.val, yytext);
                                 return FXN_NAME;
                               }
{alph}({alph}|{digit}|"_")*  { get_s();
                               strcpy(yylval.val, yytext); 
                               return ID; }
(" "|\t)*             { get_s(); }
\n                    { memset(line, 0, LINE_LEN); col = 0; line_ct ++; }
"+"|"-"|"*"|"/"       { line[col ++] = yytext[0];
                        line[col] = 0;
                        yytext[1] = 0;
                        strcpy(yylval.val, yytext);
                        return yytext[0]; }
.                     { line[col ++] = yytext[0];  
                        line[col] = 0; // end of string
                        yytext[1] = 0;
                        return yytext[0]; }

%%
int yywrap() {}

void get_s() {
  strcpy(& line[col], yytext);
  col += strlen(yytext);
//printf("get_s: yytext: %s\n", yytext);
}

void yyerror(char *mes) {
  int i;
  //printf("%s\n", mes);
  printf("syntax error (line: %d, col: %d) at '%s':\n", line_ct, col, yytext);
  printf("%s\n", line);
  for (i = 0; i < col - 1; i ++) printf(" ");
  printf("^\n");
}

