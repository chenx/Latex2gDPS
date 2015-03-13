#ifndef _MCM_H_
#define _MCM_H_

/*
 * mcm.h - functions for MCM module
 */

#include "pn.h"

// params: A 1D array of numbers.

void MCM_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void MCM_writeGoal(FILE * fp, DPFE * d);
void MCM_writeDpfeBase(FILE * fp, DPFE * d);
void MCM_writeGeneralFunctions(FILE * fp, DPFE * d);
void MCM_writeGeneralVal(FILE * fp, DPFE * d);
void MCM_writeSetVal(FILE * fp, DPFE * d);

#endif

