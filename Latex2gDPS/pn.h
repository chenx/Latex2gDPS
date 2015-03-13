#ifndef _PN_H_
#define _PN_H_

/*
 * pn.h
 *
 * Header file for pn program.
 * @Author: Xin Chen
 * @Created on: 9/11/2007
 * @Last modified: 9/11/2007
 */

#include <stdio.h>
#include <stdlib.h>
#include "str.h"
#include "dpfe.h"
#include "const.h"

/* Macros */
#define PN_NEW(name, type, size)                 \
{                                                \
  name = (type *) malloc(sizeof(type) * (size)); \
  if (name == NULL) {                            \
    printf("out of memory\n");                   \
    exit(1);                                     \
  }                                              \
}

#define PN_EXPAND(name, type, size)                              \
{                                                                \
  name = (type *) realloc((void *) name, sizeof(type) * (size)); \
  if (name == NULL) {                                            \
    printf("out of memory\n");                                   \
    exit(1);                                                     \
  }                                                              \
}

extern char ** getMatrix(char * str, int * size);
extern void write_DPFE_param_list(FILE * fp, DPFE * d);
extern void write_params(FILE * fp, char * s);

extern int PNDEBUG;

#endif
