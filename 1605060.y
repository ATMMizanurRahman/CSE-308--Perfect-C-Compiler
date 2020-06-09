

%{
#include<bits/stdc++.h>

using namespace std;
ofstream outputFile,assemblyOutput; 


class SymbolInfo{

private:
    string symbolName;
    string symbolType;

public:
    int thisisID; 
    string idType;
    string variableType;
    string funcType;
    string funcReturnType;
    string IntType;
    string floatType;
    string voidType; 
    string code; 
    string assemblyCode; 
    string forLabel; 
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




extern int totalLine, totalError;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
FILE *fp;

class ScopeTable{
  private:
      SymbolInfo **table;
      int noOfTable;
      int size;

  public:
    ScopeTable *parentTable;

    ScopeTable(int noOfTable,int size){
     this->size=size;
     this->noOfTable=noOfTable;
     table=new SymbolInfo*[size];
     for(int i=0;i<size;i++){
        table[i]=NULL;
     }
      //outputFile << "\n A Scope table of No : "<<noOfTable<<" is Created "<<endl;
    
    }

      int Hash(string name){


      int var1=224205;
      int var2=44577;
      int var3=4561;
      int var4=81218;
      int modSize=77845;
      int ans=0;
      for(int i=0;i<name.length();i++){
        ans=ans+name[i];
      }
      return ((var1+var2*ans+var3*ans^2+var3*ans^3)%modSize)%size;



      }

    

       SymbolInfo* lookup(string symbolName){
        int posOfChain=0;
        int hashPos;
        hashPos=Hash(symbolName);
        SymbolInfo *currentPointer;
        currentPointer=new SymbolInfo;
        currentPointer=table[hashPos];
        while(currentPointer!=NULL){
            if(currentPointer->getName()==symbolName){
       // cout << "<" <<symbolName << "," << currentPointer->getType() << "> found in scopetable no = " << noOfTable <<" at pos "<<hashPos<<" , "<<posOfChain<< endl;
        return currentPointer;
      }
      currentPointer=currentPointer->nextPointer;
        }
      //  cout << "Not Found"<<endl;
        return currentPointer;
    }


    bool insert(string symbolName,string symbolType){
      int posOfChain=0;
      int hashPos;
      hashPos=Hash(symbolName);
      SymbolInfo *prevPointer;
      SymbolInfo *currentPointer=table[hashPos];

      SymbolInfo *newSymbol;
      newSymbol=new SymbolInfo;
      newSymbol->setName(symbolName);
      newSymbol->setType(symbolType);
      newSymbol->nextPointer=NULL;


      if(currentPointer!=NULL){
        prevPointer=NULL;
        while(currentPointer!=NULL){
            if(currentPointer->getName()==symbolName){
               // cout << "<" <<symbolName << "," << symbolType << "> Exists" <<endl;
                return false;
            }
            posOfChain++;
            prevPointer=currentPointer;
            currentPointer=currentPointer->nextPointer;
        }
        prevPointer->nextPointer=newSymbol;
      }
      else{
        table[hashPos]=newSymbol;
      }
    //  cout << "<" <<symbolName << "," << symbolType << "> has been inserted into the Scopetable No: " <<noOfTable <<" at position "<< hashPos<<" , "<<posOfChain<<endl;
      return true;
    }



 bool deleteTable(string symbolName){
      lookup(symbolName);
      int posOfChain=0;
      int hashPos;
      hashPos=Hash(symbolName);
      SymbolInfo *prevPointer;
      SymbolInfo *currentPointer;
      currentPointer=table[hashPos];
      prevPointer=NULL;
      while(currentPointer!=NULL){
        if(currentPointer->getName()==symbolName){
            if(prevPointer!=NULL){
                prevPointer->nextPointer=currentPointer->nextPointer;
            }
            else{
                table[hashPos]=currentPointer->nextPointer;
            }
            delete currentPointer;
           // cout << "Deleted Scopetable No : "<<noOfTable<<" at pos " << hashPos << " , "<<posOfChain<<endl;
            return true;
        }
        posOfChain++;
        prevPointer=currentPointer;
        currentPointer=currentPointer->nextPointer;
      }
      return false;
    }



    void printAllInfo(){
      bool flag;
      SymbolInfo *currentPointer;
       //outputFile << "\n ScopeTable # "<<noOfTable<<endl;
//      fprintf(logout,"ScopeTable # %d\n",noOfTable);
      for(int i=0;i<size;i++){
       
        currentPointer=table[i];
        if(currentPointer==NULL){
        flag=false;
}
        else{
          //outputFile <<endl << i<<" -->: ";
        // fprintf(logout,"%d -->: ",i);
         flag=true; 
}
        while(currentPointer!=NULL){
             //outputFile << " <" << currentPointer->getName()<<" , "<<currentPointer->getType()<< "> ";
          //  fprintf(logout,"< %s, %s > ",currentPointer->getName().c_str(),currentPointer->getType().c_str());
            currentPointer=currentPointer->nextPointer;
        }
         if(flag){
       //  cout << endl; 
         //fprintf(logout,"\n");       
}          
      }
    }

      ~ScopeTable(){
         SymbolInfo *currentPointer,*prevPointer;
         for(int i=0;i<size;i++){
            currentPointer=table[i];
            while(currentPointer!=NULL){
                prevPointer=currentPointer;
                currentPointer=currentPointer->nextPointer;
                delete currentPointer;
            }
         }
            //outputFile << "\n ScopeTable NO : "<<noOfTable<<" is deleted" <<endl;
            delete []table;

     }
};

class SymbolTable{
  private:
     ScopeTable *currentPosOfScope;
     int scopeTableNo;
     int size;
  public:
    SymbolTable(int size){
     currentPosOfScope=NULL;
     scopeTableNo=0;
     this->size=size;
     scopeTableNo++;
     ScopeTable *newScopeTable;
     newScopeTable=new ScopeTable(scopeTableNo,size);
     newScopeTable->parentTable=currentPosOfScope;
     currentPosOfScope=newScopeTable;
    }

    void enterIntoScope(){
     scopeTableNo++;
     ScopeTable *newScopeTable;
     newScopeTable=new ScopeTable(scopeTableNo,size);
     newScopeTable->parentTable=currentPosOfScope;
     currentPosOfScope=newScopeTable;
    }

    void exitFromScope(){
    if(scopeTableNo>0){
    ScopeTable *prevPointer;
    prevPointer=currentPosOfScope;
    currentPosOfScope=currentPosOfScope->parentTable;
    scopeTableNo--;
    delete prevPointer;
}
    }

      SymbolInfo* lookUp(string symbolName){
      ScopeTable *currentPointer=currentPosOfScope;
      SymbolInfo *ans=NULL;
      while(currentPointer!=NULL){
        ans=currentPointer->lookup(symbolName);
        if(ans==NULL){
           currentPointer=currentPointer->parentTable;
        }
        else{
            return ans;
        }
      }
      return ans;
    }




 SymbolInfo* currentLookUp(string symbolName){
      ScopeTable *currentPointer=currentPosOfScope;
      SymbolInfo *ans=NULL;
      
        ans=currentPointer->lookup(symbolName);
        
      
      return ans;
    }

  
    bool insert(string symbolName,string symbolType){
     if(currentPosOfScope==NULL){
        return false;
     }
     if(currentPosOfScope->insert(symbolName,symbolType)==true){
        return true;
     }
     else{
        return false;
     }
    }


      bool remove(string symbolName){
     if(currentPosOfScope==NULL){
        return false;
     }
     if(currentPosOfScope->deleteTable(symbolName)==true){
        return true;
     }
     else{
        return false;
     }
    }


  
    void printCurrentScope(){
     if (currentPosOfScope==NULL){
        cout << "No Scope Table is created"<<endl;
     }
     else{
         currentPosOfScope->printAllInfo();
     }
    }


      void printAllScope(){
     ScopeTable *currentPointer=currentPosOfScope;
     if(currentPointer==NULL){
        cout << "No Scope Table is Found "<<endl;
     }
     while(currentPointer!=NULL){
        currentPointer->printAllInfo();
        currentPointer=currentPointer->parentTable;
     }
    }


       ~SymbolTable(){
     ScopeTable *prevPointer=NULL;
     while(currentPosOfScope!=NULL){
        prevPointer=currentPosOfScope;
        currentPosOfScope=currentPosOfScope->parentTable;
        delete prevPointer;
     }
    }

};




SymbolTable s(10);

vector<string>listOfParam;
vector<string>op;
int forOp=0;
vector<string>opp;
int forOpp=0;
int forOppp=0;
int forFuncName=0;
int argumen_no=0;
int totalParaNumber=0;
vector<SymbolInfo> SymbolInfoList;
string checkVarLast; 
string forAssemblyVariables=""; 
string forReturn; 
string sunnyreturn="";
int totalErrors=0;
int totalWarnings=0;
int labelCount=0;
int tempCount=0;

void yyerror(const char *s){

}


char *newLabel()
{
	char *lb= new char[4];
	strcpy(lb,"L");
	char b[3];
	sprintf(b,"%d", labelCount);
	labelCount++;
	strcat(lb,b);
	return lb;
}

char *newTemp()
{
	char *t= new char[4];
	strcpy(t,"t");
	char b[3];
	sprintf(b,"%d", tempCount);
	tempCount++;
	strcat(t,b);
	return t;
}



/*
SymbolTable *table;


void yyerror(char *s)
{
	//write your code
}

*/

%}


%token IF FOR DO INT FLOAT VOID SWITCH DEFAULT  WHILE BREAK CHAR DOUBLE RETURN CASE PRINTLN CONTINUE CONST_INT CONST_CHAR CONST_FLOAT ADDOP 
%token MULOP INCOP RELOP ASSIGNOP LOGICOP BITOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD ID SEMICOLON COMMA  DECOP STRING

%left RELOP
%left LOGICOP
%left BITOP
%left ADDOP
%left MULOP

%nonassoc DUMMY_ELSE
%nonassoc ELSE

%%

	 
 


start : program
	{
		//write your code in this block in all the similar blocks below
			$$=$1;
			assemblyOutput << ".model small" ;
			assemblyOutput << "\n";
			assemblyOutput << ".stack 100h"; 
			assemblyOutput << "\n";
			assemblyOutput << ".data"; //
			assemblyOutput << "\n";
			assemblyOutput << forAssemblyVariables << ".code\n";
			$$->code=$1->code;
			assemblyOutput << $$->code; 
			assemblyOutput << "\n";
			assemblyOutput << "OUTPUT_DEC PROC NEAR";
			assemblyOutput << "\n";
			assemblyOutput << "push ax";
			assemblyOutput << "\n";
			assemblyOutput << "push bx";
			assemblyOutput << "\n";
			assemblyOutput << "push cx";
			assemblyOutput << "\n";
			assemblyOutput << "push dx";
			assemblyOutput << "\n";
			assemblyOutput << "or ax,ax";
			assemblyOutput << "\n";
			assemblyOutput << "jge forend";
			assemblyOutput << "\n";
			assemblyOutput << "push ax";
			assemblyOutput << "\n";
			assemblyOutput << "mov dl,'-'";
			assemblyOutput << "\n";
			assemblyOutput << "mov ah,2";
			assemblyOutput << "\n";
			assemblyOutput << "int 21h";
			assemblyOutput << "\n";
			assemblyOutput << "pop ax";
			assemblyOutput << "\n";
			assemblyOutput << "neg ax";
			assemblyOutput << "\n";
			assemblyOutput << "forend:";
			assemblyOutput << "\n";
			assemblyOutput << "xor cx,cx";
			assemblyOutput << "\n";
			assemblyOutput << "mov bx,10d";
			assemblyOutput << "\n";
			assemblyOutput << "repeat:";
			assemblyOutput << "\n";
			assemblyOutput << "xor dx,dx";
			assemblyOutput << "\n";
			assemblyOutput << "div bx";
			assemblyOutput << "\n";
			assemblyOutput << "push dx";
			assemblyOutput << "\n";
			assemblyOutput << "inc cx";
			assemblyOutput << "\n";
			assemblyOutput << "or ax,ax";
			assemblyOutput << "\n";
			assemblyOutput << "jne repeat";
			assemblyOutput << "\n";
			assemblyOutput << "mov ah,2";
			assemblyOutput << "\n";
			assemblyOutput << "print_loop:";
			assemblyOutput << "\n";
			assemblyOutput << "pop dx";
			assemblyOutput << "\n";
			assemblyOutput << "or dl,30h";
			assemblyOutput << "\n";
			assemblyOutput << "int 21h";
			assemblyOutput << "\n";
			assemblyOutput << "loop print_loop";
			assemblyOutput << "\n";
			assemblyOutput << "pop dx";
			assemblyOutput << "\n";
			assemblyOutput << "pop cx";
			assemblyOutput << "\n";
			assemblyOutput << "pop bx";
			assemblyOutput << "\n";
			assemblyOutput << "pop ax";
			assemblyOutput << "\n";
			assemblyOutput << "ret";
			assemblyOutput << "\n";
			assemblyOutput << "OUTPUT_DEC ENDP";
			assemblyOutput << "\n";		
			assemblyOutput << "end main\n"; // ei jaiga 100% change lagbe
	}
	;

program : program unit{
           		//printf("Line at %d program : program unit \n\n",totalLine) ;
			//outputFile << "Line at  " << totalLine <<  " : program : program unit" << endl <<endl;
                       // $$=new SymbolInfo;
		        $$->setName($1->getName()+" "+$2->getName()+"\n");
                        string ss="";
                        ss.append($1->getName()+" "+$2->getName()+"\n");
		        //outputFile << ss.c_str() <<endl<<endl;
			string s1="";
			s1.append($1->assemblyCode+$2->assemblyCode);
			$$->assemblyCode=s1;
			$$=$1;		
			
			$$->code.append($2->code);
} 
	| unit{
           		//printf("Line at %d program :  unit \n\n",totalLine) ;
			//outputFile << "Line at  " << totalLine <<  " : program :  unit" << endl <<endl;
                        $$=new SymbolInfo;
		        $$->setName($1->getName()+"\n");
                        string ss="";
                        ss.append($1->getName()+"\n");
		        //outputFile << ss.c_str() <<endl<<endl;
			string s1="";
			s1.append($1->code);
			$$->assemblyCode=s1;
			$$->code.append($1->code);
			
} 

	;


	
unit : var_declaration{
		              //  printf("Line at %d unit : var_declaration \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " unit : var_declaration " << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str()<<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode);
				$$->assemblyCode=s1;
				$$->code.append($1->code);
                        
                        
}
     | func_declaration{
		             //   printf("Line at %d unit : func_declaration \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " unit : func_declaration" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str()<<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode);
				$$->assemblyCode=s1; 
				$$->code=$1->code; 
                             
                        
                        
}
     | func_definition{
		             //   printf("Line at %d unit : var_definition \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " unit :func_definition " << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str()<<endl<<endl;
  				string s1="";
				s1.append($1->assemblyCode);
				$$->assemblyCode=s1; 
				$$->code=$1->code;                    
                        
}
     ;


     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON{
//printf("Line at %d func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON \n\n",totalLine) ;
//outputFile << "Line at  " << totalLine <<  " : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON" << endl <<endl;

				int some=0;  
                                SymbolInfo *check;
				check=new SymbolInfo;
                                check = s.lookUp($2->getName());
                                if(check==NULL){
                                s.insert($2->getName(),"ID");
                                SymbolInfo *temp;
				temp=new SymbolInfo;
				temp = s.lookUp($2->getName());
				temp->funcType=$1->variableType;
                 		$2->funcType=$1->variableType;
 				temp->idType="TYPE_IS_FUNC";
				temp->forLabel=string(newLabel()); 
				int len;
				len=listOfParam.size();
				for(int i=0;i<len;i++){
				temp->listOfparameters.push_back(listOfParam[i]);
}
 				listOfParam.clear();
				  
}
				//listOfparameters.clear(); //

				else if(some==-2){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				else if(some==-3){
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				//This is for error checking parameters match
}


                                else{
 				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Multiple declaration of : " << $2->getName().c_str()<<endl;
				totalErrors++;
}

		                $$=new SymbolInfo;
		                $$->setName($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName());
                                string ss="";
                                ss.append($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName());
		                //outputFile << ss.c_str()<<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode+$2->getName()+$3->getName()+$4->assemblyCode+$5->getName()+$6->getName());
				$$->assemblyCode=s1;
				
				
   				     	                        
                        
                        
}
		| type_specifier ID LPAREN RPAREN SEMICOLON{
//printf("Line at %d func_declaration : type_specifier ID LPAREN  RPAREN SEMICOLON \n\n",totalLine) ;
//outputFile << "Line at  " << totalLine <<  " : type_specifier ID LPAREN  RPAREN SEMICOLON" << endl <<endl;
  // Ekhane thik uporer error check kora lagte pare..but, seikhane for loop ta hbe kina sure na 

				int some=0;
				 SymbolInfo *check;
				check=new SymbolInfo;
                                check = s.lookUp($2->getName());
                                if(check==NULL){
                                s.insert($2->getName(),"ID");
                                SymbolInfo *temp;
				temp=new SymbolInfo;
				temp = s.lookUp($2->getName());
				temp->funcType=$1->variableType;
                 		$2->funcType=$1->variableType;
 				temp->idType="TYPE_IS_FUNC";
				temp->forLabel=string(newLabel());
				int len;
				len=listOfParam.size();
				for(int i=0;i<len;i++){
         			//cout << len;
				//listOfParam[i]
}

				for(int i=0;i<len;i++){
				temp->listOfparameters.push_back(listOfParam[i]);
}
 				listOfParam.clear();
				  
}

				//listOfparameters.clear(); //

				
				else if(some==-2){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				else if(some==-3){
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				//This is for error checking parameters match
}





                                else{
 				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Multiple declaration of : " << $2->getName().c_str()<<endl;
				totalErrors++;
}

		                $$=new SymbolInfo;
		                $$->setName($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName());
                                string ss="";
                                ss.append($1->getName()+" "+$2->getName()+$3->getName()+$4->getName()+$5->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode+$2->getName()+$3->getName()+$4->getName()+$5->getName());
				$$->assemblyCode=s1; 
				
                        
                        
}

		; 
  //Ekhane last e semicolod na deor ek tyoer error o ase..eta handle kora jai chaile




		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement{
//printf("Line at %d func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n",totalLine) ;
//outputFile << "Line at  " << totalLine <<  " : type_specifier ID LPAREN parameter_list RPAREN compound_statement" << endl <<endl;

           			SymbolInfo *check;
                                check = s.lookUp($2->getName());
				int len;
				len=listOfParam.size();

				for(int i=0;i<len;i++){
         			//cout << len;
				//listOfParam[i]
}

                                if(len!=totalParaNumber){
 				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
}   				

				else if(check==NULL){
				int forCheck;
				SymbolInfo *some;
				s.insert($2->getName(),"ID");
                                SymbolInfo *temp;
				temp = s.lookUp($2->getName());
				temp->funcType=$1->variableType;
                 		$2->funcType=$1->variableType;
 				temp->idType="TYPE_IS_FUNC";
				temp->forLabel=string(newLabel()); 
				$2->forLabel=temp->forLabel;
			        forReturn=temp->forLabel;  
				int len;
				len=listOfParam.size();
				for(int i=0;i<len;i++){
				temp->listOfparameters.push_back(listOfParam[i]);
}
				totalParaNumber=0;
				temp->funcIsDefined=true;
 				listOfParam.clear();
				
}

				else if(len==-2){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				else if(len==-3){
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				//This is for error checking parameters match
}

				else{
				int forCheck;
				SymbolInfo *some;
				$2->funcType=check->funcType;
				if(check->funcIsDefined == true){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function is already defined : " << $2->getName().c_str()<<endl;
				totalErrors++;
				listOfParam.clear();
				totalParaNumber=0;
}
				else if(check->funcType!=$1->variableType){
				int forCheck;
				SymbolInfo *some;
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function return type is not matching : " << $2->getName().c_str()<<endl;
				totalErrors++;
				listOfParam.clear();
				totalParaNumber=0;
	
}

                                
				else if(len==-2){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				
				else if(check->listOfparameters.size()!=len){
				int forCheck;
				SymbolInfo *some;
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				totalErrors++;
				listOfParam.clear();
				totalParaNumber=0;
}

				else if(len==-3){
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				//This is for error checking parameters match
}

				else{
				int forCheck;
				SymbolInfo *some;
				int len1=check->listOfparameters.size();
				for(int i=0;i<len1;i++){
 				if(check->listOfparameters[i]!=listOfParam[i]){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				totalErrors++;
				listOfParam.clear();
				totalParaNumber=0;
				break;
}
}
}
				
}
				  



		                $$=new SymbolInfo;
			//	assemblyOutput << $2->getName() << "jlaskd"; ////
				forAssemblyVariables.append($2->getName()+"_return");  ////
				forAssemblyVariables.append(" dw ? \n"); 
				opp.push_back($2->getName());
		                $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName()); ////
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName());
		                //outputFile << ss.c_str()<<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode+$2->getName()+$3->getName()+$4->assemblyCode+$5->getName()+$6->assemblyCode);
                        	$$->assemblyCode=s1;

   				$$->setName($2->getName());
				$$->setType("ID");
				SymbolInfo *t;
				t=s.lookUp($2->getName());
				//for programme
				$$->code=$2->getName();
				
				$$->code.append(" proc\n");
				

                          	                 
				if($2->getName()=="main"){
				$$->code.append("mov ax,@data\n");
				$$->code.append("mov ds,ax\n");
				$$->code.append($6->code);
				$$->code.append("LReturn");
				$$->code.append($2->getName());
				$$->code.append(": \nmov ah,4ch\n");
				$$->code.append("int 21h\n");

}

				else{
				$$->code.append("push ax\n");	
				$$->code.append("push bx\n");	
				$$->code.append("push cx\n");	
				$$->code.append("push dx\n");
				for(int i=0;i<op.size();i++){
				$$->code.append("push ");
				$$->code.append(op[i]);
				$$->code.append("\n");
}
				$$->code.append($6->code);
				$$->code.append("mov ")	;
				$$->code.append($2->getName());
				$$->code.append("_return , dx\n");
				$$->code.append("LReturn");
				$$->code.append($2->getName());
				$$->code.append(": \n");								
}                               for(int i=op.size()-1;i>=0;i--){
				$$->code.append("pop ");
				$$->code.append(op[i]);
				$$->code.append("\n");
}
				$$->code.append("pop dx\n");	
				$$->code.append("pop cx\n");	
				$$->code.append("pop bx\n");	
				$$->code.append("pop ax\n");
				$$->code.append("ret\n");


				$$->code.append($2->getName()+"  "+"ENDP \n");
                        
}


		| type_specifier ID LPAREN RPAREN compound_statement{
//printf("Line at %d func_definition : type_specifier ID LPAREN  RPAREN compound_statement\n\n",totalLine) ;
//outputFile << "Line at  " << totalLine <<  " : type_specifier ID LPAREN  RPAREN compound_statement" << endl <<endl;

// Ekhane thik uporer error check kora lagte pare..but, seikhane for loop ta hbe kina sure na 


				
				SymbolInfo *check;
                                check = s.lookUp($2->getName());
				int len;
				len=listOfParam.size();

				for(int i=0;i<len;i++){
         			//cout << len;
				//listOfParam[i]
}


                                if(len!=totalParaNumber){
 				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
}   				

				else if(check==NULL){
				s.insert($2->getName(),"ID");
                                SymbolInfo *temp;
				temp = s.lookUp($2->getName());
				int forCheck;
				SymbolInfo *some;
				temp->funcType=$1->variableType;
                 		$2->funcType=$1->variableType;
 				temp->idType="TYPE_IS_FUNC";
				int len;
				len=listOfParam.size();
				for(int i=0;i<len;i++){
				temp->listOfparameters.push_back(listOfParam[i]);
}
				temp->funcIsDefined=true;
 				listOfParam.clear();
				totalParaNumber=0;
}


				else if(len==-2){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				else if(len==-3){
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				//This is for error checking parameters match
}

				else{
				$2->funcType=check->funcType;
				int forCheck;
				SymbolInfo *some;
				if(check->funcIsDefined == true){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function is already defined : " << $2->getName().c_str()<<endl;
				totalErrors++;
				listOfParam.clear();
				totalParaNumber=0;
}


				else if(len==-2){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				
				else if(check->funcType!=$1->variableType){
				int forCheck;
				SymbolInfo *some;
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function return type is not matching : " << $2->getName().c_str()<<endl;
				totalErrors++;
				listOfParam.clear();
				totalParaNumber=0;
	
}

				else if(len==-2){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

									

				else if(check->listOfparameters.size()!=len){
				int forCheck;
				SymbolInfo *some;
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				totalErrors++;
				listOfParam.clear();
				totalParaNumber=0;
}


				else if(len==-2){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				else if(len==-3){
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				//This is for error checking parameters match
}				

				else{
				int forCheck;
				SymbolInfo *some;
				int len1=check->listOfparameters.size();
				for(int i=0;i<len1;i++){
 				if(check->listOfparameters[i]!=listOfParam[i]){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				totalErrors++;
				listOfParam.clear();
				totalParaNumber=0;
				break;
}
}
}
				
}
				  



		                $$=new SymbolInfo;
				//assemblyOutput << $2->getName() << "jlaskd";
				forAssemblyVariables.append($2->getName()+"_return");
				forAssemblyVariables.append(" dw ? \n"); 
		                $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName());
		                //outputFile << ss.c_str()<<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode+$2->getName()+$3->getName()+$4->getName()+$5->assemblyCode);
                        	$$->assemblyCode=s1;

   				$$->setName($2->getName());
				$$->setType("ID");
				SymbolInfo *t;
				t=s.lookUp($2->getName());
				//for programme
				$$->code=$2->getName();
				$$->code.append(" proc\n");
				//sunnyreturn=$2->getName();

				if($2->getName()=="main"){
				$$->code.append("mov ax,@data\n");
				$$->code.append("mov ds,ax\n");
				$$->code.append($5->code);
				$$->code.append("LReturn");
				$$->code.append($2->getName());
				$$->code.append(": \nmov ah,4ch\n");
				$$->code.append("int 21h\n");

}

				else{
				$$->code.append("push ax\n");	
				$$->code.append("push bx\n");	
				$$->code.append("push cx\n");	
				$$->code.append("push dx\n");
				for(int i=0;i<op.size();i++){
				$$->code.append("push ");
				$$->code.append(op[i]);
				$$->code.append("\n");
}
				$$->code.append($5->code);
				$$->code.append("LReturn");
				$$->code.append($2->getName());
				$$->code.append(": \n");								
                               for(int i=op.size()-1;i>=0;i--){
				$$->code.append("pop        ");
				$$->code.append(op[i]);
				$$->code.append("\n");
}
				$$->code.append("pop ax\n");	
				$$->code.append("pop bx\n");	
				$$->code.append("pop cx\n");	
				$$->code.append("pop dx\n");
}

				$$->code.append($2->getName()+"  " +" ENDP \n");
}

				//assemblyOutput << $$->code;
							                     

 		;

				


parameter_list  : parameter_list COMMA type_specifier ID{
		                //printf("Line at %d parameter_list  : parameter_list COMMA type_specifier ID \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : parameter_list COMMA type_specifier ID" << endl <<endl;

				
                                
				
				listOfParam.push_back(checkVarLast);

				 if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

			        
				
				$4->idType="TYPE_IS_VAR";
				$4->variableType=checkVarLast;
				totalParaNumber++;

				if(totalParaNumber==-1){
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				//This is for error checking parameters match
}


				SymbolInfo *check;
				check=new SymbolInfo;
				check->setName($4->getName());
				check->setType($4->getType());

				if(totalParaNumber==-1){
				outputFile << "Function parameters Doesn't match : " << $2->getName().c_str()<<endl;
				//This is for error checking parameters match
}


				check->idType="TYPE_IS_VAR";
				SymbolInfoList.push_back(*check);

		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName());
		                //outputFile << ss.c_str()<<endl<<endl;
                        	string s1="";
				s1.append($1->assemblyCode+$2->getName()+$3->assemblyCode+$4->getName());
                        	$$->assemblyCode=s1;
                        
}
		| parameter_list COMMA type_specifier{
		                //printf("Line at %d parameter_list  : parameter_list COMMA type_specifier  \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : parameter_list COMMA type_specifier" << endl <<endl;
				
				listOfParam.push_back($3->variableType);					

		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName()+$3->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode+$2->getName()+$3->assemblyCode);
                        	$$->assemblyCode=s1;
                        
                        
}
 		| type_specifier ID{
		                //printf("Line at %d parameter_list  : type_specifier ID \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : type_specifier ID" << endl <<endl;

				listOfParam.push_back(checkVarLast);
				
				$2->idType="TYPE_IS_VAR";
				$2->variableType=checkVarLast;

				 if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}


				SymbolInfoList.push_back(*$2);
				totalParaNumber++;

                                
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode+$2->getName());
                        	$$->assemblyCode=s1;
                        
                        
}
		| type_specifier{
		                //printf("Line at %d parameter_list  : type_specifier  \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : type_specifier  " << endl <<endl;
				listOfParam.push_back(checkVarLast);
		                $$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
 				string s1="";
				s1.append($1->assemblyCode);
                        	$$->assemblyCode=s1;                       
                        
}
 		;



 		
compound_statement : LCURL{
			
			s.enterIntoScope();
			int size;
			size=SymbolInfoList.size();
			for(int i=0;i<size;i++){
			s.insert(SymbolInfoList[i].getName(),SymbolInfoList[i].getType());
			SymbolInfo *check;
			if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}
			check=s.lookUp(SymbolInfoList[i].getName());
			check->idType=SymbolInfoList[i].idType;
			check->variableType=SymbolInfoList[i].variableType;
			SymbolInfo *t;//
			t=s.lookUp(SymbolInfoList[i].getName());//
			//t->thisisID++;
			forAssemblyVariables.append(t->getName()+to_string(t->thisisID)+" dw ?\n");//
			op.push_back(t->getName()+to_string(t->thisisID));
			
}
			SymbolInfoList.clear();				
			} statements{} RCURL{
			
			
           		//printf("Line at %d compound_statement : LCURL statements RCURL \n\n",totalLine) ;
			//outputFile << "Line at  " << totalLine <<  " : LCURL statements RCURL" << endl <<endl;
                     //   $$=new SymbolInfo;
			$$=$3;
		        $$->setName("\n"+$1->getName()+"\n"+$3->assemblyCode+$5->getName()+"\n");
                        string ss="";
                        ss.append("\n"+$1->getName()+"\n"+$3->assemblyCode+$5->getName()+"\n");
		        //outputFile << ss.c_str() <<endl<<endl;
			s.printAllScope();			
			s.exitFromScope();
			string s1="";//
			s1.append("\n"+$1->getName()+"\n"+$3->assemblyCode+$5->getName()+"\n");//
			$$->assemblyCode=s1;//

}
 		    | LCURL RCURL{
			s.enterIntoScope();   
			int size;
			size=SymbolInfoList.size();
			for(int i=0;i<size;i++){
			s.insert(SymbolInfoList[i].getName(),SymbolInfoList[i].getType());
			SymbolInfo *check;
			if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}
			check=s.lookUp(SymbolInfoList[i].getName());
			check->idType=SymbolInfoList[i].idType;
			check->variableType=SymbolInfoList[i].variableType;
			
}
			SymbolInfoList.clear();

           		//printf("Line at %d compound_statement : LCURL RCURL \n\n",totalLine) ;
			//outputFile << "Line at  " << totalLine <<  " : LCURL RCURL" << endl <<endl;
                        $$=new SymbolInfo;
		        $$->setName($1->getName()+" "+$2->getName());
                        string ss="";
                        ss.append($1->getName()+" "+$2->getName());
		        //outputFile << ss.c_str() <<endl<<endl;
			s.printAllScope();
			s.exitFromScope();
			string s1="";
			s1.append($1->getName()+" "+$2->getName());
			$$->assemblyCode=s1;
}
 		    ;









 		    
var_declaration : type_specifier declaration_list SEMICOLON{
           		//printf("Line at %d var_declaration : type_specifier declaration_list SEMICOLON \n\n",totalLine) ;
			//outputFile << "Line at  " << totalLine <<  " : type_specifier declaration_list SEMICOLON" << endl <<endl;
                        $$=new SymbolInfo;
		        $$->setName($1->getName()+$2->getName()+$3->getName());
                        string ss="";
                        ss.append($1->getName()+" "+$2->getName()+$3->getName());
		        //outputFile << ss.c_str() <<endl<<endl;
			string s1="";
			s1.append($1->assemblyCode+$2->assemblyCode+$3->getName());
			$$->assemblyCode=s1;
}			
 		 ;


 		 
type_specifier	: INT { //printf("Line at %d type_specifier INT \n\n",totalLine) ;
			//outputFile << "Line at  " << totalLine <<  " : type_specifier INT " << endl <<endl;
			checkVarLast="INT";
                        SymbolInfo *temp;
			temp=new SymbolInfo;
			temp->variableType="INT";
			$$=temp;
			$$->setName($1->getName()+" ");
                        //outputFile << $$->getName().c_str()<< " " <<endl<<endl;
			string s1="";
			s1.append($1->getName()+" ");
			$$->assemblyCode=s1;
			
}
 		| FLOAT {// printf("Line at %d type_specifier FLOAT \n\n",totalLine) ;
			//outputFile << "Line at  " << totalLine <<  " : type_specifier FLOAT" << endl <<endl;
			checkVarLast="FLOAT";
                        SymbolInfo *temp;
			temp=new SymbolInfo;
			temp->variableType="FLOAT";
			$$=temp;
                        $$->setName($1->getName()+" ");
                        //outputFile << $$->getName().c_str() <<" "<<endl<<endl;
			string s1="";
			s1.append($1->getName()+" ");
			$$->assemblyCode=s1;
                        
}
 		| VOID {//printf("Line at %d type_specifier VOID \n\n",totalLine) ;
			//outputFile << "Line at  " << totalLine <<  " : type_specifier VOID" << endl <<endl;
			checkVarLast="VOID";
                        SymbolInfo *temp;
			temp=new SymbolInfo;
			temp->variableType="VOID";
			$$=temp;
                        $$->setName($1->getName()+" ");
                        //outputFile << $$->getName().c_str() <<" "<<endl<<endl;
			string s1="";
			s1.append($1->getName()+" ");
			$$->assemblyCode=s1;
                        
}
 		;




		 


 		    

 		 

 		
declaration_list : declaration_list COMMA ID{
		               // printf("Line at %d declaration_list : declaration_list COMMA ID \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : declaration_list COMMA ID" << endl <<endl;
				
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				if(checkVarLast=="VOID"){
				outputFile  << "Error at line no "<<totalLine<< endl;
				outputFile << " Variable type is void , in cannot be void : " <<endl;				
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}
				else{
				SymbolInfo *temp2;
				temp2=s.currentLookUp($3->getName());
				if(temp2==NULL){
				s.insert($3->getName(),$3->getType());
				SymbolInfo *tempo;

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}
				tempo=s.lookUp($3->getName());
				tempo->idType="TYPE_IS_VAR";
				tempo->variableType=checkVarLast;
				//tempo->thisisID++;
				forAssemblyVariables.append(tempo->getName()+to_string(tempo->thisisID) + " dw ?\n"); // 
}
				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " Multiple Declaration of variable " << $3->getName().c_str() <<endl;	
				totalErrors++;
}
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}				

		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName()+$3->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode+$2->getName()+$3->getName());
                        	$$->assemblyCode=s1;
                        
                        
}
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD{
		               // printf("Line at %d declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD " << endl <<endl;

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}
				if(checkVarLast=="VOID"){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " An Array cannot be void " << $3->getName().c_str() <<endl;
				totalErrors++;	
}

				/*if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}
*/

				else{
				SymbolInfo *temp2;
				temp2=s.currentLookUp($3->getName());
				if(temp2==NULL){
				s.insert($3->getName(),$3->getType());
				SymbolInfo *tempo;
				
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				tempo=s.lookUp($3->getName());
				tempo->idType="TYPE_IS_ARRAY";
				tempo->variableType=checkVarLast;
				//tempo->thisisID++;
		forAssemblyVariables.append(tempo->getName()+to_string(tempo->thisisID)+" dw " +$5->getName() + " dup(?)\n"); //
}
				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " Multiple Declaration of Array " << $3->getName().c_str() <<endl;
				totalErrors++;	
}
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}				

		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode+$2->getName()+$3->getName()+$4->getName()+$5->getName()+$6->getName());
                        	$$->assemblyCode=s1;				
                        
                        
}
 		  | ID{
		                //printf("Line at %d declaration_list : ID \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : declaration_list : ID " << endl <<endl;

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}
				if(checkVarLast=="VOID"){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " An Id cannot be void " << $1->getName().c_str() <<endl;
				totalErrors++;	
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				else{
				SymbolInfo *temp2;
				temp2=s.currentLookUp($1->getName());
				if(temp2==NULL){
				s.insert($1->getName(),$1->getType());
				SymbolInfo *tempo;
				
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}
				tempo=s.lookUp($1->getName());
				tempo->idType="TYPE_IS_VAR";
				tempo->variableType=checkVarLast;
				//tempo->thisisID++;
				forAssemblyVariables.append(tempo->getName()+to_string(tempo->thisisID) +" dw ?\n"); // 
}
				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " Multiple Declaration of ID " << $1->getName().c_str() <<endl;
				totalErrors++;	
}
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}				
			
		                $$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str()  <<endl<<endl;
				string s1="";//
                                s1.append($1->getName());//
                                $$->assemblyCode=s1;//
				
                        
}
 		  | ID LTHIRD CONST_INT RTHIRD{
		                //printf("Line at %d declaration_list : ID LTHIRD CONST_INT RTHIRD \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : declaration_list : ID LTHIRD CONST_INT RTHIRD" << endl <<endl;

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}

				if(checkVarLast=="VOID"){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " An Array cannot be void " << $1->getName().c_str() <<endl;
				totalErrors++;	
}

				
				else{
				SymbolInfo *temp2;
				temp2=s.currentLookUp($1->getName());
				if(temp2==NULL){
				s.insert($1->getName(),$1->getType());
				SymbolInfo *tempo;
				
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		

				tempo=s.lookUp($1->getName());
				tempo->idType="TYPE_IS_ARRAY";
				tempo->variableType=checkVarLast;
				//tempo->thisisID++;
		forAssemblyVariables.append(tempo->getName()+to_string(tempo->thisisID)+" dw " +$3->getName() + " dup(?)\n"); //
}
				//cout << "hello";
				//$$=tempo;

				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " Multiple Declaration of Array " << $1->getName().c_str() <<endl;	
				totalErrors++;
}
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName());
		                //outputFile << ss.c_str() << endl<<endl;
  				string s1="";
				s1.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+"");
                        	$$->assemblyCode=s1;                      
                        
}
 		  ;
 		  
statements : statement{
		                //printf("Line at %d statements : statement \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statements : statement" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode);
				$$->assemblyCode=s1;
				$$->code=$1->code;
                        
                        
}
	   | statements statement{
		                //printf("Line at %d statements :  statements statement \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statements :  statements statement" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
                        	string s1="";
				s1.append($1->assemblyCode+$2->assemblyCode);
				$$->assemblyCode=s1;
				$$=$1;
				$$->code.append($2->code);
                        
}
	   ;
	   
statement : var_declaration{
		                //printf("Line at %d statement : var_declaration \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statement : var_declaration" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+"\n");
                                string ss="";
                                ss.append($1->getName()+"\n");
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode);
				$$->assemblyCode=s1;
				$$->code=$1->code;
                        
                        
}
	  | expression_statement{
		                //printf("Line at %d statement : expression_statement \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statement : expression_statement" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+"\n");
                                string ss="";
                                ss.append($1->getName()+"\n");
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode);
				$$->assemblyCode=s1;
				$$->code=$1->code;
                        
                        
}
	  | compound_statement{
		                //printf("Line at %d statement : compound_statement \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statement : compound_statement" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+"\n");
                                string ss="";
                                ss.append($1->getName()+"\n");
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode);
				$$->assemblyCode=s1;
				$$->code=$1->code;
                        
                        
}
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement{
// printf("Line at %d statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement \n\n",totalLine) ;
//outputFile << "Line at  " << totalLine <<  " : statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement" << endl <<endl;
		                $$=new SymbolInfo;
                         $$->setName($1->getName()+$2->getName()+$3->getName()+" "+$4->getName()+" "+$5->getName()+$6->getName()+$7->getName());
                                string ss="";
    ss.append($1->getName()+$2->getName()+$3->getName()+" "+$4->getName()+" "+$5->getName()+$6->getName()+$7->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
			string s1="";
   s1.append($1->getName()+$2->getName()+$3->assemblyCode+" "+$4->assemblyCode+" "+$5->assemblyCode+$6->getName()+$7->assemblyCode);
	        	$$->assemblyCode=s1;
			char *loop1=newLabel();
			char *loop2=newLabel();
			
			$$=$3;
			$$->code.append((string)loop1+":\n");
			$$->code.append($4->code);
			$$->code.append("mov ax, ");
			$$->code.append($4->getName());
			$$->code.append("\n");
			$$->code.append("cmp ax,0\n");
                        $$->code.append("je ");
			$$->code.append((string)loop2);
			$$->code.append("\n");
			$$->code.append($7->code+$5->code);
//assemblyOutput << $7->code ;
                        $$->code.append("jmp ");
			$$->code.append((string)loop1);
			$$->code.append("\n");
			$$->code.append((string)loop2);
			$$->code.append(":\n");
}

	

	  | IF LPAREN expression RPAREN statement %prec  DUMMY_ELSE{
		                //printf("Line at %d statement : IF LPAREN expression RPAREN statement \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statement : IF LPAREN expression RPAREN statement" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
                                string s1="";
                                s1.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName());
		                $$->assemblyCode=s1;
				char *labelIf=newLabel();
				$$=$3;
				$$->code.append("mov ax, ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				$$->code.append("cmp ax,0 \n");
				$$->code.append("je ");
				$$->code.append((string)labelIf);
                        	$$->code.append("\n");
				$$->code.append($5->code);
				$$->code.append((string)labelIf);
                        	$$->code.append(":\n");
}
	  | IF LPAREN expression RPAREN statement ELSE statement{
		                //printf("Line at %d statement : IF LPAREN expression RPAREN statement ELSE statement \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statement : IF LPAREN expression RPAREN statement ELSE statement " << endl <<endl;
		                $$=new SymbolInfo;
		  $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+" "+$6->getName()+$7->getName());
                                string ss="";
                  ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+" "+$6->getName()+$7->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
		s1.append($1->getName()+$2->getName()+$3->assemblyCode+$4->getName()+$5->assemblyCode+" "+$6->getName()+$7->assemblyCode);
			//$$->assemblyCode=s1; maybe eta nai
			char *loop1=newLabel();
			char *loop2=newLabel();
			$$=$3;
                        $$->code.append("mov ax, ");
			$$->code.append($3->getName());
			$$->code.append("\n");
			$$->code.append("cmp ax,0 \n");
                        $$->code.append("je ");
			$$->code.append((string)loop1);
			$$->code.append("\n");
			$$->code.append($5->code);
			$$->code.append("jmp ");
			$$->code.append((string)loop2);
                        $$->code.append("\n");
			$$->code.append((string)loop1);
                        $$->code.append(":\n");
			$$->code.append($7->code);
			$$->code.append((string)loop2);
                        $$->code.append(":\n");
}
	  | WHILE LPAREN expression RPAREN statement{
		               // printf("Line at %d statement : WHILE LPAREN expression RPAREN statement  \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statement : WHILE LPAREN expression RPAREN statement " << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
                        	string s1="";
				s1.append($1->getName()+$2->getName()+$3->assemblyCode+$4->getName()+$5->assemblyCode);
				$$->assemblyCode=s1;
				char *loop1=newLabel();
				char *loop2=newLabel();
				$$=$1;
				$$->code.append((string)loop1);
				$$->code.append(":\n");
                        	$$->code.append($3->code);
				$$->code.append("mov ax, ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				$$->code.append("cmp ax,0 \n");
                        	$$->code.append("je ");
				$$->code.append((string)loop2);
				$$->code.append("\n");	
				$$->code.append($5->code);
				$$->code.append("jmp ");
				$$->code.append((string)loop1);
		                $$->code.append(":\n");	
				$$->code.append((string)loop2);
                        	$$->code.append(":\n");	
				
}



	  | PRINTLN LPAREN ID RPAREN SEMICOLON{
		                //printf("Line at %d statement : PRINTLN LPAREN ID RPAREN SEMICOLON  \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statement : PRINTLN LPAREN ID RPAREN SEMICOLON" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+"\n");
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+"\n");
		                //outputFile << ss.c_str() <<endl<<endl;
  				string s1="";
                                s1.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+$5->getName()+"\n");                      
                        	$$->assemblyCode=s1;
				$$=$1;

				$$->code.append("mov ax, ");
				$$->code.append($3->getName()+"0");
				$$->code.append("\n");
				$$->code.append("call  OUTPUT_DEC\n"); // call out_dec
}

		//eKHAENE  Semicolon er jnno ekta error deya ase		

	  | RETURN expression SEMICOLON{
		                //printf("Line at %d statement : RETURN expression SEMICOLON  \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : statement : RETURN expression SEMICOLON " << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+" "+$2->getName()+" "+$3->getName()+"\n");
                                string ss="";
                                ss.append($1->getName()+" "+$2->getName()+" "+$3->getName()+"\n");
		                //outputFile << ss.c_str() <<endl<<endl;
                        	string s1="";
                                ss.append($1->getName()+" "+$2->assemblyCode+" "+$3->getName()+"\n");
   				$$->assemblyCode=s1;
				$$->code.append("mov dx, ");
				$$->code.append($2->getName());
				$$->code.append("\n");
				
				
}



		

	  ;


	  
expression_statement 	: SEMICOLON{
		                //printf("Line at %d expression_statement 	: SEMICOLON  \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : expression_statement 	: SEMICOLON " << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
                        	string s1="";
                                s1.append($1->getName());
                        	$$->assemblyCode=s1;
}			
			| expression SEMICOLON{
		                //printf("Line at %d expression_statement 	: expression SEMICOLON  \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : expression_statement 	: expression SEMICOLON" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName()+$2->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
  				string s1="";
                                s1.append($1->getName()+$2->assemblyCode);
                        	$$->assemblyCode=s1; 
				$$->code=$1->code;                     
                        
}			
			//Semicolon er jnno ekhaner arekta
 
			;
	  
variable : ID{
		                //printf("Line at %d variable : ID \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : variable : ID" << endl <<endl;
				SymbolInfo *check;
				
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}						

				check=s.lookUp($1->getName());
				if(check!=NULL){
				if(check->idType=="TYPE_IS_VAR"){
				$$->idType=check->idType;
				$$->variableType=check->variableType;
				$$->funcType=check->funcType;
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		            
				$$->funcReturnType=check->funcReturnType;
				$$->funcIsDefined=check->funcIsDefined;
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		            
				$$->listOfparameters=check->listOfparameters;
}
				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << $1->getName().c_str() << " Is not a variable "  <<endl;
				totalErrors++;				
}
}

				

				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << $1->getName().c_str() << " This variable was not declared "  <<endl;
				totalErrors++;	
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		

				SymbolInfo *t;
				t=s.lookUp($1->getName());			
		                
		            //    $$->setName($1->getName()+" ");
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->getName());
                        	$$->assemblyCode=s1;   
                        	if($$!=0){
				//t->thisisID++;
				$$->setName($$->getName()+to_string(t->thisisID)); // why man why -_- 
}
                        
} 		
	 | ID LTHIRD expression RTHIRD{
		                //printf("Line at %d variable : ID LTHIRD expression RTHIRD \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : variable : ID LTHIRD expression RTHIRD" << endl <<endl;

				SymbolInfo *check;
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
				check=new SymbolInfo;
				check=s.lookUp($1->getName());
				//cout << check->idType << check->variableType ;
				if(check!=NULL){
				if(check->idType=="TYPE_IS_ARRAY"){
				if($3->variableType!="FLOAT"){
				$$->idType=check->idType;
				$$->variableType=check->variableType;
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
				$$->funcType=check->funcType;
				$$->funcReturnType=check->funcReturnType;
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
				$$->funcIsDefined=check->funcIsDefined;
				$$->listOfparameters=check->listOfparameters;
}
				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile  << " An array index cannot be float "  <<endl;
				totalErrors++;		
}

}

				
				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << $1->getName().c_str() << " Is not an Array "  <<endl;
				totalErrors++;				

}
				
}

				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << $1->getName().c_str() << " This Array was not declared "  <<endl;
				totalErrors++;	
}

				
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		           
		                $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName()+" ");
				SymbolInfo *t;
				t=s.lookUp($1->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName()+" ");
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->getName()+$2->getName()+$3->assemblyCode+$4->getName()+" ");
                        	$$->assemblyCode=s1;  
      				if($$!=0){
				//t->thisisID;
				$$->setName($$->getName()+to_string(t->thisisID)); // why man why -_- 
				$$->code=$3->code;
				$$->code.append("mov bx, ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				$$->code.append("add bx, bx\n");
				$$->idType="TYPE_IS_ARR";				
}                  
                        
}  
	 ;


	 
 expression : logic_expression{
		                //printf("Line at %d expression : logic_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : expression : logic_expression " << endl <<endl;
		              //  $$=new SymbolInfo;
		              //  $$->setName($1->getName());
				$$=$1;
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->assemblyCode);
                        	$$->assemblyCode=s1;
				$$->code=$1->code; 
                        
                        
}  	
	   | variable ASSIGNOP logic_expression{
		                //printf("Line at %d expression : variable ASSIGNOP logic_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : expression : variable ASSIGNOP logic_expression " << endl <<endl;
				//cout << $1->variableType << $1->idType << $3->variableType;
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		           
				if($1->variableType=="INT"){
				if($1->idType=="TYPE_IS_VAR" || $1->idType=="TYPE_IS_ARRAY"){
				if($3->variableType=="FLOAT"){
				outputFile << "Warning At Line no "<<totalLine<< endl;
				outputFile << "Storing Float value into an integer index. Type Mismatch\n"  <<endl;
				totalWarnings++;				

}
}
}

				else if($1->variableType=="FLOAT"){
				if($1->idType=="TYPE_IS_ARRAY"){
				if($3->variableType!="INT"){
				outputFile << "Warning At Line no "<<totalLine<< endl;
				outputFile << "Stroing Float value into an integer index\n"  <<endl;
				totalWarnings++;	
}
}
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		           

		                $$=new SymbolInfo;
		                $$->setName($1->getName()); //ekhane 3 ta hoar kotha chilo..change korsi ekhane
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                              s1.append($1->assemblyCode+$2->getName()+$3->assemblyCode);
                        	$$->assemblyCode=s1; 
				$$->assemblyCode=$3->assemblyCode;
				$$->code=$3->code;
                        	$$->code.append($1->code);
                        	$$->code.append("mov ax, ");
				//assemblyOutput << "koi re vai?" << $3->getName(); 
				$$->code.append($3->getName());
				if($3->getName()==""){
				$$->code.append(opp[forFuncName]);
				$$->code.append("_return");
				forFuncName++;
}
				$$->code.append("\n");
				if($$->idType=="TYPE_IS_ARR"){
				$$->code.append("mov ");
				$$->code.append($1->getName());
				$$->code.append(" [bx] ");
				$$->code.append(", ax \n");
				
}
				else{
				$$->code.append("mov ");
				$$->code.append($1->getName());
				$$->code.append(" , ax \n");
}


}   	
	   ;


			
logic_expression : rel_expression{
		                //printf("Line at %d logic_expression : rel_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : logic_expression : rel_expression " << endl <<endl;
		                $$=$1;//$$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                 //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->assemblyCode);
                        	$$->assemblyCode=s1;
				$$->code=$1->code;
				
                        
                        
}   	 	
		 | rel_expression LOGICOP rel_expression{
		                //printf("Line at %d logic_expression : rel_expression LOGICOP rel_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : logic_expression : rel_expression LOGICOP rel_expression " << endl <<endl;
		                $$=new SymbolInfo;
				$$->variableType="INT";
				
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		            
		                $$->setName($1->getName()+$2->getName()+$3->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
    				string s1="";
                                s1.append($1->assemblyCode+$2->getName()+$3->assemblyCode);
                        	$$->assemblyCode=s1;
				char *temp1=newTemp();
				char *loop1=newLabel();
				char *loop2=newLabel();
				$$->code=$1->code;
				$$->code.append($3->code);                    
                                if($2->getName()=="||"){
				$$->code.append("mov ax , ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("cmp ax , ");
				$$->code.append("0");
				$$->code.append("\n");
				$$->code.append("jne , ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
				$$->code.append("mov ax , ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				$$->code.append("cmp ax , ");
				$$->code.append("0");
				$$->code.append("\n");
				$$->code.append("jne , ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp1);
				$$->code.append(" , 0 \n");
				$$->code.append("jmp ");
				$$->code.append((string)loop2);
				$$->code.append("\n");
				$$->code.append((string)loop1);
				$$->code.append(":");
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp1);
				$$->code.append(" , 1 \n");
				$$->code.append((string)loop2);
				$$->code.append(":");
				$$->code.append("\n");
}


				else if($2->getName()=="&&"){
				$$->code.append("mov ax , ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("cmp ax , ");
				$$->code.append("0");
				$$->code.append("\n");
				$$->code.append("jne , ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
				$$->code.append("mov ax , ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				$$->code.append("cmp ax , ");
				$$->code.append("0");
				$$->code.append("\n");
				$$->code.append("je , ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp1);
				$$->code.append(" , 1 \n");
				$$->code.append("jmp ");
				$$->code.append((string)loop2);
				$$->code.append("\n");
				$$->code.append((string)loop1);
				$$->code.append(":");
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp1);
				$$->code.append(" , 0 \n");
				$$->code.append((string)loop2);
				$$->code.append(":");
				$$->code.append("\n");
}
				
}

   	 	
		 ;
			
rel_expression	: simple_expression{
		                //printf("Line at %d rel_expression	: simple_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : rel_expression	: simple_expression" << endl <<endl;
		                $$=$1;//$$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
                        	string s1="";
                                s1.append($1->assemblyCode);
                        	$$->assemblyCode=s1;
				$$->code=$1->code;
                        
}   	 	 
		| simple_expression RELOP simple_expression{
		                //printf("Line at %d rel_expression	: simple_expression RELOP simple_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : rel_expression	: simple_expression RELOP simple_expression" << endl <<endl;
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		           
				if($1->variableType!=$3->variableType){
				outputFile << "Warning At Line no "<<totalLine<< endl;
				outputFile << "Type Mis-matched between left and right side\n"  <<endl;	
				totalWarnings++;				
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		           
		                $$=new SymbolInfo;
				$$->variableType="INT"; 
				
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
                                string s1="";
                                s1.append($1->assemblyCode+$2->getName()+$3->assemblyCode);
                        	$$->assemblyCode=s1;
				char *temp=newTemp();
				char *loop1=newLabel();
				char *loop2=newLabel();
				$$->code=$1->code;
				$$->code.append($3->code);
				$$->code.append("mov ax , ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("cmp ax , ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				
				if($2->getName()==">"){
				$$->code.append("jg ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
}
   				else if($2->getName()==">="){
				$$->code.append("jge ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
}

				else if($2->getName()=="<"){
				$$->code.append("jl ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
}
				else if($2->getName()=="<="){
				$$->code.append("jle ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
}

				else if($2->getName()=="=="){
				$$->code.append("je ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
}

				else if($2->getName()=="!="){
				$$->code.append("jne ");
				$$->code.append((string)loop1);
				$$->code.append("\n");
}
   	
   
				$$->code.append("mov ");
				$$->code.append((string)temp);
				$$->code.append(" ,0");
				$$->code.append("\n");
				$$->code.append("jmp ");
				$$->code.append((string)loop2);
				$$->code.append("\n");
   				$$->code.append((string)loop1);
   				$$->code.append(":\n");
   				$$->code.append("mov ");
                        	$$->code.append((string)temp);
				$$->code.append(" , 1");
				$$->code.append("\n");
				$$->code.append((string)loop2);
				$$->code.append(":\n");
				$$->setName((string)temp);
				forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ? ");
				forAssemblyVariables.append("\n");
				
}   	 	 	
		;


				
simple_expression : term{
		                //printf("Line at %d simple_expression : term \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : simple_expression : term "<< endl <<endl;
		                $$=$1;//$$=new SymbolInfo;
		               // $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->assemblyCode);
                        	$$->assemblyCode=s1;	
				$$->code=$1->code;
                        
                        
}   	 
		  | simple_expression ADDOP term{
		                //printf("Line at %d simple_expression : simple_expression ADDOP term \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : simple_expression : simple_expression ADDOP term" << endl <<endl;
				$$=new SymbolInfo;
				string testString;
				testString = $2->getName();
				if(testString=="+"){
				if($1->idType=="TYPE_IS_VAR" || $1->idType=="TYPE_IS_ARRAY"){
				if($3->idType=="TYPE_IS_VAR" || $3->idType=="TYPE_IS_ARRAY"){
				if($1->variableType=="INT" && $3->variableType=="INT"){
				$$->variableType="INT";
				
}
				else if($1->variableType=="FLOAT" || $3->variableType=="FLOAT"){
				$$->variableType="FLOAT";
				
}				
}
}
}

				else if(testString=="-"){

				if($1->idType=="TYPE_IS_VAR" || $1->idType=="TYPE_IS_ARRAY"){
				if($3->idType=="TYPE_IS_VAR" || $3->idType=="TYPE_IS_ARRAY"){
				if($1->variableType=="INT" && $3->variableType=="INT"){
				$$->variableType="INT";
				
}
				else if($1->variableType=="FLOAT" || $3->variableType=="FLOAT"){
				$$->variableType="FLOAT";
				
}				
}
}
}

		               
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->assemblyCode+$2->getName()+$3->assemblyCode);
                        	$$->assemblyCode=s1;
				$$->code=$1->code;
				$$->code.append($3->code);
				char *temp=newTemp();
                                if($2->getName()=="+"){
				forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ? ");
				forAssemblyVariables.append("\n");
				$$->code.append("mov ax, ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("add ax, ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp);
				$$->code.append(" , ax\n");
				$$->setName((string)temp);
}
 				else if($2->getName()=="-"){
				forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ? ");
				forAssemblyVariables.append("\n");
				$$->code.append("mov ax, ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("sub ax, ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp);
				$$->code.append(" , ax\n");
				$$->setName((string)temp);
}
                        
}   	 	 
		  ;
					
term :	unary_expression{
		                //printf("Line at %d term : unary_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : term : unary_expression" << endl <<endl;
		                $$=$1;//$$=new SymbolInfo;
		               // $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->assemblyCode);
				$$->assemblyCode=s1;
				$$->code=$1->code;
                        
                        
}   	 
     |  term MULOP unary_expression{
		               // printf("Line at %d term : term MULOP unary_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : term : term MULOP unary_expression" << endl <<endl;
		                $$=new SymbolInfo;

				string testString;
				testString = $2->getName();

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		           

				if(testString=="*"){
				if($1->idType=="TYPE_IS_VAR" || $1->idType=="TYPE_IS_ARRAY"){
				if($3->idType=="TYPE_IS_VAR" || $3->idType=="TYPE_IS_ARRAY"){
				if($1->variableType=="INT" && $3->variableType=="INT"){
				$$->variableType="INT";
				
}
				else if($1->variableType=="FLOAT" || $3->variableType=="FLOAT"){
				$$->variableType="FLOAT";
				
}				
}
}
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		           


				else if(testString=="/"){

				if($1->idType=="TYPE_IS_VAR" ||  $1->idType=="TYPE_IS_ARRAY"){
				if($3->idType=="TYPE_IS_VAR" || $3->idType=="TYPE_IS_ARRAY"){
				if($1->variableType=="INT" && $3->variableType=="INT"){
				$$->variableType="INT";
				
}
				else if($1->variableType=="FLOAT" || $3->variableType=="FLOAT"){
				$$->variableType="FLOAT";
}				
}
}
}

				else if(testString=="%"){
				
				$$->variableType="INT";
				
				if($1->variableType=="FLOAT" || $3->variableType=="FLOAT"){
			        outputFile << "Error at line no "<<totalLine<< endl;
				outputFile <<  " Float cannot be mod "  <<endl;
				totalErrors++;				
}
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		           


		                //$$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->assemblyCode+$2->getName()+$3->assemblyCode);
                        	$$->assemblyCode=s1;
                            	$$->code=$1->code;
				$$->code.append($3->code);
				char *temp=newTemp();

				if($2->getName()=="*"){
				//$$->setName($1->getName());
				$$->code.append("mov ax, ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("mov bx, ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ? ");
				forAssemblyVariables.append("\n");
				$$->code.append("mul bx");
				$$->code.append("\n");
                        	$$->code.append("mov ");
				$$->code.append((string)temp);
				$$->code.append(", ax");
				$$->code.append("\n");
				$$->setName((string)temp);
}

				else if($2->getName()=="/"){
				//$$->setName($1->getName());
				$$->code.append("mov ax, ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("mov bx, ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ? ");
				forAssemblyVariables.append("\n");
				$$->code.append("xor dx,dx");
				$$->code.append("\n");
				$$->code.append("div bx");
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp);
				$$->code.append(", ax");
				$$->code.append("\n");
				$$->setName((string)temp);
}

				else{
			//	$$->setName($1->getName());
				$$->code.append("mov ax, ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("mov bx, ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ? ");
				forAssemblyVariables.append("\n");
				$$->code.append("xor dx,dx");
				$$->code.append("\n");
				$$->code.append("div bx");
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp);
				$$->code.append(", dx");
				$$->code.append("\n");
}

}   	 	 
     ;

unary_expression : ADDOP unary_expression{
		               // printf("Line at %d unary_expression : ADDOP unary_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : unary_expression : ADDOP unary_expression" << endl <<endl;

				

		              //  $$=$2;
		             //   $$->setName($1->getName()+$2->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->getName()+$2->assemblyCode);
                        	$$->assemblyCode=s1;
				if($1->getName()=="+"){
				$$->setName($2->getName());
				$$->code=$2->code;
}
				else if($1->getName()=="-"){
				$$->setName($2->getName());
				$$->code=$2->code;
				$$->code.append("mov ax, ");
				$$->code.append($2->getName());	
				$$->code.append("\n");
				$$->code.append("neg ax");
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append($2->getName());	
				$$->code.append(" , ax");
				$$->code.append("\n");
}
                        
}   
		 | NOT unary_expression{
		                //printf("Line at %d unary_expression : NOT unary_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : unary_expression : NOT unary_expression" << endl <<endl;
		                $$=new SymbolInfo;
				$$->variableType="INT";
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
				
		                $$->setName($2->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->getName()+$2->assemblyCode);
				char *temp=newTemp();
                        	$$->assemblyCode=s1;
                        	$$->code=$2->code;
                        	forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ?");
				forAssemblyVariables.append("\n");
				$$->code.append("mov ax, ");
				$$->code.append($2->getName());
				$$->code.append("\n");
				$$->code.append("not ax");
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp);
				$$->code.append(", ax");
}    
		 | factor{
		               // printf("Line at %d unary_expression : factor \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : unary_expression : factor" << endl <<endl;
		                $$=$1;
		              //  $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                        	s1.append($1->assemblyCode);
				$$->assemblyCode=s1;
				$$->code=$1->code;
                        
}     
		 ;
	
factor	: variable{
		                //printf("Line at %d factor : variable \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : factor : variable" << endl <<endl;
		                $$=new SymbolInfo;
		            //    $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                        	s1.append($1->assemblyCode);
				$$->assemblyCode=s1;
				char *temp=newTemp();
				$$=$1;
				$$->code=$1->code;
				if($$->idType=="TYPE_IS_ARR"){
				$$->code.append("mov ax, ");
				$$->code.append($1->getName());
				$$->code.append("[bx]");
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append((string)temp);
				$$->code.append(", ax");
				$$->code.append("\n");
				forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ?");
				forAssemblyVariables.append("\n");
				$$->setName((string)temp);
}
                        
                        
}      
	| ID LPAREN argument_list RPAREN{
		                //printf("Line at %d factor : ID LPAREN argument_list RPAREN \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : factor : ID LPAREN argument_list RPAREN" << endl <<endl;

				SymbolInfo *check;
				check=new SymbolInfo;
				check=s.lookUp($1->getName());
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
				if(check!=NULL){
				if(check->funcType=="VOID"){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " Func return Type is void "  <<endl;
				totalErrors++;	
}
				else{
				$$=new SymbolInfo;
				$$->variableType=$1->funcType;
}
}

				else{
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " Function was not declared "  <<endl;
				totalErrors++;	
}

				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		

		                
		               // $$->setName($1->getName()+$2->getName()+$3->getName()+$4->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName()+$4->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->getName()+$2->getName()+$3->assemblyCode+$4->getName());
				$$->assemblyCode=s1;
				$$->code=$3->code;
				$$->code.append("CALL ");
				$$->code.append(opp[forOpp]);
				$$->code.append("\n");
				forOp++;
				forOpp++;
				
                        
                        
}   	 	
	| LPAREN expression RPAREN{
		                //printf("Line at %d factor : LPAREN expression RPAREN \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : factor : LPAREN expression RPAREN" << endl <<endl;
		                $$=$2;
		                $$->setName($1->getName()+$2->getName()+$3->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->getName()+$2->assemblyCode+$3->getName());
				$$->assemblyCode=s1;
                        
                        
}   
	| CONST_INT{
		                //printf("Line at %d factor : CONST_INT \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : factor : CONST_INT" << endl <<endl;
		                $1->variableType="INT",$1->idType="TYPE_IS_VAR",$$=$1;
		             //   $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->getName());
				$$->assemblyCode=s1;
                        
                        
}   
	| CONST_FLOAT{
		               // printf("Line at %d factor : CONST_FLOAT \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : factor : CONST_FLOAT" << endl <<endl;
		                 $1->variableType="FLOAT",$1->idType="TYPE_IS_VAR",$$=$1;
		               // $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->getName());
				$$->assemblyCode=s1;
                        
                        
                        
}   
	| variable INCOP{
		               // printf("Line at %d factor : INCOP \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : factor : INCOP" << endl <<endl;
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
				if($1->variableType=="TYPE_IS_FUNC"){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " Function value cannot be incremented "  <<endl;
				totalErrors++;	
}
				else{
				$$=$1;
}
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		               
		               // $$->setName($1->getName()+$2->getName());
				
                                string ss="";
                                ss.append($1->assemblyCode+$2->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->getName());
				$$->assemblyCode=s1;
                        	$$=$1;
				$$->code.append("mov ax, ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("add ax, ");
				$$->code.append("1");
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append($1->getName());
				$$->code.append(" , ax");
				$$->code.append("\n");
		
                        
}    
	| variable DECOP{
		                //printf("Line at %d factor : DECOP \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : factor : DECOP" << endl <<endl;
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
				if($1->variableType=="TYPE_IS_FUNC"){
				outputFile << "Error at line no "<<totalLine<< endl;
				outputFile << " Function value cannot be decremented "  <<endl;
				totalErrors++;	
}
				else{
				$$=$1;
}
				if(checkVarLast=="error"){
                                outputFile << "Error at line no "<<totalLine<< endl;
				//This is for error checking line no
}		
		               
		               // $$->setName($1->getName()+$2->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
				s1.append($1->getName());
				$$->assemblyCode=s1;
                        	$$=$1;
				$$->code.append("mov ax, ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("sub ax, ");
				$$->code.append("1");
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append($1->getName());
				$$->code.append(" , ax");
				$$->code.append("\n");
                        
                        
}    
	;
	
argument_list : arguments{
		                //printf("Line at %d argument_list : arguments \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : argument_list : arguments" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				$$->code=$1->code;
                        
                        
}   
			  |{
		               // printf("Line at %d argument_list : arguments \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : argument_list : arguments" << endl <<endl;
		                
                        
                        
}   
			  ;
	
arguments : arguments COMMA logic_expression{
		               // printf("Line at %d arguments : arguments COMMA logic_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : arguments : arguments COMMA logic_expression" << endl <<endl;
		                $$=new SymbolInfo;
		              //  $$->setName($1->getName()+$2->getName()+$3->getName());
                                string ss="";
                                ss.append($1->getName()+$2->getName()+$3->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
				string s1="";
                                s1.append($1->assemblyCode+$2->getName()+$3->assemblyCode);
		                $$->assemblyCode=s1;
				$$->code=$1->code;
				$$->code.append($3->code);
				char *temp=newTemp();
				$$->code.append("mov ");
				$$->code.append(temp);
				$$->code.append(", ");
				$$->code.append($3->getName());
				$$->code.append("\n");
				$$->code.append("mov cx,");
				$$->code.append(temp);
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append(op[forOp]);	
				$$->code.append(" , ");
				$$->code.append("cx");
				$$->code.append("\n");
				forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ?");
				forAssemblyVariables.append("\n");
				forOp++;

                        
                        
} 

  
	      | logic_expression{
		               // printf("Line at %d arguments : logic_expression \n\n",totalLine) ;
				//outputFile << "Line at  " << totalLine <<  " : arguments : logic_expression" << endl <<endl;
		                $$=new SymbolInfo;
		                $$->setName($1->getName());
                                string ss="";
                                ss.append($1->getName());
		                //outputFile << ss.c_str() <<endl<<endl;
                        	string s1="";
                                s1.append($1->assemblyCode);
		                $$->assemblyCode=s1;
                        	$$->code=$1->code;
				char *temp=newTemp();
				$$->code.append("mov ");
				$$->code.append(temp);
				
				$$->code.append(", ");
				$$->code.append($1->getName());
				$$->code.append("\n");
				$$->code.append("mov cx,");
				$$->code.append(temp);
				$$->code.append("\n");
				$$->code.append("mov ");
				$$->code.append(op[forOp]);	
				$$->code.append(" , ");
				$$->code.append("cx");
				$$->code.append("\n");
				forOp++;
				forAssemblyVariables.append((string)temp);
				forAssemblyVariables.append(" dw ?");
				forAssemblyVariables.append("\n");
				


}   
	      ;
 


 

%%

int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	//outputFile.open("log.txt");
	outputFile.open("error.txt");
	assemblyOutput.open("code.asm");
	
	yyin=fp;
	yyparse();


	//outputFile << "   symbol table"<<endl<<endl;
	s.printAllScope();


	//outputFile << endl << "Total Line : " << totalLine-1 <<endl;
        //outputFile << "Total Errors : " << totalErrors <<endl;
	//outputFile << "Total Warnings : " << totalWarnings<<endl;

      

	outputFile << "Total Errors : " << totalErrors <<endl;
	outputFile << "Total Warnings : " << totalWarnings<<endl;
	
	
	return 0;
}




