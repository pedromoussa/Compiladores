D       [0-9]
L       [áàa-zA-Z_]
S       [_$/*@,;!?.]

WS      [ \t\n]

INT     {D}+
NUM     {INT}("."{INT})?([Ee]("+"|"-")?{INT})?

ID      ($|{L})({L}|{D})*((@)(@|{L}|{D})+)?(({L}|{D})*)

STRING  (("\"")(({L}|{D}|{WS}|{S}|("\\")|("\'")|("\\\"")|("\"\""))*)("\""))|('(({L}|{D}|{WS}|{S}|("\\")|("\\\'")|("\"")|("\'\'"))*)')

FUNC    {ID}"("

%%

{WS}		{                       }

{STRING} 	{ return tk_string;     }
{INT}       { return tk_cte_int;    }
{NUM}   	{ return tk_cte_double; }
"print" 	{ return tk_print;      }
{FUNC}      { return tk_func;       }
{ID}		{ return tk_id;         }

.		    { return yytext[0];     }

%%