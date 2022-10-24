D   [0-9]
L   [A-Za-z_]
ID  {L}({L}|{D})*
NUM {D}+("."{D}+)?

%%

" "     {}
"\t"    {}
"\n"    {}

"let"   { 
            yylval.v = "Erro: pegou atributo do let";
            yylval.c = "Erro: pegou atributo do let";
            return LET; 
        }
{ID}    { yylval.v = yytext; return ID; }