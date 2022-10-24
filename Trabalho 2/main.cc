#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <string>
#include <map>

using namespace std;

int token;

void A();
void E();
void E_linha();
void T();
void T_linha();
void F();
void SU();
void P();
void FAT();
void EXP();
void casa(int);

void erro(string str);
void print(string str);

enum { tk_cte_int = 256, tk_cte_double, tk_id, tk_print, tk_string, tk_func };

extern "C" int yylex();  
extern "C" FILE *yyin;

void yyerror(const char* s);  

#include "lex.yy.c"

auto p = &yyunput;

int next_token() {
	return yylex();
}

void A() {

	string temp = yytext; 

	switch(token) {
		case tk_id : {
			casa(tk_id);
			print(temp);
			casa('=');
			E();
			print("="); 
			}
			break;

		case tk_print : {
			casa(tk_print);
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

void E_linha() {

	switch( token ) {
		case '+' : casa('+'); 
			T(); 
			print("+"); 
			E_linha(); 
			break;

		case '-' : casa('-'); 
			T(); 
			print("-"); 
			E_linha(); 
			break;
	}

}

void T() {

	SU();
	FAT();
	T_linha();

}

void T_linha() {

	switch(token) {
		case '*' : 
			casa('*'); 
			F(); 
			print("*"); 
			T_linha(); 
			break;

		case '/' : 
			casa('/'); 
			F(); 
			print("/"); 
			T_linha(); 
			break;

		case '^' : 
			casa('^'); 
			F();
			print("^"); 
			T_linha(); 
			break;
	}

}

	/* Sinais Unarios */
void SU() {
	switch ( token ) {
		case '+': casa('+'); T(); break;
		case '-': print("0"); casa('-'); T(); print("-"); break;
		default: F(); EXP();
	}
}

	/* Exponenciacao */
void EXP() {

	if(token == '^') {
		casa('^');
		E();
		EXP();
		print("^");
	}

}

	/* Fatorial */
void FAT() {

	if(token == '!') {
		casa('!'); 
		print("fat #");
		FAT();
	}

}

	/* Parametros */
void P() {

	switch (token) {
		case ')' : 
			break;

		case ',' : {
			casa(',');
			P(); 
			}
			break;

		default : 
			E();
			P();
	}

}

void F() {

	switch(token) {

		case tk_id : {
			string temp = yytext;
			casa(tk_id);
			print(temp + " @"); 
			if(token == '^')
				T_linha();
			} 
			break;

		case tk_cte_int: {
			string temp = yytext;
			casa(tk_cte_int); 
			print(temp); 
			if(token == '!')
				FAT();
			}
			break;

		case tk_cte_double : {
			string temp = yytext;
			casa(tk_cte_double); 
			print(temp);
			}
			break;

		case tk_string : {
			string temp = yytext;
			casa(tk_string);
			print(temp); 
			}
			break;

		case tk_func : {
			string temp = yytext;
			casa(tk_func);
			temp.erase(temp.size() - 1);
			P();
			casa(')');
			print(temp + " #"); 
			}
			break;

		case '-' : {
			SU(); 
			}
			break;

		case '(' : 
			casa('('); E(); casa(')');
			break;

		default:
			string temp = yytext;
			erro("Operando esperado, encontrado " + temp);
	}

}


void casa(int esperado) {

	if(token == esperado)
		token = next_token();

	else {
		printf("Esperado %d, encontrado: %d\n", esperado, token);
		exit(1);
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
	A();
	
	return 0;

}