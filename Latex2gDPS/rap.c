/*
 * rap.c - functions for RAP module
 */

#include "rap.h"


void RAP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}


void RAP_writeGoal(FILE * fp, DPFE * d) {
  PARAMS_STRUCT * p = dpfe->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(1, %d)\n", getAlias(d->gf->f_name),
          p->size - 1);
}


void RAP_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  MACRO_writeDpfeBase(fp, d);
  // else, default base.
}


void RAP_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // empty
}


void RAP_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void RAP_writeSetVal(FILE * fp, DPFE * d) {
  // empty
}

