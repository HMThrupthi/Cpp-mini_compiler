# Cpp-mini-compiler
A mini compiler


Steps to run the files:

lex lex.l 

bison -d yacc.y 

g++ yacc.tab.c lex.yy.c -ll -ly -w 

./a.out 



File names : lex file - lex.l,  yacc file - yacc.y 

Name of the input file is in yacc file


Intermediate code generated is copied to icg.txt



Step to run code optimization file : 
python3 co.py icg.txt

(python3 co.py “icg file name.txt”)
