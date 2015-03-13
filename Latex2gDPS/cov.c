/*
 * cov.c - functions for COV module
 */

#include "cov.h"


void COV_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}


void COV_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void COV_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // empty
}


void COV_writeSetVal(FILE * fp, DPFE * d) {
  // empty
}


void COV_writeGoal(FILE * fp, DPFE * d) {
  PARAMS_STRUCT * p = dpfe->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(1, %d)\n", getAlias(d->gf->f_name),
          p->size - 1);
}


void COV_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  MACRO_writeDpfeBase(fp, d);
  // else, default base.
}

