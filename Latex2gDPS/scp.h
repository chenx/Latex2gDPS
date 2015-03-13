#ifndef _SCP_H_
#define _SCP_H_

/*
 * scp.h - functions for SCP module
 */

#include "pn.h"

// params: 1-D array.

void SCP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void SCP_writeGoal(FILE * fp, DPFE * d);
void SCP_writeDpfeBase(FILE * fp, DPFE * d);
void SCP_writeGeneralFunctions(FILE * fp, DPFE * d);
void SCP_writeGeneralVal(FILE * fp, DPFE * d);
void SCP_writeSetVal(FILE * fp, DPFE * d);

#endif

