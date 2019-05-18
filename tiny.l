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
<STRING>\"	{*s=0;BEGIN 0;yylval=newNode(s);return QString;}
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
"INT" {yylval=newNode("INT");return (INT);}
"REAL" {yylval=newNode("REAL");return (REAL);}
"WHILE" {return (WHILE);}
"ENDWHILE" {return (ENDWHILE);}
"DO" {return (DO);}
"TO" {return (TO);}
"DOWNTO" {return (DOWNTO);}
"FOR" {return (FOR);}
"ENDDO" {return (ENDDO);}
[;,()-+*/] {return *yytext;}
":=" {yylval=newNode("AS");return AS;}
"==" {yylval=newNode("EQ");return EQ;}
"!=" {yylval=newNode("NE");return NE;}
{id} { yylval=newNode(yytext); return ID;}
{intnum} {yylval=newNode(yytext);return INTNUM;}
{realnum} {yylval=newNode(yytext);return REALNUM;}
. {yyerror("Unknown character");}

%%
int yywrap(){
	return 1;
}

