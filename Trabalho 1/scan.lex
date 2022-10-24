%{
#include <iostream>
#include <string>
string lexema;

void erro(string str) {
    cout << "Erro: Identificador inválido: " << str;
}

%}

D       [0-9]
L       [áàa-zA-Z_]
S       [_$/*@]

WS      [ \t\n]

INT     {D}+
FLOAT   {INT}("."{INT})?([Ee]("+"|"-")?{INT})?

ID      ($|{L})({L}|{D})*((@)(@|{L}|{D})+)?(({L}|{D})*)

FOR     [Ff][Oo][Rr]
IF      [Ii][Ff]

STRING  (("\"")(({L}|{D}|{WS}|{S}|("\\")|("\'")|("\\\"")|("\"\""))*)("\""))|('(({L}|{D}|{WS}|{S}|("\\")|("\\\'")|("\"")|("\'\'"))*)')
STRING2 ("`")(({L}|{D}|{WS}|{S}|("\n")|("\\")|("\'")|("\""))*)(${EXPR}"}")?(({L}|{D}|{WS}|{S}|("\n")|("\\")|("\'")|("\""))*)("`")

STRING2 `([^\`]*(${EXPR}"}")?[^\`]*)`

COMENTARIO  (("//")([^\n])*)|(("/*")([^*]|"*"[^/])*("*/"))

ERRO        ({D}+({L}|{S}|{ID})+)|"@"(^\n)*|{ID}("$")+(^\n)*|"$@"

%%

    /* ignora espaços, tabs e '\n' */
{WS}	{ } 

    /* if, case insensitive */
{IF}    { lexema = yytext; return _IF; }

    /* for, case insensitive */
{FOR}   { lexema = yytext; return _FOR; }

">="    { lexema = yytext; return _MAIG; }
"<="    { lexema = yytext; return _MEIG; }
"=="    { lexema = yytext; return _IG; }
"!="    { lexema = yytext; return _DIF; }

{ERRO}  { lexema = yytext; erro(lexema); }

{INT}   { lexema = yytext; return _INT; }
{FLOAT} { lexema = yytext; return _FLOAT; }

{STRING}    { lexema = yytext; lexema = lexema.substr(1, lexema.length()-2); return _STRING; }
{STRING2}   { lexema = yytext; lexema = lexema.substr(1, lexema.length()-2); return _STRING2; }

{ST}/"{"    { lexema = yytext; lexema = lexema.substr(1, lexema.length()-2); return _STRING2; }
"{"{ID}/"}" { lexema = yytext; return _EXPR; }

{EXPR}      { lexema = yytext; return _EXPR; }

{COMENTARIO}    { lexema = yytext; return _COMENTARIO; }

{ID}    { lexema = yytext; return _ID; }

.       { lexema = yytext; return *yytext; }

%%