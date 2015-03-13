#ifndef _COV_H_
#define _COV_H_

/*
 * cov.h - functions for COV module
 */

#include "pn.h"

// params: A 1D array of numbers.

void COV_getDimension(DPFE * dpfe, char * name, char * value, 
                      DimensionType type);
void COV_writeGoal(FILE * fp, DPFE * d);
void COV_writeDpfeBase(FILE * fp, DPFE * d);
void COV_writeGeneralFunctions(FILE * fp, DPFE * d);
void COV_writeGeneralVal(FILE * fp, DPFE * d);
void COV_writeSetVal(FILE * fp, DPFE * d);


#endif

