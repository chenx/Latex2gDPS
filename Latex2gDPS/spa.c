/*
 * spa.c - functions for SPA module
 */

#include "spa.h"


void SPA_getDimension(DPFE * dpfe, char * name, char * value, 
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}


void SPA_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void SPA_writeSetVal(FILE * fp, DPFE * d) {
  // empty
}


void SPA_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // empty.
}


void SPA_writeGoal(FILE * fp, DPFE * d) {
  fprintf(fp, "  %s(0)\n", d->gf->f_name);
}


void SPA_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  MACRO_writeDpfeBase(fp, d);
  // else, default base.
  PARAMS_STRUCT * p = d->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(%d) = 0;\n", d->gf->f_name, p->size - 1);
}

