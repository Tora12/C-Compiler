%{
// Jenner Higgins
// Flex Scanner

#include <cstdlib>

// the following order is mandatory
#include "scanType.hpp"     // TokenData type
#include "parser.tab.hh"    // token definitions from bison

int line = 1;   // line number
int numErrors;  // error count

static int setValue(int linenum, int tokenClass, char *svalue)
{
    // create pass-back data space
    yylval.tokenData = new TokenData;

    yylval.tokenData -> linenum = linenum;
    yylval.tokenData -> tokenstr = strdup(svalue); // duplicating string


    if(tokenClass == NUMCONST) {

        yylval.tokenData -> nvalue = atof(svalue);

    } else if (tokenClass == STRINGCONST) {

        char *tmp = strdup(svalue);
        char *sbuffer = tmp;

        tmp[strlen(tmp)] = '\0';
        sbuffer[strlen(tmp)] = '\0';
        int len = strlen(tmp);

        int j = 0;
        for(int i  = 1; i < len ; i++) {

            sbuffer[j] = tmp[i];

            if(tmp[i] == 92 && tmp[i+1] == 110) {
                sbuffer[j] = 10;        // new line char
                i++;
            }
            else if(tmp[i] == 92 && tmp[i+1] == 48) {
                sbuffer[j] = 0;         // nul char
                i++;
            }
            else if(tmp[i] == 92) {
                sbuffer[j] = tmp[i+1];
                i++;
            }
            j++;
        }

        sbuffer[j-1] = '\0';
        yylval.tokenData -> svalue = strdup(sbuffer);
        yylval.tokenData -> slen = strlen(sbuffer);

    } else if (tokenClass == CHARCONST) {
       
        if (strlen(&svalue[0]) > 3 && svalue[1] != 92) {
            printf("WARNING(%d): character is %lu characters long and not a single character: '%s'.  The first char will be used.\n", linenum, strlen(svalue) - 2, svalue); // NOTE: Double space
        } if (svalue[1] == 92) { // "escape characters"
            if (svalue[2] == 110) {
                yylval.tokenData -> tokenstr = strdup(&svalue[0]);
                svalue[1] = '\n';
                svalue[2] = '\'';
                svalue[3] = '\0';
                yylval.tokenData -> cvalue = svalue[1];
            } else if (svalue[2] == 48) {
                yylval.tokenData -> tokenstr = strdup(&svalue[0]);
                svalue[1] = '\0';
                svalue[2] = '\'';
                svalue[3] = '\0';
                yylval.tokenData -> cvalue = svalue[1];
            } else {
                yylval.tokenData -> tokenstr = strdup(&svalue[0]);
                svalue[1] = svalue[2];
                svalue[2] = '\'';
                svalue[3] = '\0';
                yylval.tokenData -> cvalue = svalue[1];
            }
        } else {
            yylval.tokenData -> tokenstr = strdup(&svalue[0]);
            yylval.tokenData -> cvalue = svalue[1];
        }

    } else if (tokenClass == BOOLCONST) {
        if(strcmp("true", svalue)) {
            yylval.tokenData -> nvalue = 0;
        } else {
            yylval.tokenData -> nvalue = 1;
        }

    } else if (tokenClass == KEYWORD) {
        int i = 0;
        while (svalue[i]) {
            svalue[i] = svalue[i] - 32; // ASCII capitol letters
            i++;
            yylval.tokenData -> tokenstr = strdup(svalue);
        }
    } 

    return tokenClass;
}

%}

%option noyywrap
%option nounput

digit [0-9]
number {digit}+
letter [a-zA-Z]
identifier {letter}+[0-9a-zA-Z]*
newline \n
whitespace[ \t]+

%%

"static"       { return setValue(line, KEYWORD, yytext); } // keywords
"bool"         { return setValue(line, KEYWORD, yytext); }
"char"         { return setValue(line, KEYWORD, yytext); }
"int"          { return setValue(line, KEYWORD, yytext); }
"begin"        { return setValue(line, KEYWORD, yytext); }
"end"          { return setValue(line, KEYWORD, yytext); }
"if"           { return setValue(line, KEYWORD, yytext); }
"then"         { return setValue(line, KEYWORD, yytext); }
"else"         { return setValue(line, KEYWORD, yytext); }
"while"        { return setValue(line, KEYWORD, yytext); }
"do"           { return setValue(line, KEYWORD, yytext); }
"for"          { return setValue(line, KEYWORD, yytext); }
"to"           { return setValue(line, KEYWORD, yytext); }
"by"           { return setValue(line, KEYWORD, yytext); }
"return"       { return setValue(line, KEYWORD, yytext); }
"break"        { return setValue(line, KEYWORD, yytext); }
"or"           { return setValue(line, KEYWORD, yytext); }
"and"          { return setValue(line, KEYWORD, yytext); }
"not"          { return setValue(line, KEYWORD, yytext); }

"true"         { return setValue(line, BOOLCONST, yytext); }
"false"        { return setValue(line, BOOLCONST, yytext); }

\/\/.*[\n]     { line++; } // comments

\"(\\.|[^"\\\n])*\"       { return setValue(line, STRINGCONST, yytext); } // strings 

\'(\\.|[^'\\\n])*\'       { return setValue(line, CHARCONST, yytext); } // single characters



{number}     { return setValue(line, NUMCONST, yytext); } // numbers
{identifier} { return setValue(line, ID, yytext); } // indentifiers

"++"           { return setValue(line, INC, yytext); } // double char operators
"--"           { return setValue(line, DEC, yytext); }
"<-"           { return setValue(line, ASGN, yytext); }
"+="           { return setValue(line, ADDASS, yytext); }
"-="           { return setValue(line, SUBASS, yytext); }
"*="           { return setValue(line, MULASS, yytext); }
"/="           { return setValue(line, DIVASS, yytext); }
"<="           { return setValue(line, LEQ, yytext); }
">="           { return setValue(line, GEQ, yytext); }
"!="           { return setValue(line, NEQ, yytext); }
"=="           { return setValue(line, EQ, yytext); }

";"            { return setValue(line, OP, yytext); } // single char operators
","            { return setValue(line, OP, yytext); }
":"            { return setValue(line, OP, yytext); }
"("            { return setValue(line, OP, yytext); }
")"            { return setValue(line, OP, yytext); }
"["            { return setValue(line, OP, yytext); }
"]"            { return setValue(line, OP, yytext); }
"{"            { return setValue(line, OP, yytext); }
"}"            { return setValue(line, OP, yytext); }
"<"            { return setValue(line, OP, yytext); }
">"            { return setValue(line, OP, yytext); }
"="            { return setValue(line, OP, yytext); }
"+"            { return setValue(line, OP, yytext); }
"-"            { return setValue(line, OP, yytext); }
"*"            { return setValue(line, OP, yytext); }
"/"            { return setValue(line, OP, yytext); }
"%"            { return setValue(line, OP, yytext); }
"?"            { return setValue(line, OP, yytext); }

{newline}    { line++; }
{whitespace} { ; }

.           { return setValue(line, INVALID, yytext); } // No match error
%%
