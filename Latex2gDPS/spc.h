#ifndef _SPC_H_
#define _SPC_H_

/*
 * spc.h - functions for SPC module
 */

#include "pn.h"

// params: 1-D array.

void SPC_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void SPC_writeGoal(FILE * fp, DPFE * d);
void SPC_writeDpfeBase(FILE * fp, DPFE * d);
void SPC_writeGeneralFunctions(FILE * fp, DPFE * d);
void SPC_writeGeneralVal(FILE * fp, DPFE * d);
void SPC_writeSetVal(FILE * fp, DPFE * d);

#endif

