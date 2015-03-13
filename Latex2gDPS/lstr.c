/*
 * LSTR.c - long string
 */

#include "pn.h"
#include "lstr.h"


void LSTR_new() {
  PN_NEW(LSTR, char, LSTR_max_size); // 256 is start size;
  LSTR[0] = 0;
}


// append tail to LSTR.
void LSTR_append(char * tail) {
  if (NULL == tail || strlen(tail) == 0) return;

  while (strlen(tail) >= LSTR_max_size - strlen(LSTR)) {
    PN_EXPAND(LSTR, char, 2 * LSTR_max_size);
    LSTR_max_size *= 2;
    //printf("LSTR size expanded to %d\n", LSTR_max_size);
  }
  //printf("LSTR before strcat: %s\n", LSTR);
  strcat(LSTR, tail);
  //printf("LSTR after  strcat: %s\n", LSTR);
}


void LSTR_append_char(char c) {
  int len = strlen(LSTR);
  if (len >= LSTR_max_size - 1) {
    PN_EXPAND(LSTR, char, 2 * LSTR_max_size);
    LSTR_max_size *= 2;
  }
  //printf("LSTR before strcat: %s\n", LSTR);
  LSTR[len] = c;
  LSTR[len + 1] = 0;
  //printf("LSTR after strcat: %s\n", LSTR);
}


void LSTR_clear() {
  if (LSTR == NULL) { return; }
  free(LSTR);
  LSTR = NULL;
}


