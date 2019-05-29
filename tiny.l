%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"tiny.tab.h"
#include"tiny.h"
void yyerror(char *s);
char* s;
char buf[100];
//extern Node* yylval;

%}

delim	[ \t \n]
ws	{delim}+
digit	[0-9]
letter	[A-Za-z_]
id	{letter}({letter}|{digit})*
digits	{digit}+
intnum	{digits}
realnum {digits}"."{digits}
string	\"(\\.|[^"\\])*\"
%x STRING
%s COMMENT

%%

"/**"	{BEGIN COMMENT;}
<COMMENT>"**/" {BEGIN 0;}
<COMMENT>.|\n	{;}
\"	{BEGIN STRING;s=buf;}
<STRING>\\n	{*s++ ='\n';}
<STRING>\\t	{*s++ ='\t';}
<STRING>\\\"	{*s++ ='\"';}
<STRING>\"	{*s=0;BEGIN 0;yylval.nPtr=newNode(s);return QString;}
<STRING>\n	{printf("invalid string");}
<STRING>.	{*s++ =*yytext;}
{ws} {;}
"IF" {return IF;}
"ELSE" {return ELSE;}
"WRITE" {return WRITE;}
"READ" {return READ;}
"RETURN" {return RETURN;}
"BEGIN" {return (_BEGIN);}
"END" {return END;}
"MAIN" {return (MAIN);}
"INT" {yylval.nPtr=newNode("INT");return (INT);}
"REAL" {yylval.nPtr=newNode("REAL");return (REAL);}
"WHILE" {return (WHILE);}
"ENDWHILE" {return (ENDWHILE);}
"DO" {return (DO);}
"TO" {return (TO);}
"DOWNTO" {return (DOWNTO);}
"FOR" {return (FOR);}
"ENDDO" {return (ENDDO);}
[;,()-+*/] {return *yytext;}
":=" {yylval.nPtr=newNode("AS");return AS;}
"==" {yylval.nPtr=newNode("EQ");return EQ;}
"!=" {yylval.nPtr=newNode("NE");return NE;}
{id} { yylval.nPtr=newNode(yytext); return ID;}
{intnum} {yylval.nPtr=newNode(yytext);return INTNUM;}
{realnum} {yylval.nPtr=newNode(yytext);return REALNUM;}
. {yyerror("Unknown character");}

%%
int yywrap(){
	return 1;
}

