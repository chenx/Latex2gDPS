#ifndef _BST_H_
#define _BST_H_

/*
 * bst.h - functions for BST module
 */

#include "pn.h"

// params: A 1D array of numbers.

void BST_getDimension(DPFE * dpfe, char * name, char * value,
                      DimensionType type);
void BST_writeGoal(FILE * fp, DPFE * d);
void BST_writeDpfeBase(FILE * fp, DPFE * d);
void BST_writeGeneralFunctions(FILE * fp, DPFE * d);
void BST_writeGeneralVal(FILE * fp, DPFE * d);
void BST_writeSetVal(FILE * fp, DPFE * d);

#endif

