#ifndef _STR_H_
#define _STR_H_

/*
 * str.c
 *
 * string function library
 *
 * @author: Xin Chen
 * @created on: 10/10/2007
 * @last modified: 10/10/2007
 */

#include <string.h>
#include <stdlib.h>

char * str_dup(const char * str);
char * ltrim(char * str, const char * list);
char * rtrim(char * str, const char * list);
char * trim(char * str, const char * list);

#endif

