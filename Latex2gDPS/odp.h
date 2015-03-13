#ifndef _ODP_H_
#define _ODP_H_

/*
 * odp.h - functions for ODP module
 */

#include "pn.h"

// params: A 1D array of numbers.

void ODP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void ODP_writeGoal(FILE * fp, DPFE * d);
void ODP_writeDpfeBase(FILE * fp, DPFE * d);
void ODP_writeGeneralFunctions(FILE * fp, DPFE * d);
void ODP_writeGeneralVal(FILE * fp, DPFE * d);
void ODP_writeSetVal(FILE * fp, DPFE * d);

#endif

