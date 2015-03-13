/*
 * str.c
 *
 * string function library
 *
 * @author: Xin Chen
 * @created on: 10/10/2007
 * @last modified: 10/10/2007
 */

#include "str.h"

/*
 * @return: a copy of str.
 */
char * str_dup(const char * str) {
  char * copy;
  if (NULL == str) return NULL;
  if (0 == strlen(str)) return "";
  copy = (char *) malloc(strlen(str) + 1);
  strcpy(copy, str);
  return copy;
}


/*
 * Strip from the string str's head every character in list.
 */
char * ltrim(char * str, const char * list) {
  if (NULL == str || strlen(str) == 0) return str;
  while (str[0] != 0 && strchr(list, str[0]) != NULL) {
    str ++;
  }
  return str;
}


/*
 * Strip from the string str's tail every character in list.
 * Note: str cannot be a const string like "abc", otherwise
 * the line str[pos --] = 0
 * cannot be executed and a segmentation fault will be thrown.
 */
char * rtrim(char * str, const char * list) {
  int pos = 0;
  if (NULL == str || (pos = strlen(str)) == 0) return str;
  pos --;
  while (pos >= 0 && strchr(list, str[pos]) != NULL) {
    str[pos --] = 0;
  }
  return (pos < 0) ? "" : str;
}


/*
 * Strip from the string str's head and tail every character in list.
 */
char * trim(char * str, const char * list) {
  return rtrim(ltrim(str, list), list);
}

