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
%token END_TOKEN
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
%token T_TYPED_IDENT
%token T_PLUS_IDENT

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

orcfile : root_statement_list;

root_statement_list : root_statement_list root_statement
                    | root_statement;
        
root_statement : instr_definition
               | statement
               ;

instr_definition : INSTR_TOKEN instr_id_list NEWLINE statement_list ENDIN_TOKEN  NEWLINE
                 | INSTR_TOKEN instr_id_list NEWLINE statement_list END_TOKEN NEWLINE
                 ;

instr_id_list : instr_id_list ',' instr_id
              | instr_id
              ;

instr_id      : INTEGER_TOKEN
              | T_IDENT
              | T_PLUS_IDENT
              ;


statement_list : statement_list statement 
              | statement
              ;


statement : out_arg_list '=' expr NEWLINE
          | opcall
          | if_goto
          | if_then
          | LABEL_TOKEN NEWLINE
          | NEWLINE
          ;

/* 
  opcode calls that we need to worry about during parsing
  0  op  0  - no in or out args, single name
  
  something(a)
  something (a)
 
  - this is a function call, but we will match it as an opcall to prevent shift/reduce
*/
opcall  : T_IDENT NEWLINE
        | out_arg_list expr_list NEWLINE 
        | out_arg_list '(' ')' NEWLINE
        | out_arg_list T_IDENT expr_list NEWLINE
        ;

if_goto : IF_TOKEN expr goto_op T_IDENT NEWLINE
        ;

if_then : if_then_base ENDIF_TOKEN NEWLINE
        | if_then_base ELSE_TOKEN statement_list ENDIF_TOKEN NEWLINE
        | if_then_base elseif_list ENDIF_TOKEN NEWLINE
        | if_then_base elseif_list ELSE_TOKEN statement_list ENDIF_TOKEN NEWLINE
        ;

if_then_base : IF_TOKEN expr then NEWLINE statement_list
              ;

elseif_list : elseif_list elseif
            | elseif
            ;

elseif : ELSEIF_TOKEN expr then NEWLINE statement_list
       ;

function_call : T_TYPED_IDENT '(' expr_list ')'
             | T_TYPED_IDENT '(' ')'
             | T_IDENT '(' expr_list ')'
             | T_IDENT '(' ')'
             ;

expr_list : expr_list ',' expr
         | expr
         ;

out_arg_list : out_arg_list ',' out_arg
             | out_arg
             ;

out_arg : T_IDENT
        | T_TYPED_IDENT
        | array
        ;

array : T_IDENT '[' expr ']'
      ;

expr    : function_call
        | '(' expr ')'
        | T_IDENT
        | INTEGER_TOKEN
        | NUMBER_TOKEN
        | array
        ;

then  : THEN_TOKEN
      | KTHEN_TOKEN
      | ITHEN_TOKEN
      ;

/* OPERATORS */

goto_op : GOTO_TOKEN
        | IGOTO_TOKEN
        | KGOTO_TOKEN
        ;
