%option yylineno
%{ 
    #include <iostream>      // for I/O
    #include <string.h>        // for string handling 
    #include <ctype.h>  
    #include <cstdlib>
    #include <stdio.h>
    #define YYSTYPE char *
    using namespace std; 
    #include "yacc.tab.h"
   int lineno=1;
   char decl_type[10];
   char var[31];
   int scope = 0;
%}
digit [0-9]
letter [a-zA-Z]
id     {letter}({letter}|{digit})*
digits	{digit}+
opFraction	(\.{digits})?
opExponent	([Ee][+-]?{digits})?
number	{digits}{opFraction}{opExponent}
uop        "++"|"--"
bop1	=
bop_less    <
bop_great    >
bop_noteq   !=
bop_lesseq   <=
bop_greateq   >=
bop_eq   ==
bop_and   &&
add     "+"
sub     "-"
mult    "*"
div     "/"
opbrack  "["
closbrack "]"
pr        "<<"
%%

int	{strcpy(decl_type,yytext); yylval = strdup(yytext); return T_INT;}
main {yylval = strdup(yytext);return T_MAIN;}
switch	{yylval = strdup(yytext);return T_SWITCH;}
float	{strcpy(decl_type,yytext); yylval = strdup(yytext); return T_FLOAT;}
char   {strcpy(decl_type,yytext); yylval = strdup(yytext); return T_CHAR;}
for     {yylval = strdup(yytext);return T_FOR;}
cout    {yylval = strdup(yytext);return T_COUT;}
case	{yylval = strdup(yytext);return T_CASE;}
break	{yylval = strdup(yytext);return T_BREAK;}
default	{yylval = strdup(yytext);return T_DEFAULT;}
return  {yylval = strdup(yytext); return T_RET;}
"#include<stdio.h>" ;
"#include<iostream>" ;
"using namespace std" ;
{pr}      return T_PR;
{opbrack} return T_OP;
{closbrack} return T_CP;
{mult} return T_MULT;
{div}  return T_DIV;
{add} return T_ADD;
{sub}  return T_SUB;
{uop}  return T_UOP;
{bop1}  return T_BOP1; 
{bop_less}  return T_BOP_LT;
{bop_great}  return T_BOP_GT;
{bop_lesseq} return T_BOP_LTE;
{bop_greateq} return T_BOP_GTE;
{bop_eq} return T_BOP_EQ;
{bop_and} return T_BOP_AND;
{id}	{strcpy(var,yytext); yylval = strdup(yytext);return T_ID;}
{number}	{yylval = strdup(yytext);return T_NUM;}
[\t|' ']	;
"//".*\n	{lineno++;}
"/"[^/]"/"	{lineno++;}
\/\/(.*)       {lineno++;}
\/\*(.*\n)*.*\*\/  {lineno++;}
[\n]       {lineno++;}
.	return *yytext;

%%
int yywrap (void)
{
    return 1;
}
