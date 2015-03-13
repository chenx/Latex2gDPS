#ifndef _SPA_H_
#define _SPA_H_

/*
 * spa.h - functions for SPA module
 */

#include "pn.h"

// params: 1-D array.

void SPA_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void SPA_writeGoal(FILE * fp, DPFE * d);
void SPA_writeDpfeBase(FILE * fp, DPFE * d);
void SPA_writeGeneralFunctions(FILE * fp, DPFE * d);
void SPA_writeGeneralVal(FILE * fp, DPFE * d);
void SPA_writeSetVal(FILE * fp, DPFE * d);

#endif

