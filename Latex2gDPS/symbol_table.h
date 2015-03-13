/*
 * symbol_table.h
 * 
 * When insert, do not allow duplication.
 *
 * @Author: Xin Chen
 * @Created on: 7/10/2007
 * @Last modified: 7/10/2007
 */

#ifndef _SYMBOL_TABLE_H_
#define _SYMBOL_TABLE_H_

#include "pn.h"

typedef char * ELEM_TYPE;
typedef enum {PN_NONE, PN_INT, PN_REAL, PN_SET, PN_VAR, 
              PN_INDEXED_VAR, PN_FUNC_CALL, PN_FUNC_NAME,
              PN_OP_SET, PN_OP_ARITH, PN_OP_LOGIC} PN_TYPE;

typedef enum {VAR_INT, VAR_DOUBLE, VAR_SET, VAR_NONE} VAR_TYPE;

#define DEBUG_HASHTBL 1
#define HASHTBL_SIZE 1023 /* default size of hash table */

typedef struct hashNode HashNode;
struct hashNode {
  int hash;       /* hash value. */
  ELEM_TYPE elem; /* the object */
  PN_TYPE type;   /* type of this element object */
  VAR_TYPE var_type; /* used only when type is PN_VAR */
  char * alias;
  HashNode * next;
};


typedef struct hashTblNode HashTblNode;
struct hashTblNode {
  int count; /* number of elements inserted at this cell. */
  HashNode * next;
};
/* or here: typedef struct hashTblNode HashTblNode; */


typedef struct hashTbl HashTbl;
struct hashTbl {
  int count; /* count of elements. */
  int size;  /* length of table */
  HashTblNode ** table; /* a table of pointers to HashTblNode. */
};


/* public functions. */

HashTbl * HashTbl_create();
HashTbl * HashTbl_create2(int size);
HashNode * HashTbl_insert(HashTbl * h, ELEM_TYPE e);
HashNode * HashTbl_find(HashTbl * h, ELEM_TYPE e);
void HashTbl_delete(HashTbl * h, ELEM_TYPE e);
void HashTbl_destroy(HashTbl * h);
void HashTbl_dump(HashTbl * h);

void HashTbl_setNodeType(HashNode * n, PN_TYPE type);
PN_TYPE HashTbl_getNodeType(HashNode * n);

void HashNode_insertVarType(HashNode * n, char * var_type);
void HashNode_insertVarAlias(HashNode * n, char * alias);
void HashTbl_insertVarType(HashTbl * h, char * elem, char * var_type);
void HashTbl_insertVarAlias(HashTbl * h, char * var, char * alias);
char * getHashNodeTypeName(HashNode * n);

#endif

