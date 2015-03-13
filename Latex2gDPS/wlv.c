/*
 * wlv.c - functions for WLV module
 */

#include "wlv.h"


void WLV_getDimension(DPFE * dpfe, char * name, char * value,
                       DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}


void WLV_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void WLV_writeSetVal(FILE * fp, DPFE * d) {
  // empty
}


void WLV_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // empty
}


void WLV_writeGoal(FILE * fp, DPFE * d) {
  PARAMS_STRUCT * p = dpfe->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "  %s(1, %d)\n", getAlias(d->gf->f_name),
          p->size - 1);
}


void WLV_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  MACRO_writeDpfeBase(fp, d);
  // else, default base.
/*
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
      fprintf(fp, "  %s", d->gf->f_name);
      write_DPFE_param_list(fp, d);
      fprintf(fp, " = %s WHEN %s;\n", 
              db->value->symbol, 
              db->cond->condition->symbol);
    }
  }
  // else, write default.
*/
}


