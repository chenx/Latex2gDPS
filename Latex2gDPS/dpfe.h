#ifndef _DPFE_H_
#define _DPFE_H_

/*
 * dpfe.h - DPFE declarations 
 */

typedef enum {MT_BST, MT_COV, MT_ILP, MT_KS01, MT_LCS, MT_LSP, 
              MT_MCM, MT_ODP, MT_RAP, MT_SCP, MT_SPA, MT_SPC, 
              MT_TSP, MT_WLV, MT_UNKNOWN} ModuleType;
typedef enum {_NON, _NUM, _SET} SymbolType;
typedef enum {DT_TERM, DT_ARRAY, DT_MATRIX} DimensionType;

struct _SymbolNode {
  char * symbol;
  SymbolType type; // number, or set.
  struct _SymbolNode * next;
};
typedef struct _SymbolNode SymbolNode;
typedef SymbolNode * SymbolList;

typedef struct {
  char * f_name;
  SymbolList params;
} GoalFunction;


typedef enum {_T_ID, _T_NUM, _T_INF, _T_GREEK_SYMBOL, _T_SET, 
              _T_INDEX, _T_OPERATOR, _T_FUNC, _T_NON} TermType;

struct _TermNode {
  SymbolNode * term;
  TermType type;
  int label;
  struct _TermNode * prev;
  struct _TermNode * next;
};
typedef struct _TermNode TermNode;

struct _ConditionNode {
  SymbolNode * condition;
  struct _ConditionNode * next;
};
typedef struct _ConditionNode ConditionNode;

typedef struct {
  SymbolNode * OPT; // min or max
  SymbolNode * decision_variable;
  SymbolNode * decision_operator;
  SymbolNode * decision_space;
  TermNode * terms;
  TermNode * terms_tail;
  ConditionNode * cond;
} DPFE_OPT_FUNCTION;

/* used for the base obtained from the latex formula */
struct _DPFE_BASE {
  SymbolNode * value;
  ConditionNode * cond;
  struct _DPFE_BASE * next;
};
typedef struct _DPFE_BASE DPFE_BASE;

/* used for the base obtained from the declaration */
struct _ModuleBase {
  char * base;
  struct _ModuleBase * next;
};
typedef struct _ModuleBase ModuleBase;


typedef struct _PARAMS_STRUCT PARAMS_STRUCT;
struct _PARAMS_STRUCT {
  char * name;
  char * value;
  int size;
  DimensionType type;
  PARAMS_STRUCT * next;
};


/*
 */
typedef struct {
  PARAMS_STRUCT * params_struct; // parameter specific for each module type.
  PARAMS_STRUCT * params_struct_list_tail;
  ModuleType module_type; // specified by user
  char * module_name;  // specified by user
  char * module_goal;  // specified by user
  ModuleBase * module_base;  // specified by user
  GoalFunction * gf;
  DPFE_OPT_FUNCTION * opt_fxn;
  DPFE_BASE * base;
  DPFE_BASE * base_list_tail;
} DPFE;
DPFE * dpfe;


/* macro for getDimension() */
#define MACRO_getDimension(dpfe, v_name, v_value, v_type) \
{                                                    \
  PARAMS_STRUCT * p;                                 \
  printf("dimension: %s = {%s}\n", v_name, v_value); \
                                                     \
  PN_NEW(p, PARAMS_STRUCT, 1);                       \
  p->name = str_dup(v_name);                         \
  p->value = str_dup(v_value);                       \
  p->size = getParamListLen(v_value);                \
  p->type = v_type;                                  \
  p->next = NULL;                                    \
                                                     \
  /* insert at tail. */                              \
  if (NULL != dpfe->params_struct) {                 \
    ((PARAMS_STRUCT *)                               \
      dpfe->params_struct_list_tail)->next = p;      \
    dpfe->params_struct_list_tail = p;               \
  } else {                                           \
    dpfe->params_struct = p;                         \
    dpfe->params_struct_list_tail = p;               \
  }                                                  \
}


/* macro for writeGeneralVal() */
#define MACRO_writeGeneralVar(fp, dpfe) \
{                                                           \
  int infty_written = 0;                                    \
  PARAMS_STRUCT * p = dpfe->params_struct;                  \
  for (; p != NULL; p = p->next) {                          \
    if (infty_written == 0 &&                               \
        strstr(p->value, "infty") != NULL) {                \
      fprintf(fp, "  private static final int infty = ");   \
      fprintf(fp, "Integer.MAX_VALUE;\n");                  \
    }                                                       \
    if (p->type == DT_MATRIX) {                             \
      int i;                                                \
      char ** matrix;                                       \
      fprintf(fp, "  private static int[][] %s = {\n",      \
              getAlias(p->name));                           \
      matrix = getMatrix(p->value, & p->size);              \
      for (i = 0; i < p->size - 1; i ++) {                  \
        fprintf(fp, "  {%s},\n", matrix[i]);                \
      }                                                     \
      fprintf(fp, "  {%s}\n", matrix[i]);                   \
      fprintf(fp, "  };\n");                                \
    } else if (p->type == DT_ARRAY) {                       \
      fprintf(fp, "  private static int[] %s = {%s};\n",    \
              getAlias(p->name), p->value);                 \
    } else if (p->type == DT_TERM) {                        \
      /* for now, use "int" as default */                   \
      fprintf(fp, "  private static int %s = %s;\n",        \
              getAlias(p->name), p->value);                 \
    } else {                                                \
      printf("error: unknown dimension type for %s\n",      \
             getAlias(p->name));                            \
    }                                                       \
  }                                                         \
}


#define MACRO_writeDpfeBase(fp, dpfe) \
{                                                             \
  /* if module_base is in declaration, write it. */           \
  if (dpfe->module_base != NULL) {                            \
    ModuleBase * mb;                                          \
    for (mb = dpfe->module_base; mb != NULL; mb = mb->next) { \
      /*fprintf(fp, "  %s;\n", mb->base); */                  \
      fprintf(fp, "  ");                                      \
      write_params(fp, mb->base);                             \
      fprintf(fp, ";\n");                                     \
    }                                                         \
    return;                                                   \
  }                                                           \
  /* otherwise, write that in the formula */                  \
  if (dpfe->base != NULL) {                                   \
    DPFE_BASE * db;                                           \
    for (db = dpfe->base; db != NULL; db = db->next) {        \
      fprintf(fp, "  %s", getAlias(dpfe->gf->f_name));        \
      write_DPFE_param_list(fp, dpfe);                        \
                                                              \
      fprintf(fp, " = ");                                     \
      write_params(fp, db->value->symbol);                    \
      fprintf(fp, " WHEN ");                                  \
      write_params(fp, db->cond->condition->symbol);          \
      fprintf(fp, ";\n");                                     \
    }                                                         \
    return;                                                   \
  }                                                           \
  /* else, write default. */                                  \
}

#endif

