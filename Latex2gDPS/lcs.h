#ifndef _LCS_H_
#define _LCS_H_

/*
 * lcs.h - functions for LCS module
 */

#include "pn.h"

// params: A 1D array of numbers.

void LCS_getDimension(DPFE * dpfe, char * name, char * value, 
                      DimensionType type);
void LCS_writeGoal(FILE * fp, DPFE * d);
void LCS_writeDpfeBase(FILE * fp, DPFE * d);
void LCS_writeGeneralFunctions(FILE * fp, DPFE * d);
void LCS_writeGeneralVal(FILE * fp, DPFE * d);
void LCS_writeSetVal(FILE * fp, DPFE * d);

#endif

