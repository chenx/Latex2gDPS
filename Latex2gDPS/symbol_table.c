/*
 * symbol_table.c
 *
 * These functions are to be customized according to ELEM_TYPE:
 *   HashTbl_copy_elem(), HashTbl_destroy_HashNode(),
 *   HashTbl_HashNode_dump(), HashTbl_hash().
 *
 * Empty string is allowed.
 *
 * @Author: Xin Chen
 * @Created on: 7/10/2007
 * @Last modified: 8/4/2007
 */

#include "symbol_table.h"


/* Local helper functions. */

static HashTblNode * HashTbl_create_HashTblNode();
static void HashTbl_destroy_HashTblNode(HashTblNode * n);
static ELEM_TYPE HashTbl_copy_elem(ELEM_TYPE e);
static HashNode * HashTbl_create_HashNode(ELEM_TYPE e, int hashval);
static void HashTbl_destroy_HashNode(HashNode * n);
static int HashNode_elem_equal(ELEM_TYPE e, ELEM_TYPE f);
static void HashTbl_HashNode_dump(HashNode * n);
static int HashTbl_hash(int HT_SIZE, ELEM_TYPE e);
static char * HashTbl_Type_dump(PN_TYPE type);


static HashTblNode * HashTbl_create_HashTblNode() {
  HashTblNode * n = (HashTblNode *) malloc(sizeof(HashTblNode));
  if (n == NULL) {
    puts("out of memory");
    exit(1);
  }

  n->next = NULL;
  n->count = 0;
  return n;
}


static void HashTbl_destroy_HashTblNode(HashTblNode * n) {
  free(n);
}


HashTbl * HashTbl_create() {
  return HashTbl_create2(HASHTBL_SIZE);
}


HashTbl * HashTbl_create2(int size) {
  int i;
  HashTbl * h = (HashTbl *) malloc(sizeof(HashTbl));
  if (h == NULL) {
    puts("out of memory");
    exit(1);
  }

  h->table = (HashTblNode **) malloc(sizeof(HashTblNode *) * size);
  if (h->table == NULL) {
    puts("out of memory");
    exit(1);
  }
  h->count = 0;
  h->size = size;

  for (i = 0; i < size; i ++) {
    h->table[i] = HashTbl_create_HashTblNode();
  }

  return h;
}


/*
 * Customized for string.
 * @Returns: 1 if equal, 0 otherwise. 
 */
static int HashNode_elem_equal(ELEM_TYPE e, ELEM_TYPE f) {
  return 0 == strcmp(e, f);
}


/*
 * customized.
 */
static ELEM_TYPE HashTbl_copy_elem(ELEM_TYPE e) {
  int len;
  char * str;
  /* for string */
  len = strlen(e);
  if ((len = strlen(e)) == 0) return "";
  str = (char *) malloc(len + 1);
  if (str == NULL) {
    puts("out of memory");
    exit(1);
  }
  strcpy(str, e);
  return str;
}


static HashNode * HashTbl_create_HashNode(ELEM_TYPE e, int hashval) {
  HashNode * n = (HashNode *) malloc(sizeof(HashNode));
  if (n == NULL) {
    puts("out of memory");
    exit(1);
  }

  n->elem = HashTbl_copy_elem(e);
  n->hash = hashval;
  n->next = NULL;

  n->var_type = VAR_NONE; // default value.
  n->alias = "";

  return n;
}


/*
 * customized.
 */
static void HashTbl_destroy_HashNode(HashNode * n) {
  /* for string object */
#if DEBUG_HASHTBL
  printf("destroy node %s\n", n->elem); 
#endif
  if (strlen(n->elem) > 0) free(n->elem);
  free(n);
}


static char * HashTbl_Type_dump(PN_TYPE type) {
  switch (type) {
    case PN_INT: return "INT"; break;
    case PN_REAL: return "REAL"; break;
    case PN_SET: return "SET"; break;
    case PN_VAR: return "VAR"; break;
    case PN_INDEXED_VAR: return "INDEXED_VAR"; break;
    case PN_FUNC_CALL: return "FUNCTION_CALL"; break;
    case PN_FUNC_NAME: return "FUNCTION_NAME"; break;
    case PN_OP_SET: return "OPERATOR_SET"; break;
    case PN_OP_ARITH: return "OPERATOR_ARITH"; break;
    case PN_OP_LOGIC: return "OPERATOR_LOGIC"; break;
    case PN_NONE:
    default:
      return "NONE";
      break;
  }
}


/*
 * customized.
 */
static void HashTbl_HashNode_dump(HashNode * n) {
  /* for string object */
  printf("%s", n->elem);
  printf(" [%s]", HashTbl_Type_dump(n->type));
}


/*
 * Customized for string type.
 */
static int HashTbl_hash(int HT_SIZE, ELEM_TYPE e) {
  int i;
  int len = strlen(e);
  unsigned int hashval = 0;

  for (i = 0; i < len; i ++) {
    hashval += (11 * e[i]) % HT_SIZE;
  }
  hashval %= HT_SIZE;
  /* note that e[i] could be negative when being casted. */
  while (hashval < 0) hashval += HT_SIZE; 

  return hashval;
}


/*
 * Use chaining.
 * If a node containing such an element exists, return it;
 * else, insert a new node for the element, and return the node.
 */
HashNode * HashTbl_insert(HashTbl * h, ELEM_TYPE e) {
  int hashval = HashTbl_hash(h->size, e);
  HashNode * n = h->table[hashval]->next;

  if (n == NULL) {
    n = h->table[hashval]->next = HashTbl_create_HashNode(e, hashval);   
    h->table[hashval]->count = 1;
    h->count ++;
    return n;
  } else {
    for (; n->next != NULL; n = n->next) {
      if (HashNode_elem_equal(n->elem, e)) { 
        return n;
      }
    }
    if (HashNode_elem_equal(n->elem, e)) {
      return n;
    }
    /* else, insert as the last one. */
    h->table[hashval]->count ++;
    h->count ++;
    return n->next = HashTbl_create_HashNode(e, hashval);
  }
}


HashNode * HashTbl_find(HashTbl * h, ELEM_TYPE e) {
  int hashval = HashTbl_hash(h->size, e);
  HashNode * n;

  for (n = h->table[hashval]->next; n != NULL; n = n->next) {
    if (HashNode_elem_equal(n->elem, e)) {
      return n;
    }
  }

  return NULL;
}


void HashTbl_delete(HashTbl * h, ELEM_TYPE e) {
  int hashval = HashTbl_hash(h->size, e);
  HashNode * n, * p;

  n = h->table[hashval]->next;
  if (n == NULL) return;

  if (HashNode_elem_equal(n->elem, e)) { /* is first node. */
    h->table[hashval]->next = n->next;
    HashTbl_destroy_HashNode(n);
    h->table[hashval]->count --;
    h->count --;
    return;
  }

  /* else, is a node thereafter. p is parent of n. */
  for (p = n, n = n->next; n != NULL; n = n->next) {
    if (HashNode_elem_equal(n->elem, e)) {
      p->next = n->next;
      HashTbl_destroy_HashNode(n);
      h->table[hashval]->count --;
      h->count --;
      return;
    }
  }
}


void HashTbl_destroy(HashTbl * h) {
  int i, size = h->size;
  HashNode * n, * tmp;
  for (i = 0; i < size; i ++) {
    n = h->table[i]->next;
    while (n != NULL) {
      tmp = n->next;
      HashTbl_destroy_HashNode(n);
      n = tmp;
    }
    free(h->table[i]);
  }

  free(h);
}


void HashTbl_dump(HashTbl * h) {
  int i, count = 0, list_count = 0;
  int HT_SIZE = h->size;
  HashNode * n;

  if (PNDEBUG == 0) return;

  printf("\n\n--Hash table--\n");
  for (i = 0; i < HT_SIZE; i ++) {
    if (h->table[i]->count > 0) {
      list_count ++;
      printf("HashTbl[%d] (count=%d): ", i, h->table[i]->count);
      for (n = h->table[i]->next; n->next != NULL; n = n->next) {
        HashTbl_HashNode_dump(n);
        printf(", ");
        count ++;
      }
      HashTbl_HashNode_dump(n);
      printf("\n");
      count ++;
    }
  }
  printf("--hash table size: %d--\n", HT_SIZE);
  printf("--symbol count: %d, load factor lamda (%d/%d) = %.3f--\n",
         count, count, HT_SIZE, ((double) count) / HT_SIZE);
  printf("--list count: %d. Hash Table cell usage (%d/%d) = %.3f--\n",
            list_count, list_count, HT_SIZE, 
            ((double) list_count) / HT_SIZE);
  printf("--symbols per list: %.3f--\n", 
         ((double) count) / list_count);

  //hashTbl_destroy();
}


void HashTbl_setNodeType(HashNode * n, PN_TYPE type) {
  n->type = type;
}


PN_TYPE HashTbl_getNodeType(HashNode * n) {
  return n->type;
}


static VAR_TYPE getVarType(char * var_type) {
  if (0 == strcmp(var_type, "int")) { return VAR_INT; }
  else if (0 == strcmp(var_type, "double")) { return VAR_DOUBLE; }
  else if (0 == strcmp(var_type, "Set")) { return VAR_SET; }

  printf("get_VAR_TYPE warning: unknown type: %s.\n", var_type);
  puts(" Use default type VAR_INT");
  return VAR_INT;
}


static char * dumpVarType(VAR_TYPE var_type) {
  switch (var_type) {
    case VAR_INT: return "int";
    case VAR_DOUBLE: return "double";
    case VAR_SET: return "set";
    case VAR_NONE:
    default: return "";
  }
}


void HashNode_insertVarType(HashNode * n, char * var_type) {
  if (NULL == n || 
      NULL == var_type || 0 == strlen(var_type)) return;

/*
  if (n->type != PN_VAR) {
    puts("HashNode_insertVarType - ");
    printf("warning: type of element %s is not VAR\n", n->elem);
    return;
  }
*/

  if (n->var_type != VAR_NONE) {
    puts("HashNode_insert_varType - ");
    printf("warning: element %s already has type %s\n", 
           n->elem, dumpVarType(n->var_type));
    return;
  }

  n->var_type = getVarType(var_type);
}


void HashTbl_insertVarType(HashTbl * h, char * var, char * var_type) {
  // if var exists in h, this will just return the node 
  // contains var; otherwise it inserts var into h, and 
  // return the inserted node.
  HashNode * n = HashTbl_insert(h, var);
  HashNode_insertVarType(n, var_type);
}


void HashNode_insertVarAlias(HashNode * n, char * alias) {
  if (NULL == n ||
      NULL == alias || 0 == strlen(alias)) return;

/*
  if (n->type != PN_VAR) {
    puts("HashNode_insertAlias - ");
    printf("warning: type of element %s is not VAR\n", n->elem);
    return;
  }
*/

  if (strlen(n->alias) > 0) {
    puts("HashNode_insertAlias - ");
    printf("warning: element %s already has alias %s\n",
           n->elem, n->alias);
    return;
  }

  n->alias = str_dup(alias);
}


void HashTbl_insertVarAlias(HashTbl * h, char * var, char * alias) {
  // if var exists in h, this will just return the node 
  // contains var; otherwise it inserts var into h, and 
  // return the inserted node.
  HashNode * n = HashTbl_insert(h, var);
  HashNode_insertVarAlias(n, alias);
}


/*
 * Now only return a valid type string (int, double)
 * when n->type is PN_VAR and n->var_type is VAR_INT or VAR_DOUBLE.
 */
char * getHashNodeTypeName(HashNode * n) {
/*
printf("getHashNodetypeName: %s, type: %d, var_type: %d\n",
       n->elem, n->type, n->var_type);
*/
  if (NULL == n) return "";

  if (n->type == PN_VAR) {
    if (n->var_type == VAR_INT) return "int";
    else if (n->var_type == VAR_DOUBLE) return "double";
    else if (n->var_type == VAR_SET) return "Set";
    else return "int"; // VAR_NONE, default to int.
  }
  return "";
}
