%{
#include <stdio.h>
#include<stdlib.h>
#include"tiny.h"
#define YYSTYPE Node*

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

%token QString
%token INTNUM
%token REALNUM 
%token ID 
%token INT REAL
%token IF WRITE READ RETURN _BEGIN END MAIN WHILE
%token ENDWHILE DO TO DOWNTO FOR ENDDO
%nonassoc IFX
%nonassoc ELSE

%left EQ NE AS
%left '+' '-'
%left '*' '/' 

%type Program MethodDecl Type FormalParams Block FormalParam Statement LocalVarDecl
%type Statements AssignStmt ReturnStmt IfStmt WriteStmt ReadStmt 
%type Expression BoolExpression ActualParams Mainornot

%%

Tree:
    	Program 	{saveTree=$1;}
	;
Program:
	Program MethodDecl {insert($1,$2);}
	|	{p=newNode("Programs");$$=p;} 
	;

MethodDecl:
	  Type Mainornot ID '(' FormalParams ')' Block {p=newNode("MethodDecl");
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

FormalParams:
	  FormalParams ',' FormalParam {insert($1,$3);}
	| FormalParam	{p=newNode("FormalParams");insert(p,$1);$$=p;}
	;
	 
FormalParam:
	   Type ID {p=newNode("FormalParam");insert(p,$1);insert(p,$2);$$=p;}
	;

Type:
    	INT	
	| REAL
	;

Block:
     	_BEGIN Statements END { p=newNode("Block"); }
	;
Statements:
	  Statements Statement {insert($1,$2);}
	| {p=newNode("Statements");$$=p;}
	;

Statement:
	 Block {p=newNode("Block");$$=p;}
	| LocalVarDecl {p=newNode("LocalVarDecl");$$=p;}
	| AssignStmt {p=newNode("AssignStmt");$$=p;}
	| ReturnStmt {p=newNode("ReturnStmt");$$=p;}
	| IfStmt {p=newNode("IfStmt");$$=p;}
	| WriteStmt {p=newNode("WriteStmt");$$=p;}
	| ReadStmt {p=newNode("ReadStmt");$$=p;}
	;
LocalVarDecl:
	INT ID ';' {p=newNode("LocalVarDecl");insert(p,$1);insert(p,$2);$$=p;}
	| REAL ID ';' {p=newNode("LocalVarDecl");insert(p,$1);insert(p,$2);$$=p;}
	;

AssignStmt:
	 ID ":=" Expression ';' {p=newNode("AssignStmt");insert(p,$1);insert(p,$3);$$=p;}
	;

ReturnStmt:
	  RETURN Expression ';' {p=newNode("ReturnStmr");insert(p,$2);$$=p;}
	;
IfStmt:
      	IF '(' BoolExpression ')' Statement %prec IFX
	{p=newNode("IfStmt");insert(p,$3);insert(p,$5);$$=p;}
	| IF '(' BoolExpression ')' Statement ELSE Statement 
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

Expression:
	 Expression '*' Expression	{p=newNode("Expression");insert(p,$1);insert(p,$3);$$=p;}
	|  Expression '/' Expression	{p=newNode("Expression");insert(p,$1);insert(p,$3);$$=p;}
	|  Expression '+' Expression	{p=newNode("Expression");insert(p,$1);insert(p,$3);$$=p;}
	|  Expression '-' Expression 	{p=newNode("Expression");insert(p,$1);insert(p,$3);$$=p;}
	|  INTNUM	{p=newNode("Expression");insert(p,$1);$$=p;}
	|  REALNUM	{p=newNode("Expression");insert(p,$1);$$=p;}
	|  ID	{p=newNode("Expression");insert(p,$1);$$=p;}
	|  '(' Expression ')'	{p=newNode("Expression");insert(p,$2);$$=p;}
	|  ID '(' ActualParams ')'	{p=newNode("Expression");insert(p,$1);insert(p,$3);$$=p;}
	;
BoolExpression:
	     Expression "==" Expression {p=newNode("BoolExpression");insert(p,$1);insert(p,$3);$$=p;}
	|    Expression "!=" Expression	{p=newNode("BoolExpression");insert(p,$1);insert(p,$3);$$=p;}
	;
ActualParams:
	    ActualParams ',' Expression {insert($1,$3);}
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
	printTree(saveTree);
	return 0;
}
