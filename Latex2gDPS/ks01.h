#ifndef _KS01_H_
#define _KS01_H_

/*
 * ks01.h - functions for KS01 module
 */

#include "pn.h"

// params: A 1D array of numbers.

void KS01_getDimension(DPFE * dpfe, char * name, char * value, 
                       DimensionType type);
void KS01_writeGoal(FILE * fp, DPFE * d);
void KS01_writeDpfeBase(FILE * fp, DPFE * d);
void KS01_writeGeneralFunctions(FILE * fp, DPFE * d);
void KS01_writeGeneralVal(FILE * fp, DPFE * d);
void KS01_writeSetVal(FILE * fp, DPFE * d);

#endif

