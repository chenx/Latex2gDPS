/*
 * dpfe_api.c - DPFE API functions.
 */

#include "pn.h"
#include "dpfe.h"

#define DEBUG_API 1

void setModuleType(DPFE * d, char * name) {
#if DEBUG_API 
  puts("API.setModuleType");
#endif
  if      (0 == strcmp(name, cstr_BST)) { d->module_type = MT_BST; }
  else if (0 == strcmp(name, cstr_COV)) { d->module_type = MT_COV; }
  else if (0 == strcmp(name, cstr_ILP)) { d->module_type = MT_ILP; }
  else if (0 == strcmp(name, cstr_KS01)) { d->module_type = MT_KS01; }
  else if (0 == strcmp(name, cstr_LCS)) { d->module_type = MT_LCS; }
  else if (0 == strcmp(name, cstr_LSP)) { d->module_type = MT_LSP; }
  else if (0 == strcmp(name, cstr_MCM)) { d->module_type = MT_MCM; }
  else if (0 == strcmp(name, cstr_ODP)) { d->module_type = MT_ODP; }
  else if (0 == strcmp(name, cstr_RAP)) { d->module_type = MT_RAP; }
  else if (0 == strcmp(name, cstr_SCP)) { d->module_type = MT_SCP; }
  else if (0 == strcmp(name, cstr_SPA)) { d->module_type = MT_SPA; }
  else if (0 == strcmp(name, cstr_SPC)) { d->module_type = MT_SPC; }
  else if (0 == strcmp(name, cstr_TSP)) { d->module_type = MT_TSP; }
  else if (0 == strcmp(name, cstr_WLV)) { d->module_type = MT_WLV; }
  else { d->module_type = MT_UNKNOWN; }
}


const char * getModuleType(DPFE * d) {
#if DEBUG_API 
  puts("API.getModuleType");
#endif
  if      (d->module_type == MT_BST) { return cstr_BST; }
  else if (d->module_type == MT_COV) { return cstr_COV; }
  else if (d->module_type == MT_ILP) { return cstr_ILP; }
  else if (d->module_type == MT_KS01) { return cstr_KS01; }
  else if (d->module_type == MT_LCS) { return cstr_LCS; }
  else if (d->module_type == MT_LSP) { return cstr_LSP; }
  else if (d->module_type == MT_MCM) { return cstr_MCM; }
  else if (d->module_type == MT_ODP) { return cstr_ODP; }
  else if (d->module_type == MT_RAP) { return cstr_RAP; }
  else if (d->module_type == MT_SCP) { return cstr_SCP; }
  else if (d->module_type == MT_SPA) { return cstr_SPA; }
  else if (d->module_type == MT_SPC) { return cstr_SPC; }
  else if (d->module_type == MT_TSP) { return cstr_TSP; }
  else if (d->module_type == MT_WLV) { return cstr_WLV; }
  else { return "Unknown"; }
}


void getDimension(DPFE * d, char * name, char * param_list, 
                  DimensionType type) {
#if DEBUG_API 
  puts("API.getDimension");
#endif
  switch (dpfe->module_type) {
    case MT_BST: BST_getDimension(d, name, param_list, type); break;
    case MT_COV: COV_getDimension(d, name, param_list, type); break;
    case MT_ILP: ILP_getDimension(d, name, param_list, type); break;
    case MT_KS01: KS01_getDimension(d, name, param_list, type); break;
    case MT_LCS: LCS_getDimension(d, name, param_list, type); break;
    case MT_LSP: LSP_getDimension(d, name, param_list, type); break;
    case MT_MCM: MCM_getDimension(d, name, param_list, type); break;
    case MT_ODP: ODP_getDimension(d, name, param_list, type); break;
    case MT_RAP: RAP_getDimension(d, name, param_list, type); break;
    case MT_SCP: SCP_getDimension(d, name, param_list, type); break;
    case MT_SPA: SPA_getDimension(d, name, param_list, type); break;
    case MT_SPC: SPC_getDimension(d, name, param_list, type); break;
    case MT_TSP: TSP_getDimension(d, name, param_list, type); break;
    case MT_WLV: WLV_getDimension(d, name, param_list, type); break;
    default:
      puts("error: dimension: wrong dpfe module type");
      exit(1);
  }
}


void writeGeneralFunctions(FILE * fp, DPFE * d) {
#if DEBUG_API 
  puts("API.writeGeneralFunctions");
#endif
  switch (d->module_type) {
    case MT_BST: BST_writeGeneralFunctions(fp, d); break;
    case MT_COV: COV_writeGeneralFunctions(fp, d); break;
    case MT_ILP: ILP_writeGeneralFunctions(fp, d); break;
    case MT_KS01: KS01_writeGeneralFunctions(fp, d); break;
    case MT_LCS: LCS_writeGeneralFunctions(fp, d); break;
    case MT_LSP: LSP_writeGeneralFunctions(fp, d); break;
    case MT_MCM: MCM_writeGeneralFunctions(fp, d); break;
    case MT_ODP: ODP_writeGeneralFunctions(fp, d); break;
    case MT_RAP: RAP_writeGeneralFunctions(fp, d); break;
    case MT_SCP: SCP_writeGeneralFunctions(fp, d); break;
    case MT_SPA: SPA_writeGeneralFunctions(fp, d); break;
    case MT_SPC: SPC_writeGeneralFunctions(fp, d); break;
    case MT_TSP: TSP_writeGeneralFunctions(fp, d); break;
    case MT_WLV: WLV_writeGeneralFunctions(fp, d); break;
  }
}

// So far this is specific for TSP module type.
void writeSetVar(FILE * fp, DPFE * d) {
#if DEBUG_API 
  puts("API.writeSetVar");
#endif
  switch (d->module_type) {
    case MT_BST: BST_writeSetVal(fp, d); break;
    case MT_COV: COV_writeSetVal(fp, d); break;
    case MT_ILP: ILP_writeSetVal(fp, d); break;
    case MT_KS01: KS01_writeSetVal(fp, d); break;
    case MT_LCS: LCS_writeSetVal(fp, d); break;
    case MT_LSP: LSP_writeSetVal(fp, d); break;
    case MT_MCM: MCM_writeSetVal(fp, d); break;
    case MT_ODP: ODP_writeSetVal(fp, d); break;
    case MT_RAP: RAP_writeSetVal(fp, d); break;
    case MT_SCP: SCP_writeSetVal(fp, d); break;
    case MT_SPA: SPA_writeSetVal(fp, d); break;
    case MT_SPC: SPC_writeSetVal(fp, d); break;
    case MT_TSP: TSP_writeSetVal(fp, d); break;
    case MT_WLV: WLV_writeSetVal(fp, d); break;
  }
}


void writeGeneralVar(FILE * fp, DPFE * d) {
#if DEBUG_API 
  puts("API.writeGeneralVar");
#endif
  fprintf(fp, "GENERAL_VARIABLES_BEGIN\n");

  switch (d->module_type) {
    case MT_BST: BST_writeGeneralVal(fp, d); break;
    case MT_COV: COV_writeGeneralVal(fp, d); break;
    case MT_ILP: ILP_writeGeneralVal(fp, d); break;
    case MT_KS01: KS01_writeGeneralVal(fp, d); break;
    case MT_LCS: LCS_writeGeneralVal(fp, d); break;
    case MT_LSP: LSP_writeGeneralVal(fp, d); break;
    case MT_MCM: MCM_writeGeneralVal(fp, d); break;
    case MT_ODP: ODP_writeGeneralVal(fp, d); break;
    case MT_RAP: RAP_writeGeneralVal(fp, d); break;
    case MT_SCP: SCP_writeGeneralVal(fp, d); break;
    case MT_SPA: SPA_writeGeneralVal(fp, d); break;
    case MT_SPC: SPC_writeGeneralVal(fp, d); break;
    case MT_TSP: TSP_writeGeneralVal(fp, d); break;
    case MT_WLV: WLV_writeGeneralVal(fp, d); break;
  }

  fprintf(fp, "GENERAL_VARIABLES_END\n\n");
}


void write_goal(FILE * fp, DPFE * d) {
#if DEBUG_API 
  puts("API.write_goal");
#endif
  fprintf(fp, "GOAL:\n");

  if (d->module_goal != NULL) {
    fprintf(fp, "  %s\n\n", d->module_goal);
    return;
  }

  // otherwise, module_goal was not specified. Use assumptions.
  switch (d->module_type) {
    case MT_BST: BST_writeGoal(fp, d); break;
    case MT_COV: COV_writeGoal(fp, d); break;
    case MT_ILP: ILP_writeGoal(fp, d); break;
    case MT_KS01: KS01_writeGoal(fp, d); break;
    case MT_LCS: LCS_writeGoal(fp, d); break;
    case MT_LSP: LSP_writeGoal(fp, d); break;
    case MT_MCM: MCM_writeGoal(fp, d); break;
    case MT_ODP: ODP_writeGoal(fp, d); break;
    case MT_RAP: RAP_writeGoal(fp, d); break;
    case MT_SCP: SCP_writeGoal(fp, d); break;
    case MT_SPA: SPA_writeGoal(fp, d); break;
    case MT_SPC: SPC_writeGoal(fp, d); break;
    case MT_TSP: TSP_writeGoal(fp, d); break;
    case MT_WLV: WLV_writeGoal(fp, d); break;
  }

  fprintf(fp, "\n");
}


void write_dpfe_base(FILE * fp, DPFE * d) {
#if DEBUG_API 
  puts("API.write_dpfe_base");
#endif
  fprintf(fp, "DPFE_BASE:\n");

  switch (d->module_type) {
    case MT_BST: BST_writeDpfeBase(fp, d); break;
    case MT_COV: COV_writeDpfeBase(fp, d); break;
    case MT_ILP: ILP_writeDpfeBase(fp, d); break;
    case MT_KS01: KS01_writeDpfeBase(fp, d); break;
    case MT_LCS: LCS_writeDpfeBase(fp, d); break;
    case MT_LSP: LSP_writeDpfeBase(fp, d); break;
    case MT_MCM: MCM_writeDpfeBase(fp, d); break;
    case MT_ODP: ODP_writeDpfeBase(fp, d); break;
    case MT_RAP: RAP_writeDpfeBase(fp, d); break;
    case MT_SCP: SCP_writeDpfeBase(fp, d); break;
    case MT_SPA: SPA_writeDpfeBase(fp, d); break;
    case MT_SPC: SPC_writeDpfeBase(fp, d); break;
    case MT_TSP: TSP_writeDpfeBase(fp, d); break;
    case MT_WLV: WLV_writeDpfeBase(fp, d); break;
  }

  fprintf(fp, "\n");
}


