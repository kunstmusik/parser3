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
IDENTIFIER      [a-zA-Z_][a-zA-Z0-9_]*
TYPED_IDENTIFIER  [a-zA-Z_][a-zA-Z0-9_]*(:[a-zA-Z_][a-zA-Z0-9_]*)?
INTEGER           [0-9]+
NUMBER          [0-9]+\.?[0-9]*(e[-+]?[0-9]+)?|\.[0-9]+(e[-+]?[0-9]+)?|0[xX][0-9a-fA-F]+
WHITE           [ \t]+
CHAR            .
SEMI_COLON_LINE_COMMENT ;.*
LINE_COMMENT "//".*
/*CONT            \\[ \t]*(;.*)?\n*/
%x line
%x src
%x xstr
%x udodef
%x udoarg

%%


\r      { } /* EATUP THIS PART OF WINDOWS NEWLINE */
{WHITE}   { }
{SEMI_COLON_LINE_COMMENT}   {} /* single line comment */
{LINE_COMMENT}   {} /* single line comment */
\n      { return NEWLINE; }
instr { return INSTR_TOKEN; }
endin { return ENDIN_TOKEN; }
end { return END_TOKEN; }
if      { return IF_TOKEN; }
then    { return THEN_TOKEN; }
ithen    { return ITHEN_TOKEN; }
kthen    { return KTHEN_TOKEN; }
else    { return ELSE_TOKEN; }
elseif  { return ELSEIF_TOKEN; }
endif  { return ENDIF_TOKEN; }
0dbfs   { return T_IDENT; }
goto  { return GOTO_TOKEN; }
igoto  { return IGOTO_TOKEN; }
kgoto  { return KGOTO_TOKEN; }
{LABEL} { return LABEL_TOKEN; }
\+{IDENTIFIER} { return T_PLUS_IDENT; } 
{IDENTIFIER}  { return T_IDENT; }
{TYPED_IDENTIFIER}  { return T_TYPED_IDENT; }
{INTEGER}  { return INTEGER_TOKEN; }
{NUMBER}  { return NUMBER_TOKEN; }
{CHAR} { return yytext[0]; }
