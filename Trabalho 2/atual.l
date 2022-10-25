%{

#include <stdlib.h>
#include <map>
#include <vector>
#include <string>
#include <iostream>

using namespace std;

enum TOKEN { NUM = 256, STR, ID, PRINT };

map<int,string> nome_tokens = {
	{ PRINT, "print" },
	{ STR, "string" },
	{ ID, "nome de identificador" },
	{ NUM, "número" }
};

string lexema;

void erro(string str);
void print(string str);
void casa(int);

int token;

void S();
void A();
void E();
void E_linha();
void T();
void T_linha();
void F();
void US();
void FAT();
void POW();
void Args();
void PARAMS();

%}

D  		[0-9]
L   	[A-Za-z_]
DOUBLE  {D}+("."{D}+)?
ID      {L}({L}|{D})*
STR 	\"([^\"\n]|(\\\")|\"\")+\"

%%

"\t"       { }
" "        { }
"\n"	   { }

{DOUBLE}   { lexema = yytext; return NUM; }
{STR}	   { lexema = yytext; return STR; }

"print"    { lexema = yytext; return PRINT; }

{ID}       { lexema = yytext; return ID; }

.          { lexema = yytext; return *yytext; }

%%

int next_token() {
	return yylex();
}

string nome_token(int token) {
	if(nome_tokens.find(token) != nome_tokens.end())
		return nome_tokens[token];
	else {
		string r;
		r = token;
		return r;
	}
}

void casa(int esperado) {
	if(token == esperado)
		token = next_token();
//	else {
//		cout << "Esperado '" << nome_token(esperado) << "', encontrado '" << nome_token(token) << "'" << endl;
//		exit(1);
//	}
}

void S() {
	switch(token) {
		case ID: A(); casa(';'); PARAMS(); break;
		case PRINT: casa(PRINT); E(); print("print #"); casa(';'); PARAMS(); break;
	}  
}

void A() {

	string temp = lexema; 
	// casa(ID);
	// print(temp);
	// casa('=');
	// E();
	// print("=");

	switch (token) {
		case ID: {
			casa(ID);
			print(temp);
			casa('=');
			E();
			print("=");
		}
		break;

		case PRINT: {
			casa(PRINT);
			E();
			print("print #");
		}
		break;

		default:
			return;
	}

	casa(';');
	A();

}

void E() {
	T();
	E_linha();
}

void T() {
	US();
	FAT();
	T_linha();
}

void E_linha() {
	switch(token) {
		case '+' : casa('+'); T(); print("+"); E_linha(); break;
		case '-' : casa('-'); T(); print("-"); E_linha(); break;
	}
}

	/* Unary Signs */
void US() {
	switch (token) {
		case '+' : casa('+'); T(); break;
		case '-' : print("0"); casa('-'); T(); print("-"); break;
		default  : F(); POW();
	}
}

void FAT() {
	if(token == '!') {
		casa('!');
		print("fat #");
		FAT();
	}
}

void T_linha() {
	switch(token) {
		case '*' : casa('*'); F(); print("*"); T_linha(); break;
		case '/' : casa('/'); F(); print("/"); T_linha(); break;
		case '^' : casa('^'); F(); print("^"); T_linha(); break;
	}
}

	/* Potencia */
void POW() {
	if(token == '^') {
		casa('^');
		E();
		POW();
		print("^");
	}
}

void PARAMS() {
	switch(token) {
		case ')' : break;
		case ',' : { casa(','); PARAMS(); } break;
		default: E(); PARAMS();
	}
}

void F() {
 	switch(token) {
 		case ID : {
 			string temp = lexema;
 			casa(ID);

 			if(token == '(') {
 				casa('(');
 				Args(); 
 				casa(')');
 				print(temp + " #"); 	  
 			}
 			else
 				print(temp + " @");
 			}
 			break;
 		case NUM : {
 			string temp = lexema;
 			casa(NUM); print(temp);
			if(token == '!')
				FAT();
 			}
 			break;
 		 case STR : {
 		 	string temp = lexema;
 		 	casa(STR); print(temp); 
 		 	}
 		 	break;
 		case '(': 
 			casa('('); E(); casa(')'); break;
 		case '-': 
 			US();
 			break;
 		// case '+':
 		// 	F();
 		// 	break;
		 
 		default:
 			exit(1);
 	}
}

void Args() {
	if(token != ')') {
		E();
		while(token == ',') {
			casa(',');
			E();
		}
	}
}

void erro(string str) {
	cout << "=== Erro: " << str << " ===" << endl;
	exit(1);
}

void print(string str) {
	cout << str << " ";
}

int main() {
	token = next_token();
	S();
	
	cout << endl;
	
	if(token != 0)
		cout << "Caracteres encontrados após o final do programa" << endl;
	
	return 0;
}

