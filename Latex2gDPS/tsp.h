#ifndef _TSP_H_
#define _TSP_H_

/*
 * tsp.h - functions for TSP module
 */

#include "pn.h"

// A 2D array of numbers.

void TSP_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void TSP_writeGoal(FILE * fp, DPFE * d);
void TSP_writeDpfeBase(FILE * fp, DPFE * d);
void TSP_writeGeneralFunctions(FILE * fp, DPFE * d);
void TSP_writeGeneralVal(FILE * fp, DPFE * d);
void TSP_writeSetVal(FILE * fp, DPFE * d);


#endif

