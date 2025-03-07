%{
#include <string.h>
#include "util.h"
#include "tokens.h"
#include "errormsg.h"
#include <stdlib.h>

int charPos = 1;

int yywrap(void)
{
    charPos=1;
    return 1;
}

void adjust(void)
{
    EM_tokPos = charPos;
    charPos += yyleng;
}
%}

%%

" "            { adjust(); /* skip spaces */ continue; }
\n             { adjust(); EM_newline(); continue; }
","            { adjust(); return COMMA; }

for            { adjust(); return FOR; }
function       { adjust(); return FUNCTION; }
to             { adjust(); return TO; }
if             { adjust(); return IF; }
then           { adjust(); return THEN; }
else           { adjust(); return ELSE; }
while          { adjust(); return WHILE; }
do             { adjust(); return DO; }
let            { adjust(); return LET; }
in             { adjust(); return IN; }
end            { adjust(); return END; }
of             { adjust(); return OF; }
break          { adjust(); return BREAK; }
nil            { adjust(); return NIL; }
var            { adjust(); return VAR; }
type           { adjust(); return TYPE; }
array          { adjust(); return ARRAY; }
and|"&"            { adjust(); return AND; }
or|"|"             { adjust(); return OR; }

[0-9]+         { adjust(); yylval.ival = atoi(yytext); return INT; }

"("            { adjust(); return LPAREN; }
")"            { adjust(); return RPAREN; }
"["            { adjust(); return LBRACK; }
"]"            { adjust(); return RBRACK; }
"{"            { adjust(); return LBRACE; }
"}"            { adjust(); return RBRACE; }
":="           { adjust(); return ASSIGN; }
":"            { adjust(); return COLON; }
";"            { adjust(); return SEMICOLON; }
"."            { adjust(); return DOT; }
"+"            { adjust(); return PLUS; }
"-"            { adjust(); return MINUS; }
"*"            { adjust(); return TIMES; }
"/"            { adjust(); return DIVIDE; }

"="            { adjust(); return EQ; }
"!="           { adjust(); return NEQ; }
"<="           { adjust(); return LE; }
"<"            { adjust(); return LT; }
">="           { adjust(); return GE; }
">"            { adjust(); return GT; }

[a-zA-Z][a-zA-Z0-9]*  { adjust(); yylval.sval = strdup(yytext); return ID; }
\"([^\\\"\n]|(\\(.|\n)))*\"         { adjust(); yylval.sval = String(yytext); return STRING; }
"/*"([^*]|\*+[^*/])*\*+"/"  { adjust(); yylval.sval = String(yytext); return STRING; }

.              { adjust(); EM_error(EM_tokPos, "illegal token"); }

%%
