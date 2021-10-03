import collections
import re
import sys

istemp = lambda s : bool(re.match(r"^t[0-9]*$", s)) 
isid = lambda s : bool(re.match(r"^[A-Za-z][A-Za-z0-9_]*$", s))

def propagation(list3,vari_stmt):
	var_list = []
	branch=[]
	for i in list3:
		if ':' in i:
			branch.append(list3.index(i))

		if len(list(i))==5 and len(list(i)[0]) == 1 and list(i)[4].isnumeric() and ':' not in list(list3[list3.index(i)+1]):
			var_list.append((list(i)[0],int(list(i)[4])))
	list4 = []
	
	for i in list3:
		for k in var_list:
			if vari_stmt==[]:
			
				while k[0] in i and '=' in i and i.index(k[0])>i.index('='):
					
							i = i.replace(k[0],str(k[1]))
			else:
				while k[0] in i and '=' in i and i.index(k[0])>i.index('=') and k[0] not in vari_stmt:
							#print(k[0])
					
							i = i.replace(k[0],str(k[1]))
				
		list4.append(i)
     #list4 = list3[:len(var_list)] + list4	
    
	
	return list4			
			
def loop_invariant(list_cond):
	loop_var = []
	for i in list_cond: 
		if '<' in i:
			symb = '<'
			loop_var.append(i[i.index(symb)-2])
		elif '>' in i:
			symb = '>'
			loop_var.append(i[i.index(symb)-2])
			
	loop_inv=[list_cond[0]]
	loop_ind = []
	loop_variant = []
	stmt = []
	for i in range(1,len(list_cond)):
		j = 0
		while(j <len(loop_var)):
			if loop_var[j] not in list_cond[i] and loop_var[j] not in list_cond[i-1] and ':' not in list_cond[i] and list_cond[i]!='' and "goto" not in list_cond[i]:
				loop_inv.append(list_cond[i])
				loop_ind.append(i)
			elif ':' not in list_cond[i] and list_cond[i]!='' and "goto" not in list_cond[i]:
				if len(list_cond[i]) == 6 and list_cond[i][0] not in loop_var:
					
					loop_variant.append(list_cond[i][0])
					stmt.append(list_cond[i])
			j+=1


	vari_stmt = []
	for i in loop_inv:
		for j in loop_variant:
			if j in i and i.index(j)>i.index('='):
				if len(i)==10:
					loop_variant.append(loop_inv[loop_inv.index(i)+1][0])
				else:
					loop_variant.append(loop_inv[loop_inv.index(i)][0])
				vari_stmt.append(i)
				vari_stmt.append(loop_inv[loop_inv.index(i)+1])
	
	
	loop_inv = [ x for x in loop_inv if x not in vari_stmt]
	#print(loop_variant)
	loop_vari = []
	for i in list_cond:
		if i not in loop_inv:
			loop_vari.append(i)

	return loop_inv + loop_vari,loop_variant



			

	


	
# removing unreachable code (like those present after break) (anyline present between goto Label and Label:)
def unreachable_code1():
		
	remove_lines = []
	final_list = []

	for i in range(len(lines)):
		if lines[i].startswith("goto"):
			idx = i+1
			for j in range(idx,len(lines)):
				if(lines[j].startswith("L") or ("if" in lines[j])  or ("test" in lines[j]) or ("last" in lines[j]) ):
					break
				else:
					remove_lines.append(j)

	#print(remove_lines)	

	for i in range(len(lines)):
		if i not in remove_lines:
			final_list.append(lines[i])
	
	return final_list


# removing those lines where variables are never used
def unreachable_code2(lines):

	final_list = []
	variable_names = []
	not_repeat = []
	
	for i in range(len(lines)): 
		if(len(lines[i].split()) == 3) :    # c = 0 ,  c = b
			left = lines[i].split()[0] # in case of switch skip temporary  t1 = choice
			if (not(left.startswith("t"))):
				variable_names.append(left)
			right1 = lines[i].split()[2]    
			if (not(right1.isdigit())):
				variable_names.append(right1)
		if(len(lines[i].split()) == 5) :    # c = a + b,  c = 0 + b
			variable_names.append(lines[i].split()[0])
			right1 = lines[i].split()[2]
			right2 = lines[i].split()[4]
			if (not(right1.isdigit())):
				variable_names.append(right1)
			if (not(right2.isdigit())):
				variable_names.append(right2)
	#print(variable_names)	
			
	occurrences = dict(collections.Counter(variable_names))
	#print(occurrences)
	
	for key in occurrences:
		if occurrences[key] == 1:
			not_repeat.append(key)
			
	#print(not_repeat)
	
	for i in range(len(lines)):   #2,3,4,5
		if(len(lines[i].split()) == 1) :   # L1:
			final_list.append(lines[i])
		if(len(lines[i].split()) == 2) :   # goto L1
			final_list.append(lines[i])
		if(len(lines[i].split()) == 4) : 
			final_list.append(lines[i])
		if(len(lines[i].split()) == 3) :    # c = 0 ,  c = b
			left = lines[i].split()[0] # in case of switch skip temporary  t1 = choice
			right = lines[i].split()[2] 
			if (left not in not_repeat and right not in not_repeat):
				final_list.append(lines[i])
		if(len(lines[i].split()) == 5) :    # c = a + b,  c = 0 + b
			if("<" in lines[i] or ">" in lines[i] or "<=" in lines[i] or ">=" in lines[i]):
				final_list.append(lines[i])
			else:
				left = lines[i].split()[0]
				right1 = lines[i].split()[2]
				right2 = lines[i].split()[4]
				if (left not in not_repeat and right1 not in not_repeat and right2 not in not_repeat):
					final_list.append(lines[i])
					
	#print(final_list)	
	return final_list


# Temporaries not used in any expressions are deleted.
def unreachable_code3(list_of_lines) :
	
	num_lines = len(list_of_lines)
	temps_on_lhs = set()
	for line in list_of_lines :
		tokens = line.split()
		if istemp(tokens[0]) :
			temps_on_lhs.add(tokens[0])

	useful_temps = set()
	for line in list_of_lines :
		tokens = line.split()
		if len(tokens) >= 2 :
			if istemp(tokens[1]) :
				useful_temps.add(tokens[1])
		if len(tokens) >= 3 :
			if istemp(tokens[2]) :	
				useful_temps.add(tokens[2])

	temps_to_remove = temps_on_lhs - useful_temps
	new_list_of_lines = []
	for line in list_of_lines :
		tokens = line.split()
		if tokens[0] not in temps_to_remove :
			new_list_of_lines.append(line)
	if num_lines == len(new_list_of_lines) :
		return new_list_of_lines
	return unreachable_code3(new_list_of_lines)

# evaluating 10 + 20
def folding(lines):
	
	final_list = []
	res = -1	
	
	for i in range(len(lines)):   #2,3,4,5
		if(len(lines[i].split()) == 1 or len(lines[i].split()) == 2 or len(lines[i].split()) == 3 or len(lines[i].split()) == 4) :  
			final_list.append(lines[i])   # L1:   # goto L1   # c = 0 ,  c = b    # c = a + b,  c = 0 + b
		if(len(lines[i].split()) == 5) :    
			left = lines[i].split()[0]
			right1 = lines[i].split()[2]
			op = lines[i].split()[3]
			right2 = lines[i].split()[4]
			if (right1.isdigit() and right2.isdigit()):
				if op == "+":
					res = int(right1) + int(right2)
				if op == "-":
					res = int(right1) - int(right2)
				if op == "/":
					res = int(right1) / int(right2)
				if op == "*":
					res = int(right1) * int(right2)
				l = left + " = " + str(res)
				final_list.append(l)
			else:
				final_list.append(lines[i])
	
		
	return final_list	

def dict_exp(list_of_lines) :
	expressions = {}
	for line in list_of_lines :
		tokens = line.split()
		if len(tokens) == 5 :
			rhs = tokens[2] + " " + tokens[3] + " " + tokens[4]
			if rhs not in expressions :
				expressions[rhs] = tokens[0]
	return expressions


def eliminate_common_subexpressions(list_of_lines) :
	expressions = dict_exp(list_of_lines)
	#print(expressions)
	lines = len(list_of_lines)
	new_list_of_lines = list_of_lines[:]
	for i in range(lines) :
		tokens = list_of_lines[i].split()
		if len(tokens) == 5 :
			rhs = tokens[2] + " " + tokens[3] + " " + tokens[4]
			if rhs in expressions and expressions[rhs] != tokens[0]:
				new_list_of_lines[i] = tokens[0] + " " + tokens[1] + " " + expressions[rhs]
	return new_list_of_lines

if len(sys.argv) == 2 :
	icg_file = str(sys.argv[1])		

fin = open(icg_file, "r")
fout = open("optim_code.txt", "w")  # add to file after completely completing unreachable/ dead code
fout1 = open("optim_code_comsub.txt", "w")
lines = fin.readlines()
length = len(lines)

for i in range(len(lines)):
	lines[i] = lines[i].strip("\n")


final_list1 = unreachable_code1()
for i in range(len(final_list1)):
	if '==' in final_list1[i]:
		break
if i == len(final_list1)-1:
	loop_lis,vari_stmt = loop_invariant(final_list1)
else:
	loop_lis = final_list1
	vari_stmt = []


final_list2 = unreachable_code2(loop_lis)

final_list3 = unreachable_code3(final_list2)

final_list4 = eliminate_common_subexpressions(final_list3)
for l1 in final_list4:
	fout1.write('%s\n' % l1)

final_list5 = propagation(final_list4,vari_stmt)
final_list6 = folding(final_list5)
	
#print(final_list1)
#print(final_list2)
	
for l in final_list6:
	fout.write('%s\n' % l)
	
print("Eliminated", length-len(final_list6), "lines of code")

fin.close()
fout.close() 
