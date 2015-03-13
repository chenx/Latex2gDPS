/*
 * mcm.c - functions for MCM module
 */

#include "mcm.h"


void MCM_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}


void MCM_writeGoal(FILE * fp, DPFE * d) {
  PARAMS_STRUCT * p = dpfe->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(1, %d)\n", getAlias(d->gf->f_name),
          p->size - 1);
}


void MCM_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  MACRO_writeDpfeBase(fp, d);
  // else, default base.
  PARAMS_STRUCT * p = dpfe->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  FOR(i = 1; i <= %d; i ++) {\n",
          p->size - 1);
  fprintf(fp, "    %s(i, i) = 0.0;\n", getAlias(d->gf->f_name));
  fprintf(fp, "  }\n");
}


void MCM_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // empty
}


void MCM_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void MCM_writeSetVal(FILE * fp, DPFE * d) {
  // empty
}

