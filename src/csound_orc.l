%{

#include "csound_orcparse.h"
%}

/*%option reentrant*/
%option bison-bridge
%option bison-locations
%option prefix="csound_orc"
%option outfile="csound_orclex.c"
%option yylineno
/*%option stdout*/
%option noyywrap

ZERODBFS        0dbfs
STRING          \"(\\.|[^\"])*\"
LABEL           [a-zA-Z0-9_][a-zA-Z0-9_]*:[ \t\n]
IDENTIFIER      [a-zA-Z_][a-zA-Z0-9_]*(:[a-zA-Z_][a-zA-Z0-9_]*)?
INTEGER           [0-9]+
NUMBER          [0-9]+\.?[0-9]*(e[-+]?[0-9]+)?|\.[0-9]+(e[-+]?[0-9]+)?|0[xX][0-9a-fA-F]+
WHITE           [ \t]+
CHAR            .
/*CONT            \\[ \t]*(;.*)?\n*/
%x line
%x src
%x xstr
%x udodef
%x udoarg

%%


\r      { } /* EATUP THIS PART OF WINDOWS NEWLINE */
{WHITE}   { }
\n      { return NEWLINE; }
if      { return IF_TOKEN; }
then    { return THEN_TOKEN; }
else    { return ELSE_TOKEN; }
elseif  { return ELSEIF_TOKEN; }
0dbfs   { return T_IDENT; }
{IDENTIFIER}  { return T_IDENT; }
{INTEGER}  { return INTEGER_TOKEN; }
{NUMBER}  { return NUMBER_TOKEN; }
{CHAR} { return yytext[0]; }

