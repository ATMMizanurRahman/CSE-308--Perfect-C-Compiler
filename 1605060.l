%option noyywrap

%{

#include<bits/stdc++.h>


using namespace std;
static int z;
int totalLine=1;
int totalError=0;

FILE *logout;
FILE *tokenout;


class SymbolInfo{

private:
    string symbolName;
    string symbolType;

public:
    int thisisID; //eta tabid
    string idType;
    string variableType;
    string funcType;
    string funcReturnType;
    string IntType;
    string floatType;
    string voidType; 
    string code; //eta code
    string anotherCode; //eta Ccode
    string forLabel; // eta retlabel
    bool funcIsDefined;
    bool varIsDefined;
    bool idIsDefined;
    SymbolInfo *nextPointer;
    vector<string> listOfparameters;
    vector<string> listOfId;
    vector<string> listOfVar;
    SymbolInfo(){};
    void setType(string symbolType){
    this->symbolType=symbolType;
    }
    string getType(){
     return symbolType;
    }
    void setName(string symbolName){
     this->symbolName=symbolName;
    }
    string getName(){
     return symbolName;
    }


};




#define YYSTYPE SymbolInfo*

#include "y.tab.h"

extern YYSTYPE yylval;


%}

WHITESPACE [ \t\r\f\v]+
NEWLINE [\n]
DIGIT [0-9]
INTEGER {DIGIT}+
LETTER [A-Za-z]
CHAR '[A-Za-z0-9]'
FLOAT {DIGIT}*([.]{DIGIT}+)?(E[+-]?[0-9]+)?
f {DIGIT}+[.]
f2 {DIGIT}+(E[+-]?[0-9]+)?  
LETTERDIGIT [A-Za-z0-9]
MULTICHARERRORLETTERDIGIT [A-Za-z0-9 ]
UNFINISHEDCHARERRORLETTERDIGIT '[A-Za-z0-9 ]* 
IDENTIFIER [A-Za-z_]([A-Za-z0-9_])*
NOTIDENTIFIER [0-9]([A-Za-z0-9_])* 
SINGLELINECOMMENTA "//"(.*)*
SINGLELINECOMMENTB "//"(.*\\\n.*)*
MULTILINECOMMENT "/*"("*"[^"/"]|[^*])*"*/"
UNFINISHEDCOMMENT "/*"("*"[^"/"]|[^*])*[^"*/"]
STRING \"([^\"\n]|(\\[\n])|(\"))*\"
UNFINISHEDSTRING \"([^\"\n]|(\\[\n]))* 
CONST_CHAR "\'([A-Za-z0-9] | [\a | \t | \r | \f | \b | \v | \n | \0 | \"" | \\]\'"
UNFINISHED_CHAR "\'([A-Za-z0-9] | [\a | \t | \r | \f | \b | \v | \n | \0 | \"" | \\]" | 


C_CHAR '(\\a|\\''|\\n|\\v|\\r|\\f|\\b|\\0|\\\\|\\t|.)'

MULTICHARERRORLETTERDIGIT1 (\\a|\\''|\\n|\\v|\\r|\\f|\\b|\\0|\\\\|\\t|.)  





%%
{NEWLINE} {totalLine++;};
{WHITESPACE} {} ;//DO Nothing,Ignoring the white spaces




"if" { 
    // fprintf(tokenout,"<IF>");

     //fprintf(logout,"Line no %d : Token <IF> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("IF");
     yylval=a;

     return IF;
}




"for"  { 
    // fprintf(tokenout,"<FOR>");
    // fprintf(logout,"Line no %d : Token <FOR> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("FOR");
     yylval=a;
     return FOR;
}



"do" { 
    // fprintf(tokenout,"<DO>");
    // fprintf(logout,"Line no %d : Token <DO> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("DO");
     yylval=a;
     return DO;
}

"int" { 
    // fprintf(tokenout,"<INT>");
     //fprintf(logout,"Line no %d : Token <INT> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("INT");
     yylval=a;
     return INT;
}

"float" { 
    // fprintf(tokenout,"<FLOAT>");
    // fprintf(logout,"Line no %d : Token <FLOAT> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("FLOAT");
     yylval=a;
     return FLOAT;
}

"void" { 
     //fprintf(tokenout,"<VOID>");
    // fprintf(logout,"Line no %d : Token <VOID> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("VOID");
     yylval=a;
     return VOID;
}

"switch" { 
    // fprintf(tokenout,"<SWITCH>");
    // fprintf(logout,"Line no %d : Token <SWITCH> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("SWITCH");
     yylval=a;
     return SWITCH;
}

"default" { 
    // fprintf(tokenout,"<DEFAULT>");
    // fprintf(logout,"Line no %d : Token <DEFAULT> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("DEFAULT");
     yylval=a;
     return DEFAULT;
}

"else" { 
    // fprintf(tokenout,"<ELSE>");
    // fprintf(logout,"Line no %d : Token <ELSE> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("ELSE");
     yylval=a;
     return ELSE;
}

"while" { 
    // fprintf(tokenout,"<WHILE>");
     //fprintf(logout,"Line no %d : Token <WHILE> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("WHILE");
     yylval=a;
     return WHILE;
}

"break" { 
    // fprintf(tokenout,"<BREAK>");
     fprintf(logout,"Line no %d : Token <BREAK> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("BREAK");
     yylval=a;
     return BREAK;
}

"char" { 
    // fprintf(tokenout,"<CHAR>");
   //  fprintf(logout,"Line no %d : Token <CHAR> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("CHAR");
     yylval=a;
     return CHAR;
}

"double" { 
    // fprintf(tokenout,"<DOUBLE>");
    // fprintf(logout,"Line no %d : Token <DOUBLE> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("DOUBLE");
     yylval=a;
     return DOUBLE;
}

"return" { 
    // fprintf(tokenout,"<RETURN>");
  //   fprintf(logout,"Line no %d : Token <RETURN> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("RETURN");
     yylval=a;
     return RETURN;
}

"println" {
SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("PRINTLN");
     yylval=a;
     return PRINTLN;
}



"case" { 
  //   fprintf(tokenout,"<CASE>");
  //   fprintf(logout,"Line no %d : Token <CASE> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("CASE");
     yylval=a;
     return CASE;
}

"continue" { 
    // fprintf(tokenout,"<CONTINUE>");
   //  fprintf(logout,"Line no %d : Token <CONTINUE> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("CONTINUE");
     yylval=a;
     return CONTINUE;
}



{INTEGER} { 
    // fprintf(tokenout,"<CONST_INT,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <CONST_INT> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("CONST_INT");
     yylval=a;
     return CONST_INT;

}

{FLOAT} { 
    // fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
    // fprintf(logout,"Line no %d : Token <CONST_FLOAT> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("CONST_FLOAT");
     yylval=a;
     return CONST_FLOAT;
     
}

{f} { 
    // fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <CONST_FLOAT> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("CONST_FLOAT");
     yylval=a;
     return CONST_FLOAT;
}





'(\\)' { 
    // fprintf(logout,"Error at line no %d : Unfinished character such as %s \n",totalLine,yytext);
     totalError++;
} 

{C_CHAR} {

     string ans;
     int size=0;
     for(int i=1;yytext[i-2];i++){
     if(yytext[i]=='\\' and yytext[i+1]=='t') {
     ans[size++]='\t';
     i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='a'){
      ans[size++]='\a';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='v'){
      ans[size++]='\v';
      i++;  
}
     else if(yytext[i]=='\\' and yytext[i+1]=='r'){
      ans[size++]='\r';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='f'){
      ans[size++]='\f';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='b'){
      ans[size++]='\b';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='0'){
      ans[size++]='\0';
      i++;
}
      else if(yytext[i]=='\\' and yytext[i+1]=='n'){
      ans[size++]='\n';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='\n'){
      continue;
}
     else if(yytext[i]=='\''){
      continue; 
}
     else if(yytext[i]=='\n' and yytext[i-1]=='\\'){
      continue;
}
     else {
     ans[size++]=yytext[i];
}      

}
   
    
 
    // fprintf(tokenout,"<CHAR_CONST,%s>",ans.c_str());
   //  fprintf(logout,"Line no %d : Token <CONST_CHAR> Lexeme %s found\n",totalLine,yytext);

for(int i=0;yytext[i];i++){
 if(yytext[i] == '\n'){ 
 totalLine++;
}
}     

     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(ans);
     a->setType("CONST_CHAR");
     yylval=a;
     return CONST_CHAR;
   
}



"+" | 
"-" { 
    // fprintf(tokenout,"<ADDOP,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <ADDOP> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("ADDOP");
     yylval=a;
     return ADDOP;
} 

"*" |
"/" |
"%" { 
    // fprintf(tokenout,"<MULOP,%s>",yytext);
    /// fprintf(logout,"Line no %d : Token <MULOP> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("MULOP");
     yylval=a;
     return MULOP;
}

"++" { 
     //fprintf(tokenout,"<INCOP,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <INCOP> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("INCOP");
     yylval=a;
     return INCOP;
}

"--" {
 SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("INCOP");
     yylval=a;
     return DECOP;
}




"<"  |
"<=" |
">"  |
">=" |
"==" |
"!=" { 
    // fprintf(tokenout,"<RELOP,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <RELOP> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("RELOP");
     yylval=a;
     return RELOP;
} 

"=" { 
    // fprintf(tokenout,"<ASSIGNOP,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <ASSIGNOP> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("ASSIGNOP");
     yylval=a;
     return ASSIGNOP;
}

"&&" |
"||" { 
    // fprintf(tokenout,"<LOGICOP,%s>",yytext);
    // fprintf(logout,"Line no %d : Token <LOGICOP> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("LOGICOP");
     yylval=a;
     return LOGICOP;
}

"&"  | 
"|"  |
"^"  |
"<<" |
">>" { 
    // fprintf(tokenout,"<BITOP,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <BITOP> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("BITOP");
     yylval=a;
     return BITOP;
}

"!" { 
   //  fprintf(tokenout,"<NOT,%s>",yytext);
  //   fprintf(logout,"Line no %d : Token <NOT> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("NOT");
     yylval=a;
     return NOT;
}

"(" { 
     //fprintf(tokenout,"<LPAREN,%s>",yytext);
  //   fprintf(logout,"Line no %d : Token <LPAREN> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("LPAREN");
     yylval=a;
     return LPAREN;
}

")" { 
    // fprintf(tokenout,"<RPAREN,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <RPAREN> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("RPAREN");
     yylval=a;
     return RPAREN;
}

"{" { 
    // fprintf(tokenout,"<LCURL,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <LCURL> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("LCURL");
     yylval=a;
     return LCURL;
}

"}" { 
    // fprintf(tokenout,"<RCURL,%s>",yytext);
//     fprintf(logout,"Line no %d : Token <RCURL> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("RCURL");
     yylval=a;
     return RCURL;
}

"[" { 
   //  fprintf(tokenout,"<LTHIRD,%s>",yytext);
  //   fprintf(logout,"Line no %d : Token <LTHIRD> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("LTHIRD");
     yylval=a;
     return LTHIRD;
}

"]" { 
   //  fprintf(tokenout,"<RTHIRD,%s>",yytext);
  //   fprintf(logout,"Line no %d : Token <RTHIRD> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("RTHIRD");
     yylval=a;
     return RTHIRD;
}

"," { 
    // fprintf(tokenout,"<COMMA,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <COMMA> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("COMMA");
     yylval=a;
     return COMMA;
}

";" { 
    // fprintf(tokenout,"<SEMICOLON,%s>",yytext);
   //  fprintf(logout,"Line no %d : Token <SEMICOLON> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("SEMICOLON");
     yylval=a;
     return SEMICOLON; 
}


({DIGIT})*[.]({DIGIT})*([.]({DIGIT})*)+ { 
   //  fprintf(logout,"Error at line no %d : Too many decimal point error for character sequence like %s \n",totalLine,yytext);
     totalError++;
     
}

({DIGIT})*((E[+-]?({DIGIT})+)([.]({DIGIT})+)*) { 
   
    // fprintf(logout,"Error at line no %d : Ill formed number such as %s \n",totalLine,yytext);
     totalError++;
}

({DIGIT})+(({LETTERDIGIT})*)({LETTERDIGIT}) { 
   
   //  fprintf(logout,"Error at line no %d : Invalid Suffix on numeric constant or invalid prefix on identifier for character se-quence like %s \n",totalLine,yytext);
     totalError++;
}

'{MULTICHARERRORLETTERDIGIT}({MULTICHARERRORLETTERDIGIT})+' { 
   
   //  fprintf(logout,"Error at line no %d : Multi character constant error for character sequence like %s \n",totalLine,yytext);
     totalError++;
}


'{MULTICHARERRORLETTERDIGIT1}({MULTICHARERRORLETTERDIGIT1})+'  { 
   
     //fprintf(logout,"Error at line no %d : Multi character constant error for character sequence like %s \n",totalLine,yytext);
     totalError++;
}



'' {
   //  fprintf(logout,"Error at line no %d : Empty character constant error for character sequence like %s \n",totalLine,yytext);
     totalError++;  
}



{UNFINISHEDCHARERRORLETTERDIGIT} { 
    // fprintf(logout,"Error at line no %d : Unfinished character such as %s \n",totalLine,yytext);
     totalError++;
}



{IDENTIFIER} { 
     //fprintf(tokenout,"<ID,%s>",yytext);
    // fprintf(logout,"Line no %d : Token <ID> Lexeme %s found\n",totalLine,yytext);
     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(yytext);
     a->setType("ID");
     yylval=a;
     return ID;
}

{NOTIDENTIFIER} { 
    // fprintf(logout,"Error at line no %d : Invalid Identifier %s \n",totalLine,yytext);
     totalError++;
} 

{SINGLELINECOMMENTB} {
   //  fprintf(logout,"Line no %d : Token <COMMENT> Lexeme %s found\n",totalLine,yytext);
      for(int i=0;yytext[i];i++){
 if(yytext[i] == '\n'){ 
 totalLine++;
}
} 
}

{SINGLELINECOMMENTA} {
   //  fprintf(logout,"Line no %d : Token <COMMENT> Lexeme %s found\n",totalLine,yytext);
      for(int i=0;yytext[i];i++){
 if(yytext[i] == '\n'){ 
 totalLine++;
}
} 
}

{MULTILINECOMMENT} {
   //  fprintf(logout,"Line no %d : Token <COMMENT> Lexeme %s found\n",totalLine,yytext);
     int i;
     for(i=0;yytext[i];i++){
 if(yytext[i] == '\n'){ 
 totalLine++;
}
} 
}

{UNFINISHEDCOMMENT} {
   //  fprintf(logout,"Error at line no %d : Unfinished Comment found %s \n",totalLine,yytext);
     totalError++;
     int i;
     for(i=0;yytext[i];i++){
 if(yytext[i] == '\n'){ 
 totalLine++;
}
} 
}


{STRING}  {
     
     string ans;
     int size=0;
     for(int i=0;yytext[i-1];i++){
     if(yytext[i]=='\\' and yytext[i+1]=='t') {
     ans[size++]='\t';
     i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='a'){
      ans[size++]='\a';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='v'){
      ans[size++]='\v';
      i++;  
}
     else if(yytext[i]=='\\' and yytext[i+1]=='r'){
      ans[size++]='\r';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='f'){
      ans[size++]='\f';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='b'){
      ans[size++]='\b';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='0'){
      ans[size++]='\0';
      i++;
}
      else if(yytext[i]=='\\' and yytext[i+1]=='n'){
      ans[size++]='\n';
      i++;
}
     else if(yytext[i]=='\\' and yytext[i+1]=='\n'){
      continue;
}
     else if(yytext[i]=='\n' and yytext[i-1]=='\\'){
      continue;
}
     else {
     ans[size++]=yytext[i];
}      


}     

    // fprintf(tokenout,"<STRING,%s>",ans.c_str());
   //  fprintf(logout,"Line no %d : Token <STRING> Lexeme %s found\n",totalLine,yytext);

for(int i=0;yytext[i];i++){
 if(yytext[i] == '\n'){ 
 totalLine++;
}
} 

     SymbolInfo *a;
     a=new SymbolInfo;
     a->setName(ans);
     a->setType("STRING");
     yylval=a;
     return STRING;


}

{UNFINISHEDSTRING} {
     int i;

    // fprintf(logout,"Error at line no %d : Unfinished String found %s\n",totalLine,yytext);
     totalError++;

     
 for(i=0;yytext[i];i++){
 if(yytext[i] == '\n'){ 
 totalLine++;
}
} 
       
}


. {

    // fprintf(logout,"Error at line no %d : Unrecognized Character found %s\n",totalLine,yytext);
     totalError++;

}





%%






 


