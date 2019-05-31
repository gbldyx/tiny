//typedef enum { typeCon, typeId, typeOpr} nodeEnum;
//typedef enum {op, intcon, realcon, id, rw} Type;
//typedef enum {MD, FP, BL, TY, stmt, LVD, AS, RT, IF, WT, RD, 

/*typedef struct{
	nodeEnum type;
	int value;
}intConNodeType;

typedef struct{
	nodeEnum type;
	float value;
}realConNodeType;

typedef struct{
	nodeEnum type;
	char* name; 
}idNodeType;

typedef struct{
	nodeEnum type;
	int oper;
	int nops;
	union nodeTypeTag *op[1];
}oprNodeType;

typedef union nodeTypeTag{
	nodeEnum type;
	intConNodeType icon;
	realConNodetype rcon;
	idNodeType id;
	oprNodeType opr;
}nodeType;
*/
#include<string.h>
#include<stdio.h>
#include<stdlib.h>
typedef struct Node{
	struct Node* child;
	struct Node* sibling;
	int noChild;
	char name[100];
}Node;

Node* newNode(char *name);
void insert(Node* parent,Node* child);
void printTree(Node* t,int depth);
