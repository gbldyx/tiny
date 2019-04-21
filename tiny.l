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
#define NUM 23
#define ERR 24
#define NEWLINE 25
#define RELOP 26
#define WHILE 27
#define ENDWHILE 28
#define DO 29
#define TO 30
#define DOWNTO 31
#define FOR 32
#define ENDDO 33

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
";" {return (RELOP);}
"," {return (RELOP);}
"(" {return (RELOP);}
")" {return (RELOP);}
"+" {return (RELOP);}
"-" {return (RELOP);}
"*" {return (RELOP);}
"/" {return (RELOP);}
"=" {return (RELOP);}
"==" {return (RELOP);}
"!=" {return (RELOP);}
{id} {return (ID);}
{number} {return (NUM);}

%%
int yywrap(){
	return 1;
}
void writeout(int c){
	switch(c){
	case ERR: fprintf(yyout, "ERRCHAR: %s", yytext);break;
	case RELOP: fprintf(yyout,"RELOP: %s",yytext);break;
	case ID: fprintf(yyout,"IDENTIFIER: %s",yytext);break;
	case NUM: fprintf(yyout,"NUMBER: %s",yytext);break;
	case IF: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case ELSE: fprintf(yyout,"RESERVED WORD: %s",yytext);break;
	case WRITE: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case READ: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case RETURN: fprintf(yyout,"RESERVED WORD: %s",yytext);break;
	case _BEGIN: fprintf(yyout,"RESERVED WORD: %s",yytext);break;
	case _END: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case MAIN: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case INT: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case REAL: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case WHILE: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case ENDWHILE: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case DO: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case TO:fprintf(yyout,"RESERVED WORD: %s",yytext);break;
	case DOWNTO: fprintf(yyout,"RESERVED WORD: %s",yytext);break;
	case FOR: fprintf(yyout,"RESERVED WORD: %s",yytext);break;
	case ENDDO: fprintf(yyout, "RESERVED WORD: %s",yytext);break;
	case NEWLINE: fprintf(yyout,"\n");break;
	default: break;
	}
	return;
}
int main(int argc, char **argv)
{
	int c;
	if(argc>=2)
	{
		if((yyin=fopen(argv[1],"r"))==NULL)
		{
			printf("Can not open file: %s\n",argv[1]);
			return 1;
		}
		if(argc>=3)
			yyout=fopen(argv[2],"w");
	}
	while(c=yylex())
	{
		writeout(c);
		writeout(NEWLINE);
	}
	if(argc>=2)
	{
		fclose(yyin);
		if(argc>=3) fclose(yyout);
	}
	return 0;
}
