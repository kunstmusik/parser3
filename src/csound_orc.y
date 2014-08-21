%{
#define YYDEBUG 1
#include "csound_orcparse.h"
#include <stdio.h>

#define YYDEBUG 1
extern int csound_orclex(void);
extern int csound_orcget_lineno(void);
int csound_orcerror(char* errstr) {
    printf("Error: %s Line %d\n", errstr, csound_orcget_lineno());
    return -1;
}

%}

/*%pure_parser*/

%token NEWLINE
%token S_NEQ
%token S_AND
%token S_OR
%token S_LT
%token S_LE
%token S_EQ
%token S_ADDIN
%token S_SUBIN
%token S_MULIN
%token S_DIVIN
%token S_GT
%token S_GE
%token S_BITSHIFT_LEFT
%token S_BITSHIFT_RRIGHT

%token LABEL_TOKEN
%token IF_TOKEN

%token T_OPCODE0
%token T_OPCODE0B
%token T_OPCODE
%token T_OPCODEB

%token UDO_TOKEN
%token UDOSTART_DEFINITION
%token UDOEND_TOKEN
%token UDO_ANS_TOKEN
%token UDO_ARGS_TOKEN

%token T_ERROR

%token T_FUNCTION
%token T_FUNCTIONB

%token INSTR_TOKEN
%token ENDIN_TOKEN
%token GOTO_TOKEN
%token KGOTO_TOKEN
%token IGOTO_TOKEN

%token SRATE_TOKEN
%token KRATE_TOKEN
%token KSMPS_TOKEN
%token NCHNLS_TOKEN
%token NCHNLSI_TOKEN
%token ZERODBFS_TOKEN
%token STRING_TOKEN
%token T_IDENT

%token INTEGER_TOKEN
%token NUMBER_TOKEN
%token THEN_TOKEN
%token ITHEN_TOKEN
%token KTHEN_TOKEN
%token ELSEIF_TOKEN
%token ELSE_TOKEN
%token ENDIF_TOKEN
%token UNTIL_TOKEN
%token DO_TOKEN
%token OD_TOKEN

%token T_INSTLIST
%token S_ELIPSIS
%token T_ARRAY
%token T_ARRAY_IDENT
%token T_MAPI
%token T_MAPK

%start orcfile
%left '?'
%left S_AND S_OR
%nonassoc THEN_TOKEN ITHEN_TOKEN KTHEN_TOKEN ELSE_TOKEN /* NOT SURE IF THIS IS NECESSARY */
%left '|'
%left '&'
%left S_LT S_GT S_LEQ S_GEQ S_EQ S_NEQ
%left S_BITSHIFT_LEFT S_BITSHIFT_RIGHT
%left '+' '-'
%left '*' '/' '%'
%left '^'
%left '#'
%right '~'
%right S_UNOT
%right S_UMINUS
%right S_ATAT
%right S_AT
%token S_GOTO
%token T_HIGHEST
/*%pure_parser*/
%locations
%error-verbose
/*%define parse.trace*/
%debug


%%

orcfile : statementlist;

statementlist : statementlist statement 
              | statement
              ;

statement : T_IDENT '=' expr NEWLINE
          | NEWLINE
          ;

functioncall : T_IDENT '(' exprlist ')'
             | T_IDENT '(' ')'

             ;

exprlist : exprlist ',' expr
         | expr
         ;

expr    : functioncall
        | '(' expr ')'
        | T_IDENT
        | INTEGER_TOKEN
        | NUMBER_TOKEN
        ;

