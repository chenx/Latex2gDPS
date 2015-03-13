/*
 * lsp.c - functions for LSP module
 */

#include "lsp.h"

void LSP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}

void LSP_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void LSP_writeSetVal(FILE * fp, DPFE * d) {
  // do nothing
}


void LSP_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // do nothing
}


void LSP_writeGoal(FILE * fp, DPFE * d) {
  // do nothing
}


void LSP_writeDpfeBase(FILE * fp, DPFE * d) {
  // if module_base is in declaration, write it.
  if (d->module_base != NULL) {
    ModuleBase * mb;
    for (mb = d->module_base; mb != NULL; mb = mb->next) {
      fprintf(fp, "  %s;\n", mb->base);
    }
    return;
  }
  // otherwise, write that in the formula
  if (d->base != NULL) {
    DPFE_BASE * db;
    for (db = d->base; db != NULL; db = db->next) {
      fprintf(fp, "  %s", getAlias(d->gf->f_name));
      write_DPFE_param_list(fp, d);
      fprintf(fp, " = %s WHEN %s;\n", 
              db->value->symbol, 
              db->cond->condition->symbol);
    }
    return;
  }
  // otherwise, write default
  // don't know how to specify n, is it the size of dimension array?
  PARAMS_STRUCT * p = d->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(g, x) = 0 if x = %d\n", 
          getAlias(d->gf->f_name), p->size - 1);
}

