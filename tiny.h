typedef enum nodeType{ stmt, id, exp, con,str}nodeType;
typedef enum oprType{assign,ifstmt,whilestmt,dostmt,param,forto,fordownto,rd,wrt,stmts,prog,add,sub,mult,dv,eql,neq,call,ret}oprType;
typedef enum {intType,realType}valueType;
typedef enum {fun,var,prm,mainfun}idType; 

#include<string.h>
#include<stdio.h>
#include<stdlib.h>

typedef struct{
	char name[100];
	valueType vtype;
	idType itype;
}symbol;

extern int symbolNumber;
extern int strNumber;

symbol sym[100];
char strs[20][100];

typedef union{
	int intNum;
	float realNum;
}nodeValue;

typedef struct Node{
	nodeType type;
	nodeValue val;
	oprType op;
	valueType vtype;
	int entry;
	struct Node* child;
	struct Node* sibling;
	int noChild;
}Node;

Node* newNode(nodeType);
int find(char*);
void insert(Node* parent,Node* child);
void printTree(Node* t);
void genExp(Node* t, oprType op);
int storeStr(char*);
