/*
 * ks01.c - functions for KS01 module
 */

#include "ks01.h"


void KS01_getDimension(DPFE * dpfe, char * name, char * value,
                       DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}


void KS01_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void KS01_writeSetVal(FILE * fp, DPFE * d) {
  // empty
}


void KS01_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // empty
}


void KS01_writeGoal(FILE * fp, DPFE * d) {
  PARAMS_STRUCT * p = dpfe->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(1, %d)\n", getAlias(d->gf->f_name),
          p->size - 1);
}


void KS01_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  MACRO_writeDpfeBase(fp, d);
  // else, default base.
}


