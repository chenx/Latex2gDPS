/*
 * ilp.c - functions for ILP module
 */

#include "ilp.h"


void ILP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}


void ILP_writeGoal(FILE * fp, DPFE * d) {
  PARAMS_STRUCT * p = dpfe->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(0, {})\n", getAlias(d->gf->f_name));
}


void ILP_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  MACRO_writeDpfeBase(fp, d);
  // else, default base.
}


void ILP_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // empty
}


void ILP_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void ILP_writeSetVal(FILE * fp, DPFE * d) {
  // empty
}

