%{
    #include<stdio.h>
    int yylex();
       // for I/O
    #include <string.h>  // for string handling 
    #include <stdlib.h>
    #include <ctype.h>  
    #include<cstring>
    #define YYSTYPE char *
    void yyerror(char *s);
    using namespace std;
    extern FILE *yyin;
    extern int lineno;
    extern char decl_type[10];
    extern char var[31];
    extern int scope;
    #include <iomanip> 
    #include<iostream>
    #include<stdlib.h>
    //#include"conio.h"
    #include <vector>
    #include <algorithm>
    #include <bits/stdc++.h>
    #include <cctype>
    #include <cstring>
    typedef struct Symbol_table
    {
        string name;
        string val;
        string datatype;
        int line;
        int scope;
    }Symbol_table;
    int struct_index = 0;
    Symbol_table *node;
    int capacity = 20;
    vector<string>::iterator it; 
    int i = 0;
    string temp;
    string unary;
    int ind;
    int size;
    int ret_line = 0;
    //quadruple format
    typedef struct quadruples
  {
    char *op;
    char *arg1;
    char *arg2;
    char *res;
  }quad;
  int quadlen = 0;
  quad q[100];
    
    int index1=0,top=0,lnum=0,ltop=0;
    int label[1000];
    char st1[1000][100];
    char i_[10]="1";
    char temporary[10]="t";
    char E[20];
    char casestack[100][100];
    int case_idx=0;
    
    
    vector<string> arr;
    vector<string> arr2;
    int hashcode(int key)
    {
        return key%capacity;
    }
    //---------------------Symbol Table-------------------------------------
    void init_array()
    {
        node = (struct Symbol_table*)malloc(capacity*sizeof(struct Symbol_table));
        for(int i = 0;i<capacity;i++)
        {
            node[i].name = "null";
            node[i].datatype = "null";
            node[i].val = "null";
            node[i].line = 0;
            node[i].scope = scope;
        }
    }
    string find(string value)
    {
        if (!isdigit(value[0]))
        {
            int index = hashcode(i);
            for(int in = 0; in < index; in++)
            {
                if (node[in].name == value && node[in].val!="undefined")
                {
                    return node[in].val;
                }
            }
        }
        else
        {
            return value;
        }
        
    }

    void expval(string value)
    {
        arr2.push_back(value);
        

    }


    void insert(string name,string val,string datatype,int line, int scope)
    {
        
        int index = hashcode(i);
        if(name == "return")
        {
            ret_line = line;
        }
        string str2=to_string(scope);
        if(val == "int" || val =="float" || val =="char")
        {
            val = arr2[arr2.size()-1];
            
        }
        else if (isdigit(val[0]) == false && val!="undefined")
        {
            val = find(val);
        }
        if( name == "int" || name == "float" || name == "char")
        {
            if( count(arr.begin(), arr.end(), arr.end()[-2]) >=2)
            {
                vector<int> temp;
                for(int i =0;i<arr.size();i++)
                {
                    if(arr[i] == arr.end()[-2])
                    {
                        temp.push_back(i+1);
                    }
                }
                ind = temp.end()[-2];
                if(arr[ind] == arr.end()[-1])
                {
                     cout<<"Error parsing failed!"<<"\n";
                     cout<<"\nRedeclaration error at line number : "<<line<<"\n";
                     exit(0);

                }
                else
                {
                    node[index].name = name;
                    node[index].val = val;
                    node[index].datatype = datatype;
                    node[index].line = line;
                    node[index].scope = scope;
                    i++;
                }
            }
       
        }
	else if(name != "int" && name != "float" && name != "char" && datatype=="undefined")
	{
		//cout<<arr.end()[-1];
		if(count(arr.begin(), arr.end(), arr.end()[-2]) <= 1)   // why is count of a equal to 0?
		//if(find(arr.begin(), arr.end(), name) !=arr.end())
		{
			//cout<<name<<"\t";
			//display();
			cout<<"Error parsing failed!"<<"\n";
                       cout<<"\nVariable undefined at line number : "<<line<<"\n";
                       exit(0);
		}
	}
        else
        {
             int j; 
             for(j = 0; j<index;j++)
             {
                if(node[j].name == name && node[j].scope==scope && val!="undefined")
                {
                    node[j].name = name;
                    node[j].val = val;
                    node[j].datatype = datatype;
                    node[j].line = line;
                    node[j].scope = scope;
                    size++;
                    i++;
                    break;
                }
             }
             if(j==index)
             {
                node[index].name = name;
                node[index].val = val;
                node[index].datatype = datatype;
                node[index].line = line;
                node[index].scope = scope;
                size++;
                i++;
             }

        }
        arr.push_back(name);
        //arr.push_back(val);
        //arr.push_back(datatype);
        string str1 = to_string(scope);
        arr.push_back(str1);
      
    }
    
    void insert_temp(string name,string val,string datatype,int line, int scope)
    {
    	int index = hashcode(i);
    	if(name!=(string)node[index-1].name && val!=(string)node[index-1].val && line!=node[index-1].line)
    	{
        node[index].name = name;
        node[index].val = val;
        node[index].datatype = datatype;
        node[index].line = line;
        node[index].scope = scope;
        size++;
        i++;
        }
    }
    
    void display()
    {
        cout<<setw(50)<<"------------------------------Symbol table------------------------------\n\n";
        int i;
        cout<<setw(4)<<"Slno."<<setw(20)<<"Name"<<setw(20)<<"Value"<<setw(20)<<"Datatype"<<setw(20)<<"lineno"<<setw(20)<<"scope"<<"\n\n";
        for(i  = 0;i<capacity;i++)
        {
            if( node[i].line < 1 || node[i].scope < 0 || node[i].name == node[i].val)
            	continue;
            cout<<setw(4)<<i<<setw(20)<<node[i].name<<setw(20)<<node[i].val<<setw(20)<<node[i].datatype<<setw(20)<<node[i].line<<setw(20)<<node[i].scope<<"\n";
        }
        cout<<"\n";
    }

//--------------quadruple table---------------------------------------
void quad_table(char *op, char *arg1, char *arg2, char *res)
{
	q[quadlen].op = (char*)malloc(sizeof(char)*strlen(op));
    	q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(arg1));
	q[quadlen].arg2 = (char*)malloc(sizeof(char)*strlen(arg1));
	q[quadlen].res = (char*)malloc(sizeof(char)*strlen(res));
	strcpy(q[quadlen].op,op);
	strcpy(q[quadlen].arg1,arg1);
	strcpy(q[quadlen].arg2,arg2);
        strcpy(q[quadlen].res,res);
        quadlen++;
}
//------------------3 address code--------------------------------------
void f1()
{
	lnum++;
	label[++ltop]=lnum;
	cout<<"L"<<lnum<<":\n";
	
	char t1[20]="L";
    	std::string tmp1 = std::to_string(lnum);
    	char const *lnum_char1 = tmp1.c_str();
	strcat(t1,lnum_char1);   // <cstring>
	quad_table("label","NULL","NULL",t1);
}
void f2()
{

	lnum++;
	strcpy(temporary,"t");
	strcat(temporary,i_);
 	cout<<"if"<<"  "<<st1[top--]<<"  "<<"goto L"<<lnum<<"\n";
 	
 	char t[20]="L";
    	std::string tmp = std::to_string(lnum);
    	char const *lnum_char = tmp.c_str();
	strcat(t,lnum_char);
 	quad_table("if",st1[top--],"NULL",t);
	
	label[++ltop]=lnum;
	lnum++;   //3
	printf("goto L%d\n",lnum);
	
	char t1[20]="L";
    	std::string tmp1 = std::to_string(lnum);
    	char const *lnum_char1 = tmp1.c_str();
	strcat(t1,lnum_char1);
 	quad_table("goto","NULL","NULL",t1);
	
	label[++ltop]=lnum;  // ltop=3
	lnum++;  //4
	printf("L%d:\n",lnum);	
	
	char t2[20]="L";
    	std::string tmp2 = std::to_string(lnum);
    	char const *lnum_char2 = tmp2.c_str();
	strcat(t2,lnum_char2);
 	quad_table("label","NULL","NULL",t2);
	
	label[++ltop]=lnum;  /// ltop=4
}
void f3()
{
	printf("goto L%d\n",label[ltop-3]);
	char t[20]="L";
    	std::string tmp = std::to_string(ltop-3);
    	char const *lnum_char = tmp.c_str();
	strcat(t,lnum_char);   // <cstring>
	quad_table("goto","NULL","NULL",t);
	
	printf("L%d:\n",label[ltop-2]);
	char t1[20]="L";
    	std::string tmp1 = std::to_string(ltop-2);
    	char const *lnum_char1 = tmp1.c_str();
	strcat(t1,lnum_char1);   // <cstring>
	quad_table("label","NULL","NULL",t1);
}

void f4()
{
	printf("goto L%d\n",label[ltop]);
    	char t[20]="L";
    	std::string tmp = std::to_string(ltop);
    	char const *lnum_char = tmp.c_str();
	strcat(t,lnum_char);   // <cstring>
	quad_table("goto","NULL","NULL",t);
        
	printf("L%d:\n",label[ltop-1]);
	char t1[20]="L";
    	std::string tmp1 = std::to_string(ltop-1);
    	char const *lnum_char1 = tmp1.c_str();
	strcat(t1,lnum_char1);   // <cstring>
	quad_table("label","NULL","NULL",t1);

	ltop-=4;
}

void s1()
{
	printf("goto test\n");
	quad_table("goto","NULL","NULL","test");
	//lnum++;
	//printf("goto L%d\n",lnum);
	//printf("L%d: \n",label[ltop--]);
	//label[++ltop]=lnum;
}
void s2()
{
	printf("goto last\n");
	quad_table("goto","NULL","NULL","last");
}
void s3()
{
	printf("test:\n");
	quad_table("label","NULL","NULL","test");
	
	
	for(int i=1;i<ltop;i++)
	{
		printf("if (%s==%s) goto L%d\n",E,casestack[i-1],label[i]);
		char t1[20]="L";
		char t2[20]="";
    		std::string tmp1= std::to_string(label[i]);
	    	char const *lnum_char1 = tmp1.c_str();
		strcat(t1,lnum_char1);
		strcat(t2,E);
		strcat(t2,"==");
		strcat(t2,casestack[i-1]);
		quad_table("if",t2,"NULL",t1);             // check if this is correct
	}
	printf("goto L%d\n",label[ltop]);
	char t[20]="L";
    	std::string tmp = std::to_string(ltop);
    	char const *lnum_char = tmp.c_str();
	strcat(t,lnum_char);   // <cstring>
	quad_table("goto","NULL","NULL",t);
	
	printf("last: end\n");
	quad_table("label","NULL","NULL","last");
}

void push(char *a)
{
	strcpy(st1[++top],a);
}
void push1(char *a)
{
	strcpy(casestack[case_idx++],a);
}

void threegen()
{
	strcpy(temporary,"t");
	strcat(temporary,i_);
    if ((string)st1[top]=="<" || (string)st1[top]=="<=" || (string)st1[top]==">" || (string)st1[top]==">=" || (string)st1[top]=="==")
    {
      printf("%s = %s %s %s\n",temporary,st1[top-1],st1[top],st1[top-2]);
      quad_table(st1[top],st1[top-1],st1[top-2],temporary);
      insert_temp(string(temporary),string(st1[top-1])+string(st1[top])+string(st1[top-2]),"temp",lineno,scope);
    }
    else
    {
      printf("%s = %s %s %s\n",temporary,st1[top-2],st1[top-1],st1[top]);
      quad_table(st1[top-1],st1[top-2],st1[top],temporary);
      insert_temp(string(temporary),string(st1[top-2])+string(st1[top-1])+string(st1[top]),"temp",lineno,scope);
    } 
    top-=2;
	strcpy(st1[top],temporary);
	i_[0]++;  //i_=2
}


void switch_code()
{
	strcpy(temporary,"t");
	strcat(temporary,i_);
	printf("%s = %s\n",temporary,st1[top]);
	quad_table("=",st1[top],"NULL",temporary);
	insert_temp(string(temporary),string(st1[top]),"temp",lineno,scope);
	top-=1;
	strcpy(st1[top],temporary);
	i_[0]++;  //i_=2
}

void assign_code()
{
    
       	printf("%s = %s\n",st1[top-1],st1[top-2]);
    	quad_table("=",st1[top-2],"NULL",st1[top-1]);
    	insert_temp(string(st1[top-1]),string(st1[top-2]),"temp",lineno,scope);
	    top-=2;
    

}



        

%}
%token T_ID T_NUM T_FLOAT T_INT T_CHAR T_UOP T_BOP_LT T_BOP_LTE T_BOP_GTE T_BOP_GT T_BOP_EQ T_BOP_AND T_FOR T_MAIN T_ADD T_SUB T_OP T_CP T_COUT T_PR T_SWITCH T_CASE T_DEFAULT T_BREAK T_MULT T_DIV T_BOP1 T_RET
%left T_ADD T_SUB
  
%left T_MULT T_DIV 
%%
Prog  : Prog ext_Decl
      | ext_Decl
      ;

ext_Decl  : func_defn 
          | Decl
          ;
          
Decl      : TYPE assign ';' {insert(decl_type,"undefined",decl_type,lineno,-1);}
          | assign ';'     {insert($1,"undefined","undefined",lineno,scope);}
          | TYPE T_ID number ';' {insert(decl_type,"undefined",decl_type,lineno,-1);}
          | T_ID number ';'
          
          ;

number    : number T_OP T_NUM T_CP  {insert($1,$3,decl_type,lineno,scope);}
	  
          | T_OP T_NUM T_CP
          | number T_OP T_ID T_CP
          | T_OP T_ID T_CP
          ;
assign    : T_ID  T_BOP1 evaluate {strcpy(st1[++top],$1);} { strcpy(st1[++top],"="); insert($1,$3,decl_type,lineno,scope); assign_code();}
          
	      | T_ID  T_BOP_LT  assign {push($1); strcpy(st1[++top],"<"); threegen();}
          | T_ID  T_BOP_LTE  assign {push($1); strcpy(st1[++top],"<="); threegen();}
          | T_ID  T_BOP_GT  assign {push($1); strcpy(st1[++top],">"); threegen();}
          | T_ID  T_BOP_GTE  assign {push($1); strcpy(st1[++top],">="); threegen();}
          | T_ID  T_BOP_EQ  assign {push($1); strcpy(st1[++top],"=="); threegen();}
          | T_ID  T_BOP_AND  assign {push($1); strcpy(st1[++top],"&&"); threegen();}
          | T_ID T_UOP
          | T_UOP T_ID
          | T_ID ',' assign  {insert($1,$3,decl_type,lineno,scope);}
          
          | T_NUM ',' assign {insert($$,$1,decl_type,lineno,scope);}
          
          | T_ID number T_BOP1 assign 
          | T_ID number T_BOP_LT assign
        
           
          
        
          | T_NUM 
          | T_ID {insert($1,"undefined",decl_type,lineno,scope); $$ = $1;}
          |  '{' assign '}' 
          ;

evaluate  : E  
          E : E T_ADD E {$$ = &to_string(stoi(find($1)) + stoi(find($3)))[0];  expval($$); strcpy(st1[++top],st1[top-1]); strcpy(st1[++top],"+");  strcpy(st1[++top],$3); threegen();}
            | E T_SUB E {$$ = &to_string(stoi(find($1)) - stoi(find($3)))[0]; expval($$);  strcpy(st1[++top],st1[top-1]); strcpy(st1[++top],"-");  strcpy(st1[++top],$3); threegen();}
            | E T_MULT E {$$ = &to_string(stoi(find($1)) * stoi(find($3)))[0]; expval($$); strcpy(st1[++top],st1[top-1]); strcpy(st1[++top],"*");  strcpy(st1[++top],$3); threegen();}
            | E T_DIV E {$$ = &to_string(stoi(find($1)) / stoi(find($3)))[0]; expval($$);}
            | '(' E ')' {$$ = $2 ; expval($$);}
            | T_NUM {$$ = $1; strcpy(st1[++top],$1);}      
            | T_ID  {$$ = $1; strcpy(st1[++top],$1);} 
            |'{' assign '}' 
          ;        
          ;
func_defn :  TYPE T_MAIN '(' ')'  { scope=scope+1 ; } {insert("main","undefined","keyword",lineno,scope);} codeblock { scope=scope-1 ; }
	      ;

codeblock: '{' stmt_list '}'
         | '{' stmt_list defaultstm '}'
         ;  
         ;  
                
stmt_list: stmt_list stmt  
         | stmt
         ;
         
stmt: loop
    | switch
    | caselist
    | Decl
    | printf
    | ret {insert("return","undefined","keyword",lineno,scope);}
    |';'
    ;

ret : T_RET T_NUM ';'
    |  T_RET T_ID ';'
     ;

loop : { scope=scope+1 ; } T_FOR '(' exp  {f1();} ';' exp {f2();} ';' exp  {f3();}')'  codeblock {f4();  scope=scope-1 ; }
     ;


stmt1: | Decl
    | printf
    | loop
    |';'
    ;

printf : T_COUT T_PR  exp ';'  

          ;
assign1    : 
          T_ID  T_BOP1 evaluate  {push($1); strcpy(st1[++top],"="); assign_code();}
	
	      | T_ID T_BOP_LT  assign1  { unary = find($3);$$ = &to_string(stoi(unary) - 1)[0];  expval($$); insert($1,$$,decl_type,lineno,scope);} {strcpy(st1[++top],$1);  strcpy(st1[++top],"<"); threegen();}
          | T_ID T_BOP_LTE  assign1  { unary = find($3);$$ = &to_string(stoi(unary))[0];  expval($$); insert($1,$$,decl_type,lineno,scope);} {strcpy(st1[++top],$1);  strcpy(st1[++top],"<="); threegen();}
          |	T_ID T_BOP_GT  assign1  { unary = find($3);$$ = &to_string(stoi(unary) + 1)[0];  expval($$); insert($1,$$,decl_type,lineno,scope);} {strcpy(st1[++top],$1);  strcpy(st1[++top],">"); threegen();}
          |	T_ID T_BOP_GTE  assign1  { unary = find($3);$$ = &to_string(stoi(unary))[0];  expval($$); insert($1,$$,decl_type,lineno,scope);} {strcpy(st1[++top],$1);  strcpy(st1[++top],">="); threegen();}
          | T_UOP T_ID
          | T_ID ',' assign1
          | T_NUM ',' assign1
          | T_NUM {$$ = $1; push($1);}
          | T_ID  {push($1); } 
          ;

exp :TYPE assign1
    |assign1
    ;

switch : T_SWITCH '(' T_ID {push($3); strcpy(E,$3);} ')' {switch_code();  scope=scope+1 ; s1();}  codeblock  { scope=scope-1 ; } {s3();}
	;
	
caselist	:	{f1();} casestm {s2();}
		;
			
casestm	:	T_CASE T_NUM {push1($2);} ':' stmt_list T_BREAK ';'  
		;

defaultstm	:    {f1();} T_DEFAULT  ':' stmt1 T_BREAK ';'  {s2();}
		;

TYPE  : T_INT 
      | T_FLOAT
      | T_CHAR
      ;

%%
int main()
{
	printf("---------------Three address code---------------\n");
	init_array();
	yyin = fopen("switchforpgm.cpp","r");
	yylex();
	
	if(!yyparse())
	{
		printf("\nParsing complete\n\n");
		//printf("hello\n");
		printf("----------------------Quadruples----------------------\n\n");
               printf("Operator \t Arg1 \t\t Arg2 \t\t Result \n");
               int i;
               for(i=0;i<quadlen;i++)
               {
                printf("%-8s \t %-8s \t %-8s \t %-6s      \n",q[i].op,q[i].arg1,q[i].arg2,q[i].res);
               }
               printf("\n\n");
               display();
	}
	else
	{
			printf("\nParsing failed\n\n");
			exit(0);
	}
	fclose(yyin);
	return 0;
}

void yyerror(char *s)
{
	printf("%s at line no : %d\n",s,lineno-1);
}
