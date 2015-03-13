#ifndef _LSP_H_
#define _LSP_H_

/*
 * lsp.h - functions for LSP module
 */

#include "pn.h"

// params: 2-D matrix.

void LSP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void LSP_writeGoal(FILE * fp, DPFE * d);
void LSP_writeDpfeBase(FILE * fp, DPFE * d);
void LSP_writeGeneralFunctions(FILE * fp, DPFE * d);
void LSP_writeGeneralVal(FILE * fp, DPFE * d);
void LSP_writeSetVal(FILE * fp, DPFE * d);

#endif

