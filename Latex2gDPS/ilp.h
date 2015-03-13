#ifndef _ILP_H_
#define _ILP_H_

/*
 * ilp.h - functions for ILP module
 */

#include "pn.h"

// params: A 1D array of numbers.

void ILP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void ILP_writeGoal(FILE * fp, DPFE * d);
void ILP_writeDpfeBase(FILE * fp, DPFE * d);
void ILP_writeGeneralFunctions(FILE * fp, DPFE * d);
void ILP_writeGeneralVal(FILE * fp, DPFE * d);
void ILP_writeSetVal(FILE * fp, DPFE * d);

#endif

