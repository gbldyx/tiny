%{
#include "tiny.h"
#include <stdio.h>
#include <stdlib.h>
//#define YYSTYPE Node*

/*nodeType *opr(int oper,int nops, ...);
nodeType *id(int i);
nodeType *intcon(int value);
nodeType *realcon(float value);
void freeNode(nodeType *p);*/
Node* p;
int yylex(void);
void yyerror(char *s);
static Node* saveTree;
%}

%union{
	struct Node* nPtr;
}
%token <nPtr> QString
%token <nPtr> INTNUM
%token <nPtr> REALNUM 
%token <nPtr> ID 
%token <nPtr> INT REAL
%token IF WRITE READ RETURN _BEGIN END MAIN WHILE
%token ENDWHILE DO TO DOWNTO FOR ENDDO
%nonassoc IFX
%nonassoc ELSE

%left EQ NE AS
%left '+' '-'
%left '*' '/' 

%type <nPtr> Program MethodDecl Type FormalParams Block FormalParam Statement LocalVarDecl
%type <nPtr> Statements AssignStmt ReturnStmt IfStmt WriteStmt ReadStmt FPList PrimaryExpr
%type <nPtr> Expression BoolExpression ActualParams Mainornot APList MultiplicativeExpr
%type <nPtr> WhileStmt DowhileStmt ForStmt

%%

Program:
	Program MethodDecl {insert($1,$2);$$=$1;}
	|MethodDecl	{p=newNode("Program");insert(p,$1);saveTree=p;$$=p;} 
	;

MethodDecl:
	  Type Mainornot ID '(' FPList ')' Block {p=newNode("MethodDecl");
							insert(p,$1);
							insert(p,$2);
							insert(p,$3);
							insert(p,$5);
							insert(p,$7);
							$$=p;}
	;
Mainornot:
	  MAIN	{p=newNode("MAIN");$$=p;}
	|	{p=newNode("NULL");
		 $$=p;}
	;

FPList:
	FormalParams {$$=$1;}
	| 	{p=newNode("NULL");$$=p;}
	;

FormalParams:
	  FormalParams ',' FormalParam {insert($1,$3);$$=$1;}
	| FormalParam	{p=newNode("FormalParams");insert(p,$1);$$=p;}
	;
	 
FormalParam:
	   Type ID {p=newNode("FormalParam");insert(p,$1);insert(p,$2);$$=p;}
	;

Type:
    	INT	{$$=$1;}
	| REAL	{$$=$1;}
	;

Block:
     	_BEGIN Statements END { p=newNode("Block");insert(p,$2);$$=p;}
	;
Statements:
	  Statements Statement {insert($1,$2);$$=$1;}
	| Statement {p=newNode("Statements");insert(p,$1);$$=p;}
	;

Statement:
	 Block {p=newNode("Statement");insert(p,$1);$$=p;}
	| LocalVarDecl {p=newNode("Statement");insert(p,$1);$$=p;}
	| AssignStmt {p=newNode("Statement");insert(p,$1);$$=p;}
	| ReturnStmt {p=newNode("Statement");insert(p,$1);$$=p;}
	| IfStmt {p=newNode("Statement");insert(p,$1);$$=p;}
	| WriteStmt {p=newNode("Statement");insert(p,$1);$$=p;}
	| ReadStmt {p=newNode("Statement");insert(p,$1);$$=p;}
	| WhileStmt {p=newNode("Statement");insert(p,$1);$$=p;}
	| DowhileStmt {p=newNode("Statement");insert(p,$1);$$=p;}
	| ForStmt {p=newNode("Statement");insert(p,$1);$$=p;}
	;
LocalVarDecl:
	INT ID ';' {p=newNode("LocalVarDecl");insert(p,$1);insert(p,$2);$$=p;}
	| REAL ID ';' {p=newNode("LocalVarDecl");insert(p,$1);insert(p,$2);$$=p;}
	;

AssignStmt:
	 ID AS Expression ';' {p=newNode("AssignStmt");insert(p,$1);insert(p,$3);$$=p;}
	;

ReturnStmt:
	  RETURN Expression ';' {p=newNode("ReturnStmr");insert(p,$2);$$=p;}
	;
IfStmt:
      	IF '(' BoolExpression ')' Statements %prec IFX
	{p=newNode("IfStmt");insert(p,$3);insert(p,$5);$$=p;}
	| IF '(' BoolExpression ')' Statements ELSE Statements 
	{p=newNode("IfStmt");insert(p,$3);insert(p,$5);insert(p,$7);$$=p;}
	;

WriteStmt:
	 WRITE '(' Expression ',' QString ')' ';'
	{p=newNode("WriteStmt");insert(p,$3);insert(p,$5);$$=p;}
	;

ReadStmt:
	READ '(' ID ',' QString ')' ';'
	{p=newNode("ReadStmt");insert(p,$3);insert(p,$5);$$=p;}
	;

WhileStmt:
	 WHILE BoolExpression DO Statements ENDWHILE
	{p=newNode("WhileStmt");insert(p,$2);insert(p,$4);$$=p;}
	;

DowhileStmt:
	 DO Statements WHILE BoolExpression ';' 
	{p=newNode("DowhileStmt");insert(p,$2);insert(p,$4);$$=p;}
	;

ForStmt:
       FOR ID AS Expression TO Expression DO Statements ENDDO 
	{p=newNode("ForStmt:Increment");insert(p,$2);insert(p,$4);insert(p,$6);insert(p,$8);$$=p;}
	| FOR ID AS Expression DOWNTO Expression DO Statements ENDDO
	{p=newNode("ForStmt:Decrement");insert(p,$2);insert(p,$4);insert(p,$6);insert(p,$8);$$=p;}
	;

Expression:
	  Expression '+' MultiplicativeExpr	{insert($1,$3);p=newNode("operation:+");insert($1,p);$$=$1;}
	|  Expression '-' MultiplicativeExpr 	{insert($1,$3);p=newNode("operation:-");insert($1,p);$$=$1;}
	|  MultiplicativeExpr  {p=newNode("Expression");insert(p,$1);$$=p;}
	;

MultiplicativeExpr:
	   MultiplicativeExpr '*' PrimaryExpr	{insert($1,$3);p=newNode("operation:*");insert($1,p);$$=$1;}
	|  MultiplicativeExpr '/' PrimaryExpr	{insert($1,$3);p=newNode("operation:/");insert($1,p);$$=$1;}
	|  PrimaryExpr  {p=newNode("MultiplicativeExpr");insert(p,$1);$$=p;}
	;
PrimaryExpr:
	  INTNUM	{p=newNode("PrimaryExpr");insert(p,$1);$$=p;}
	|  REALNUM	{p=newNode("PrimaryExpr");insert(p,$1);$$=p;}
	|  ID	{p=newNode("PrimaryExpr");insert(p,$1);$$=p;}
	|  '(' Expression ')'	{p=newNode("PrimaryExpr");insert(p,$2);$$=p;}
	|  ID '(' APList ')'	{p=newNode("PrimaryExpr");insert(p,$1);insert(p,$3);$$=p;}
	;
BoolExpression:
	     Expression EQ Expression {p=newNode("BoolExpression");insert(p,$1);insert(p,$3);$$=p;}
	|    Expression NE Expression	{p=newNode("BoolExpression");insert(p,$1);insert(p,$3);$$=p;}
	;
APList:
	   ActualParams {$$=$1;}
	|  {p=newNode("NULL");$$=p;}
	;
ActualParams:
	    ActualParams ',' Expression {insert($1,$3);$$=$1;}
	|   Expression	{p=newNode("ActualParams");insert(p,$1);$$=p;}
	;
%%
void yyerror(char* s)
{
	fprintf(stdout,"%s\n",s);
}
int main(void)
{
	yyparse();
	printTree(saveTree,0);
	return 0;
}
