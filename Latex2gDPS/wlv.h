#ifndef _WLV_H_
#define _WLV_H_

/*
 * wlv.h - functions for WLV module
 */

#include "pn.h"

// A 1D array of numbers.

void WLV_getDimension(DPFE * dpfe, char * name, char * value, 
                       DimensionType type);
void WLV_writeGoal(FILE * fp, DPFE * d);
void WLV_writeDpfeBase(FILE * fp, DPFE * d);
void WLV_writeGeneralFunctions(FILE * fp, DPFE * d);
void WLV_writeGeneralVal(FILE * fp, DPFE * d);
void WLV_writeSetVal(FILE * fp, DPFE * d);

#endif

