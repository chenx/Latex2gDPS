/*
 * scp.c - functions for SCP module
 */

#include "scp.h"

void SCP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}

void SCP_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void SCP_writeSetVal(FILE * fp, DPFE * d) {
  // do nothing
}


void SCP_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // do nothing
}


void SCP_writeGoal(FILE * fp, DPFE * d) {
  // do nothing
}


void SCP_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  MACRO_writeDpfeBase(fp, d);
  // else, default base.
  // don't know how to specify n, is it the size of dimension array?
  PARAMS_STRUCT * p = d->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(g, x) = 0 if x = %d\n", 
          getAlias(d->gf->f_name), p->size - 1);
}

