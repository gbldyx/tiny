%{
#include<stdio.h>
#include<stdlib.h>
#include"y.tab.h"
#include"tiny.h"
void yyerror(char *);

%}

delim	[ \t \n]
ws	{delim}+
digit	[0-9]
letter	[A-Za-z_]
id	{letter}({letter}|{digit})*
digits	{digit}+
number	{digits}|({digits}"."{digits})


%%

{ws} {;}
"IF" {return (IF);}
"ELSE" {return (ELSE);}
"WRITE" {return (WRITE);}
"READ" {return (READ);}
"RETURN" {return (RETURN);}
"BEGIN" {return (_BEGIN);}
"END" {return (_END);}
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
[;,()-+*/=] {return *yytext;}
"==" {return EQ;}
"!=" {return NE;}
{id} {return (ID);}
{number} {return (NUM);}
. {yyerror("Unknown character";}

%%
int yywrap(){
	return 1;
}

