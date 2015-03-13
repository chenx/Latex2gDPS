/*
 * tsp.c - functions for TSP module
 */

#include "tsp.h"


/*
 * For the type, see [Holger] p172 B.17).
 * Valid values: 1, 2
 */
static int TSP_type(DPFE * d) {
  char * s = d->opt_fxn->decision_operator->symbol;
  if (strcmp(s, "NOT_IN") == 0) { return 1; }
  else if (strcmp(s, "IN") == 0) { return 2; }
  else {
    printf("warning: unknown TSP type. decision operator: %s\n", s);
    return -1;
  }
}


void TSP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type) {
  MACRO_getDimension(dpfe, name, value, type);
}


void TSP_writeGeneralVal(FILE * fp, DPFE * d) {
  MACRO_writeGeneralVar(fp, d);
}


void TSP_writeSetVal(FILE * fp, DPFE * d) {
  int type = TSP_type(d);
  fprintf(fp, "SET_VARIABLES_BEGIN\n");
  // Assume the names of the sets fixed.
  fprintf(fp, "  Set setOfAllNodes = {0, .., %d};\n",
          d->params_struct->size - 1);
  if (type == 1) {
    fprintf(fp, "  Set goalSet = {0};\n");
  } else if (type == 2) {
    fprintf(fp, "  Set emptySet = {};\n");
  } else {
    fprintf(fp, "  // warning: unknown TSP type\n");
  }
  fprintf(fp, "SET_VARIABLES_END\n\n");
}


void TSP_writeGeneralFunctions(FILE * fp, DPFE * d) {
  // empty
}


void TSP_writeGoal(FILE * fp, DPFE * d) {
  int type = TSP_type(d);
  if (type == 1) {
    fprintf(fp, "  %s(0, goalSet) ", getAlias(d->gf->f_name));
    fprintf(fp, "  // that is: (0, {0})\n");
  } else if (type == 2) {
    int i;
    PARAMS_STRUCT * p = d->params_struct;
    if (NULL == p) { return; }
    /// need to make sure V does not exist in the symbol table!!!
    fprintf(fp, "  %s(0, {1, .., %d}) ", getAlias(d->gf->f_name), p->size - 1);
    fprintf(fp, "  // that is: (0, V - {0})\n");
  } else {
    fprintf(fp, "  // don't know which goal function to use\n");
  }
}


void TSP_writeDpfeBase(FILE * fp, DPFE * d) {
  // if d->module_type != NULL or d->base != NULL.
  //MACRO_writeDpfeBase(fp, d);
  // else, default base.
  int i;
  int type = TSP_type(d);
  PARAMS_STRUCT * p = d->params_struct;
  if (NULL == p) { return; }

  if (type == 1) {
    fprintf(fp, "  // this base state should never happen\n");
    fprintf(fp, "  %s(0, setOfAllNodes) = 0.0;\n",
            getAlias(d->gf->f_name));
    fprintf(fp, "  // cost of going home from node i to node 0\n");
    fprintf(fp, "  %s(i, setOfAllNodes) = %s[i][0] when ((i > 0)&&(i < %d));\n",
            getAlias(d->gf->f_name), getAlias(p->name), p->size);
  } else if (type == 2) {
    fprintf(fp, "  // this base state should never happen\n");
    fprintf(fp, "  %s(0, emptySet) = 0.0;\n",
            getAlias(d->gf->f_name));
    fprintf(fp, "  // cost of going home from node i to node 0\n");
    fprintf(fp, "  %s(i, emptySet) = %s[i][0] when ((i > 0)&&(i < %d));\n",
            getAlias(d->gf->f_name), getAlias(p->name), p->size);
  } else {
    fprintf(fp, "  // warning: unknown TSP type\n");
  }
}

