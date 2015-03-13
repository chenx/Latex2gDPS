/*
 * spc.c - functions for SPC module
 */

#include "spc.h"

void SPC_getDimension(DPFE * dpfe, char * name, char * value, 
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}

void SPC_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void SPC_writeSetVal(FILE * fp, DPFE * d) {
  fprintf(fp, "SET_VARIABLES_BEGIN\n");
  // Assume the names of the sets fixed.
  fprintf(fp, "  Set goalSet = {0};\n");
  fprintf(fp, "SET_VARIABLES_END\n\n");
}


void SPC_writeGeneralFunctions(FILE * fp, DPFE * d) {
  PARAMS_STRUCT * p = d->params_struct;
  if (NULL == p) { return; }
  fprintf(fp, "GENERAL_FUNCTIONS_BEGIN\n");
  fprintf(fp, "  private static NodeSet possibleNextNodes(int node) { \n");
  fprintf(fp, "    NodeSet result = new NodeSet(); \n");
  fprintf(fp, "    for (int i=0; i<distance[node].length; i++) { \n");
  fprintf(fp, "      if (%s[node][i]!=infty) {i \n", getAlias(p->name));
  fprintf(fp, "        result.add(new Integer(i)); \n");
  fprintf(fp, "      } \n");
  fprintf(fp, "    } \n");
  fprintf(fp, "    return result; \n");
  fprintf(fp, "  } \n");
  fprintf(fp, "GENERAL_FUNCTIONS_END\n\n");
}


void SPC_writeGoal(FILE * fp, DPFE * d) {
  // do nothing
}


void SPC_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  MACRO_writeDpfeBase(fp, d);
  // else, default base.
}

