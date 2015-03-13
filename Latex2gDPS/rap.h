#ifndef _RAP_H_
#define _RAP_H_

/*
 * rap.h - functions for RAP module
 */

#include "pn.h"

// params: A 1D array of numbers.

void RAP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void RAP_writeGoal(FILE * fp, DPFE * d);
void RAP_writeDpfeBase(FILE * fp, DPFE * d);
void RAP_writeGeneralFunctions(FILE * fp, DPFE * d);
void RAP_writeGeneralVal(FILE * fp, DPFE * d);
void RAP_writeSetVal(FILE * fp, DPFE * d);

#endif

