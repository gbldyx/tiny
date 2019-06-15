%{
#include "tiny.h"
#include <stdio.h>
#include <stdlib.h>

Node* p;
Node* temp;
int yylex(void);
void yyerror(char *s);
static Node* saveTree;
%}

%union{
	struct Node* nPtr;
	int intcon;
	float realcon;
	int entry;
}
%token <entry> QString
%token <intcon> INTNUM
%token <realcon> REALNUM 
%token <entry> ID 
%token INT REAL
%token IF WRITE READ RETURN _BEGIN END MAIN WHILE
%token ENDWHILE DO TO DOWNTO FOR ENDDO
%nonassoc IFX
%nonassoc ELSE

%left EQ NE AS
%left '+' '-'
%left '*' '/' 

%type <nPtr> Program MethodDecl FormalParams Block FormalParam Statement LocalVarDecl
%type <nPtr> Statements AssignStmt ReturnStmt IfStmt WriteStmt ReadStmt FPList PrimaryExpr
%type <nPtr> Expression BoolExpression ActualParams APList MultiplicativeExpr
%type <nPtr> WhileStmt DowhileStmt ForStmt

%%

Program:
	Program MethodDecl {insert($1,$2);$$=$1;}
	|MethodDecl	{p=newNode(stmt);p->op=prog;insert(p,$1);saveTree=p;$$=p;} 
	;

MethodDecl:
	 INT MAIN ID '(' FPList ')' Block
	{sym[($3)].vtype=intType;
	(sym[($3)]).itype=mainfun;
	$$=$7;
	}
	| 
	 INT ID '(' FPList ')' Block 
	{sym[($2)].vtype=intType;
	sym[($2)].itype=fun;
	$$=$6;
	}
	|
	 REAL MAIN ID '(' FPList ')' Block 
	{sym[($3)].vtype=realType;
	sym[($3)].itype=mainfun;
	$$=$7;
	}
	|
	 REAL ID '(' FPList ')' Block 
	{sym[($2)].vtype=realType;
	sym[($2)].itype=fun;
	$$=$6;
	}
	;

FPList:
	FormalParams {$$=$1;}
	| {$$=NULL;}	
	;

FormalParams:
	  FormalParams ',' FormalParam 
	| FormalParam	
	;
	 
FormalParam:
	   INT ID {sym[($2)].vtype=intType;sym[($2)].itype=prm;}
	|  REAL ID {sym[($2)].vtype=realType;sym[($2)].itype=prm;}
	;

Block:
     	_BEGIN Statements END {$$=$2;}
	;
Statements:
	  Statements Statement {if($2!=NULL)
					insert($1,$2);
				$$=$1;}
	| Statement {p=newNode(stmt);p->op=stmts;
		    if($1!=NULL)
			insert(p,$1);
		    $$=p;}
	;

Statement:
	 Block {$$=$1;}
	| LocalVarDecl {$$=NULL;}
	| AssignStmt {$$=$1;}
	| ReturnStmt {$$=$1;}
	| IfStmt {$$=$1;}
	| WriteStmt {$$=$1;}
	| ReadStmt {$$=$1;}
	| WhileStmt {$$=$1;}
	| DowhileStmt {$$=$1;}
	| ForStmt {$$=$1;}
	;
LocalVarDecl:
	INT ID ';' {sym[($2)].vtype=intType;sym[($2)].itype=var;}
	| REAL ID ';' {sym[($2)].vtype=realType;sym[($2)].itype=var;}
	;

AssignStmt:
	 ID AS Expression ';' {p=newNode(stmt);p->op=assign;
				temp=newNode(id);temp->entry=$1;
				insert(p,temp);insert(p,$3);$$=p;}
	;

ReturnStmt:
	  RETURN Expression ';' {p=newNode(stmt);p->op=ret;insert(p,$2);$$=p;}
	;
IfStmt:
      	IF '(' BoolExpression ')' Statements %prec IFX
	{p=newNode(stmt);p->op=ifstmt;insert(p,$3);insert(p,$5);$$=p;}
	| IF '(' BoolExpression ')' Statements ELSE Statements 
	{p=newNode(stmt);p->op=ifstmt;insert(p,$3);insert(p,$5);insert(p,$7);$$=p;}
	;

WriteStmt:
	 WRITE '(' Expression ',' QString ')' ';'
	{p=newNode(stmt);p->op=wrt;insert(p,$3);temp=newNode(str);temp->entry=$5;insert(p,temp);$$=p;}
	;

ReadStmt:
	READ '(' ID ',' QString ')' ';'
	{p=newNode(stmt);p->op=rd;temp=newNode(id);temp->entry=$3;insert(p,temp);temp=newNode(str);temp->entry=$5;insert(p,temp);$$=p;}
	;

WhileStmt:
	 WHILE BoolExpression DO Statements ENDWHILE
	{p=newNode(stmt);p->op=whilestmt;insert(p,$2);insert(p,$4);$$=p;}
	;

DowhileStmt:
	 DO Statements WHILE BoolExpression ';' 
	{p=newNode(stmt);p->op=dostmt;insert(p,$2);insert(p,$4);$$=p;}
	;

ForStmt:
       FOR ID AS Expression TO Expression DO Statements ENDDO 
	{p=newNode(stmt);p->op=forto;temp=newNode(id);temp->entry=$2;insert(p,temp);insert(p,$4);insert(p,$6);insert(p,$8);$$=p;}
	| FOR ID AS Expression DOWNTO Expression DO Statements ENDDO
	{p=newNode(stmt);p->op=fordownto;temp=newNode(id);temp->entry=$2;insert(p,temp);insert(p,$4);insert(p,$6);insert(p,$8);$$=p;}
	;

Expression:
	  Expression '+' MultiplicativeExpr	{p=newNode(exp);p->op=add;insert(p,$1);insert(p,$3);$$=p;}
	|  Expression '-' MultiplicativeExpr 	{p=newNode(exp);p->op=sub;insert(p,$1);insert(p,$3);$$=p;}
	|  MultiplicativeExpr  {$$=$1;}
	;

MultiplicativeExpr:
	   MultiplicativeExpr '*' PrimaryExpr	{p=newNode(exp);p->op=mult;insert(p,$1);insert(p,$3);$$=p;}
	|  MultiplicativeExpr '/' PrimaryExpr	{p=newNode(exp);p->op=dv;insert(p,$1);insert(p,$3);$$=p;}
	|  PrimaryExpr  {$$=$1;}
	;
PrimaryExpr:
	  INTNUM	{p=newNode(con);p->vtype=intType;(p->val).intNum=$1;$$=p;}
	|  REALNUM	{p=newNode(con);p->vtype=realType;(p->val).realNum=$1;$$=p;}
	|  ID	{p=newNode(id);p->entry=$1;$$=p;}
	|  '(' Expression ')'	{$$=$2;}
	|  ID '(' APList ')'	{p=newNode(exp);p->op=call;
				temp=newNode(id);temp->entry=$1;
				insert(p,temp);
				if($3!=NULL)
					insert(p,$3);
				$$=p;}
	;
BoolExpression:
	     Expression EQ Expression {p=newNode(exp);p->op=eql;insert(p,$1);insert(p,$3);$$=p;}
	|    Expression NE Expression	{p=newNode(exp);p->op=neq;insert(p,$1);insert(p,$3);$$=p;}
	;
APList:
	   ActualParams {$$=$1;}
	|  {$$=NULL;}
	;
ActualParams:
	    ActualParams ',' Expression {insert($1,$3);$$=$1;}
	|   Expression	{p=newNode(exp);p->op=param;insert(p,$1);$$=p;}
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
