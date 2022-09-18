%{
/**
 * @file parser.ll
 * @author Jenner Higgins
 * @brief Flex scanner program that will recognize and return the tokens found in c-grammar.pdf
 * @version 0.1.5
 * @date 2022-09-17
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <cstdlib>
#include <iostream>

// The following order of #include is mandatory
#include "scanType.hh"      // TokenData type
#include "parser.tab.hh"    // token definitions from bison

int line = 1;   // line number
int numErrors;  // error count

/**
 * @brief Sets the values of the TokenData object based on input read in by flex
 * 
 * @param linenum The line number
 * @param tokenClass The token class label 
 * @param svalue The string value read in by flex 
 * @return The token class value, %token <tokenData> for bison
 */
static int setValue(int linenum, int tokenClass, char *svalue)
{
    // create pass-back data space
    yylval.tokenData = new TokenData;

    yylval.tokenData -> linenum = linenum;
    yylval.tokenData -> tokenstr = strdup(svalue);      // duplicating string

    if(tokenClass == NUMCONST)
    {
        yylval.tokenData -> nvalue = atof(svalue);
    } 
    else if(tokenClass == BOOLCONST) 
    {
        if(strcmp("true", svalue)) {
            yylval.tokenData -> nvalue = 0;
        } else {
            yylval.tokenData -> nvalue = 1;
        }
    } 
    else if(tokenClass == KEYWORD) 
    {
        int i = 0;
        while (svalue[i] != '\0') {
            svalue[i] = svalue[i] - 32;     // converts lowercase to uppercase letters in ASCII
            i++;
        }
        yylval.tokenData -> svalue = strdup(svalue);
    } 
    else if (tokenClass == CHARCONST) 
    {
        if (strlen(svalue) > 3 && svalue[1] != 92) {
            printf("WARNING(%d): character is %lu characters long and not a single character: '%s'. The first char will be used.\n", linenum, strlen(svalue) - 2, svalue); 
        } 
        if (svalue[1] == 92) {              // escape characters '\'
            if (svalue[2] == 110) {         // newline character '\n'
                yylval.tokenData -> svalue = strdup(svalue);
                svalue[1] = '\n';
                svalue[2] = '\'';
                svalue[3] = '\0';
                yylval.tokenData -> cvalue = svalue[1];
            } else if (svalue[2] == 48) {   // null character '\0'
                yylval.tokenData -> svalue = strdup(svalue);
                svalue[1] = '\0';
                svalue[2] = '\'';
                svalue[3] = '\0';
                yylval.tokenData -> cvalue = svalue[1];
            } else {
                yylval.tokenData -> svalue = strdup(svalue);
                svalue[1] = svalue[2];
                svalue[2] = '\'';
                svalue[3] = '\0';
                yylval.tokenData -> cvalue = svalue[1];
            }
        } else {
            yylval.tokenData -> svalue = strdup(svalue);
            yylval.tokenData -> cvalue = svalue[1];
        }
    } 
    else if (tokenClass == STRINGCONST) 
    {
        char *rawstr = strdup(svalue);
        char *str = rawstr;

        rawstr[strlen(rawstr)] = '\0';
        str[strlen(rawstr)] = '\0';

        int len = strlen(rawstr);
        int j = 0;
        for(int i  = 1; i < len ; i++) {

            str[j] = rawstr[i];

            if(rawstr[i] == 92 && rawstr[i+1] == 110) {         // newline character '\n'
                str[j] = 10;
                i++;
            }
            else if(rawstr[i] == 92 && rawstr[i+1] == 48) {     // null character '\0'
                str[j] = 0;
                i++;
            }
            else if(rawstr[i] == 92) {                          // escape characters '\'
                str[j] = rawstr[i+1];
                i++;
            }
            j++;
        }
        str[j-1] = '\0';
        yylval.tokenData -> svalue = strdup(str);
        yylval.tokenData -> slen = strlen(str);
    }
    else if(tokenClass == ID || tokenClass == OP) 
    {
        yylval.tokenData -> svalue = strdup(svalue);
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

"static"                { return setValue(line, KEYWORD, yytext); }         // Keywords
"bool"                  { return setValue(line, KEYWORD, yytext); }
"char"                  { return setValue(line, KEYWORD, yytext); }
"int"                   { return setValue(line, KEYWORD, yytext); }
"begin"                 { return setValue(line, KEYWORD, yytext); }
"end"                   { return setValue(line, KEYWORD, yytext); }
"if"                    { return setValue(line, KEYWORD, yytext); }
"then"                  { return setValue(line, KEYWORD, yytext); }
"else"                  { return setValue(line, KEYWORD, yytext); }
"while"                 { return setValue(line, KEYWORD, yytext); }
"do"                    { return setValue(line, KEYWORD, yytext); }
"for"                   { return setValue(line, KEYWORD, yytext); }
"to"                    { return setValue(line, KEYWORD, yytext); }
"by"                    { return setValue(line, KEYWORD, yytext); }
"return"                { return setValue(line, KEYWORD, yytext); }
"break"                 { return setValue(line, KEYWORD, yytext); }
"or"                    { return setValue(line, KEYWORD, yytext); }
"and"                   { return setValue(line, KEYWORD, yytext); }
"not"                   { return setValue(line, KEYWORD, yytext); }

"true"                  { return setValue(line, BOOLCONST, yytext); }       // Booleans
"false"                 { return setValue(line, BOOLCONST, yytext); }

\/\/.*[\n]              { line++; }                                         // Comments

\"(\\.|[^"\\\n])*\"     { return setValue(line, STRINGCONST, yytext); }     // Strings 

\'(\\.|[^'\\\n])*\'     { return setValue(line, CHARCONST, yytext); }       // Characters (single)

"++"                    { return setValue(line, INC, yytext); }             // Double character operators
"--"                    { return setValue(line, DEC, yytext); }
"<-"                    { return setValue(line, ASGN, yytext); }
"+="                    { return setValue(line, ADDASS, yytext); }
"-="                    { return setValue(line, SUBASS, yytext); }
"*="                    { return setValue(line, MULASS, yytext); }
"/="                    { return setValue(line, DIVASS, yytext); }
"<="                    { return setValue(line, LEQ, yytext); }
">="                    { return setValue(line, GEQ, yytext); }
"!="                    { return setValue(line, NEQ, yytext); }
"=="                    { return setValue(line, EQ, yytext); }

";"                     { return setValue(line, OP, yytext); }              // Single character operators
","                     { return setValue(line, OP, yytext); }
":"                     { return setValue(line, OP, yytext); }
"("                     { return setValue(line, OP, yytext); }
")"                     { return setValue(line, OP, yytext); }
"["                     { return setValue(line, OP, yytext); }
"]"                     { return setValue(line, OP, yytext); }
"{"                     { return setValue(line, OP, yytext); }
"}"                     { return setValue(line, OP, yytext); }
"<"                     { return setValue(line, OP, yytext); }
">"                     { return setValue(line, OP, yytext); }
"="                     { return setValue(line, OP, yytext); }
"+"                     { return setValue(line, OP, yytext); }
"-"                     { return setValue(line, OP, yytext); }
"*"                     { return setValue(line, OP, yytext); }
"/"                     { return setValue(line, OP, yytext); }
"%"                     { return setValue(line, OP, yytext); }
"?"                     { return setValue(line, OP, yytext); }

{number}                { return setValue(line, NUMCONST, yytext); }                    
{identifier}            { return setValue(line, ID, yytext); }                          
{newline}               { line++; }                                                     
{whitespace}            { ; }                                                           

.       { printf("ERROR(%d): Invalid or misplaced input character: '%s'. Character Ignored.\n", line, yytext); numErrors++;}     // No match error
%%
