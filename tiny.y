%{
#include <stdio.h>
#include<stdlib.h>
#include<stdarg.h>
#include"tiny.h"

nodeType *opr(int oper,int nops, ...);
nodeType *id(int i);
nodeType *con(int value);
void freeNode(nodeType *p);
int yylex(void);
void yyerror(char *s);
int intSym[20];
int realSym[20];
%}

%union {
	int iValue;
	double rValue;
	int isIndex;
	int rsIndex;
	nodeType *nPtr;
};

%token <iValue> Int 
%token <rValue> Real
%token <isIndex> ID 
%token <rsIndex> ID
%token IF WRITE READ RETURN BEGIN END MAIN INT REAL WHILE
%token ENDWHILE DO TO DOWNTO FOR ENDDO
%nonassoc IFX
%nonassoc ELSE

%left EQ NE AS
%left '+' '-'
%left '*' '/' 

%type <nptr> Program MethodDecl Type FormalParams Block FormalParam Statement LocalVarDecl AssignStmt ReturnStmt IfStmt WriteStmt ReadStmt Expression BoolExpression QString MultiplicativeExpr PrimaryExpr Actualparams 

%%

Type:
	INT	{$$=
Programs:
	 
