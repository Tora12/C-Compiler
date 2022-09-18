%{
/**
 * @file parser.yy
 * @author Jenner Higgins
 * @brief Bison parser
 * @version 0.1.5
 * @date 2022-09-17
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <cstdio>
#include <cstdlib>
#include <iostream>

#include "scanType.hh" // TokenData type

extern int yylex();
extern FILE *yyin;
extern int line;        // line number from the scanner
extern int numErrors;   // error count

#define YYERROR_VERBOSE
void yyerror(const char *msg) {
    printf("ERROR(%d): '%s'\n", line, msg);
    numErrors++;
}

%}

// included in tab.h file
%union {
    TokenData * tokenData;
    double value;
}

%token <tokenData> NUMCONST STRINGCONST CHARCONST BOOLCONST KEYWORD OP ID INC DEC ASGN ADDASS SUBASS MULASS DIVASS LEQ GEQ NEQ EQ INVALID
%type <value> declList MULOP

%%
program : declList program
        |
;

declList : NUMCONST         { printf("Line %d Token: NUMCONST Value: %d  Input: %s\n", $1->linenum, $1->nvalue, $1->tokenstr); }
         | STRINGCONST      { printf("Line %d Token: STRINGCONST Value: \"%s\"  Len: %d  Input: %s\n", $1->linenum, $1->svalue, $1->slen, $1->tokenstr); }
         | CHARCONST        { printf("Line %d Token: CHARCONST Value: '%c'  Input: %s\n", $1->linenum, $1->cvalue, $1->tokenstr); }
         | BOOLCONST        { printf("Line %d Token: BOOLCONST Value: %d  Input: %s\n", $1->linenum, $1->nvalue, $1->tokenstr); }
         | KEYWORD          { printf("Line %d Token: %s\n", $1->linenum, $1->svalue); }
         | OP               { printf("Line %d Token: %s\n", $1->linenum, $1->svalue); }
         | ID               { printf("Line %d Token: ID Value: %s\n", $1->linenum, $1->svalue); }
         | INVALID          { printf("ERROR(%d): Invalid or misplaced input character: '%s'. Character Ignored.\n", $1->linenum, $1->tokenstr);}
         | MULOP
;

MULOP : INC                 { printf("Line %d Token: INC\n", $1->linenum); }
      | DEC                 { printf("Line %d Token: DEC\n", $1->linenum); }
      | ASGN                { printf("Line %d Token: ASGN\n", $1->linenum); }
      | ADDASS              { printf("Line %d Token: ADDASS\n", $1->linenum); }
      | SUBASS              { printf("Line %d Token: SUBASS\n", $1->linenum); }
      | MULASS              { printf("Line %d Token: MULASS\n", $1->linenum); }
      | DIVASS              { printf("Line %d Token: DIVASS\n", $1->linenum); }
      | LEQ                 { printf("Line %d Token: LEQ\n", $1->linenum); }
      | GEQ                 { printf("Line %d Token: GEQ\n", $1->linenum); }
      | NEQ                 { printf("Line %d Token: NEQ\n", $1->linenum); }
      | EQ                  { printf("Line %d Token: EQ\n", $1->linenum); }
;

%%

int main(int argc, char * argv[])
{
    if(argc > 1) {
        if((yyin = fopen(argv[1], "r"))) {
            // file open success
        } else {
            printf("FILE ERROR: failed to open \'%s\'\n", argv[1]);
            exit(1);
        }
    }

    numErrors = 0;
    yyparse();

    // printf("Number of errors: %d\n", numErrors);

    return 0;
}