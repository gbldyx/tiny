%{
#include<stdio.h>
#define IF 1
#define ELSE 2
#define WRITE 3
#define READ 4
#define RETURN 5
#define _BEGIN 6
#define _END 7
#define MAIN 8
#define INT 9
#define REAL 10
#define SC 11
#define CM 12
#define OP 13
#define CP 14
#define PL 15
#define MN 16
#define MP 17
#define DV 18
#define AS 19
#define EQ 20
#define NE 21
#define ID 22
#define NUMBER 23
#define ERR 24

int yylval;
%}

delim	[ \t \n]
ws	{delim}+
Digit	[0-9]
letter	[A-Za-z_]
id	{letter}({letter}|{Digit})*
Digits	{Digit}|({Digit}{Digits})
Number	{Digits}|({Digits}\.{Digits})

Type	"INT"|"REAL"
FormalParam {Type}" "{id}
FormalParams [{FormalParam}(','{FormalParam})*]
Block "BEGIN({Statement})*"END"
Statement {Block}|{LocalVarDecl}|{AssignStmt}|{ReturnStmt}|{IfStmt}|{WriteStmt}|{ReadStmt}
LocalVarDecl "INT"' '{id}';'|"REAL"' '{id}';'
PrimaryExpr {Number}|{id}|'('{Expression}')'|{id}'('{ActualParams}')'
MultiplicativeExpr {primaryExpr}(('*'|'/')PrimaryExpr)*
Expression {MultplicativeExpr}(('+'|'-')MultiplicativeExpr)*
BoolExpression {Expression}"=="{Expression}|{Expression}"!="{Expression}
ActualParams [{Expression}(','{Expression})*]
AssignStmt {id}":="{Expression}';'
ReturnStmt {RETURN}' '{Expression}';'
IfStmt "IF"'('{BoolExpression}')'Statement
WriteStmt "WRITE"'('{Expression}','{QString}')'';'
ReadStmt "READ"'('{id}','{QString}')'';' 
MethodDecl {Type}["MAIN"]{id}'('{FormalParams}')'{Block}
%s COMMENT 

%%
<INITIAL>"/**"	{BEGIN COMMENT}
<COMMENT>"**/"	{BEGIN INITIAL}

{ws} {;}
"IF" {return IF;}
"ELSE" {return ELSE;}
"WRITE" {return WRITE;}
"READ" {return READ;}
"RETURN" {return RETURN;}
"BEGIN" {return BEGIN;}
"END" {return END;}
"MAIN" {return MAIN;}
"INT" {return INT;}
"REAL" {return REAL;}
";" {yylval=SC;return RELOP;}
"," {yylval=CM;return RELOP;}
"(" {yylval=OP;return RELOP;}
")" {yylval=CP;return RELOP;}
"+" {yylval=PL;return RELOP;}
"-" {yylval=MN;return RELOP;}
"*" {yylval=MP;return RELOP;}
"/" {yylval=DV;retutn RELOP;}
"=" {yylval=AS;return RELOP;}
"==" {yylval=EQ;return RELOP;}
"!=" {yylval=NE;return RELOP;}
{id} {yylval=ID;return ID;}
{Number} {yylval=NUMBER;return NUMBER;}
. {yylval=ERR;return ERR;}

%%
int yywrap(){
	return 1;
}
void writeout(int c){
	switch(c){
	case ERR: fprintf(yyout, "ERRCHAR: %s", yytext);break;
	case RELOP: fprintf(yyout,"RELOP: %s",yytext);break;
	case 
