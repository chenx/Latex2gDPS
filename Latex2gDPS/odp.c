/*
 * odp.c - functions for ODP module
 */

#include "odp.h"


void ODP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}


void ODP_writeGoal(FILE * fp, DPFE * d) {
  PARAMS_STRUCT * p = dpfe->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(1, %d)\n", getAlias(d->gf->f_name),
          p->size - 1);
}


void ODP_writeDpfeBase(FILE * fp, DPFE * d) {
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


void ODP_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // empty
}


void ODP_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void ODP_writeSetVal(FILE * fp, DPFE * d) {
  // empty
}

