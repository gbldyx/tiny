%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"tiny.tab.h"
#include"tiny.h"
void yyerror(char *s);
char* s;
char buf[100];

%}

delim	[ \t \n]
ws	{delim}+
digit	[0-9]
letter	[A-Za-z_]
id	{letter}({letter}|{digit})*
digits	{digit}+
intnum	{digits}
realnum {digits}"."{digits}
%x STRING
%x COMMENT

%%

"/**"	{BEGIN COMMENT;}
<COMMENT>"**/" {BEGIN 0;}
<COMMENT>.|\n	{;}
\"	{BEGIN STRING;s=buf;}
<STRING>\\n	{*s++ ='\n';}
<STRING>\\t	{*s++ ='\t';}
<STRING>\\\"	{*s++ ='\"';}
<STRING>\"	{*s=0;BEGIN 0;yylval.entry=storeStr(buf);return QString;}
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
"INT" {return (INT);}
"REAL" {return (REAL);}
"WHILE" {return (WHILE);}
"ENDWHILE" {return (ENDWHILE);}
"DO" {return (DO);}
"TO" {return (TO);}
"DOWNTO" {return (DOWNTO);}
"FOR" {return (FOR);}
"ENDDO" {return (ENDDO);}
[-;,()+*/] {return *yytext;}
":=" {return AS;}
"==" {return EQ;}
"!=" {return NE;}
{id} {yylval.entry=find(yytext);return ID;}
{intnum} {yylval.intcon=atoi(yytext);return INTNUM;}
{realnum} {yylval.realcon=atof(yytext);return REALNUM;}
. {yyerror("Unknown character");}

%%
int yywrap(){
	return 1;
}
