%{

#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

typedef struct Atributos {
    string v; 
    string c;
};

int yylex();
int yyparse();
void yyerror(const char *);

#define YYSTYPE Atributos

%}

%token ID LET
%start S

%%

S       :   DECLARE S
            { cout << $1.c << endl; }
        |
            { cout << " ." << endl; }

DECLARE :   LET IDs ';'
            { $$ = $2; }

IDs     :   IDs ',' ID
            { $$.c = $1.c + $3.v << " &"; }
        |   ID
            { $$.c = $1.v + " &"; }

%%

#include "lex.yy.c"

auto f = &yyunput;

void yyerror(const char* str) {
   puts(str); 
   printf("Proximo a: %s\n", yytext);
   exit(0);
}

int main(int argc, char* argv[]) {
    yyparse();
    return 0;
}
