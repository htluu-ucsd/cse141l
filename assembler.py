def convert(inFile, outFile1, outFile2):
	assembly_file = open(inFile, 'r')
	machine_file = open(outFile1, 'w')
	lut_file = open(outFile2, 'w')
	assembly = list(assembly_file.read().split('\n'))

	#keep track of index and file line number
	lineNum = 0;
	labelsNum = 0;

	#dictionaries to ease conversion of opcodes/operands to binary
	opcodes = {    'and' : '0000',
				    'or' : '0001',
				   'add' : '0010',
				   'sub' : '0011',
				  'addi' : '0100',
				  'mov3' : '0101',
				  'mov2' : '0110', 
				   'cmp' : '0111',
			  	 'shift' : '1000',
				   'beq' : '1001',
 				   'bge' : '1010',
				   'blt' : '1011',
				'branch' : '1100',
				   'str' : '1101',
				   'ldr' : '1110',
				  'halt' : '1111'}
	
	R_type = ['0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111', '1000']
	B_type = ['1001', '1010', '1011', '1100']
	D_type = ['1101', '1110']

	lower_regs = ['000', '001', '010', '011']
	
	registers = {'r0' : '000', 'r1' : '001', 'r2' : '010', 'r3' : '011', 'r4' : '100', 'r5' : '101', 'r6' : '110', 'r7' : '111'}

	reg_imm = {'reg' : '1', 'imm' : '0'}

	direction = {'left' : '1', 'right' : '0'}

	carry_in = {'in': '1', 'no': '0'}
	
	#reads through assembly and collects labels to populate lookup table
	lut = {}
	for line in assembly:
		instr = line.split();
		lineNum += 1
		#check if it is a label or not
		if instr[0] not in opcodes:
			lut[instr[0].replace(':', '')] = labelsNum
			lut_file.write(str(lineNum) + '\n')
			labelsNum += 1

	print(lut)
	
	#reads through file to convert instructions to machine code
	for l, line in enumerate(assembly):
		output = ""
		instr = line.split(); #split to get instruction and different operands

		#make sure it is an instruction, skip over labels
		if instr[0] in opcodes:
			output += opcodes[instr[0]]

			del instr[0] #REMOVE INSTUCTION TYPE

			if output in R_type and output != '1000': #2 reg operations
				instr[0] = instr[0].replace(',', '');

				if registers[instr[0]] in lower_regs:
					output += registers[instr[0]][1:] # first reg should be 0-3 only

					if instr[1] in registers:
						output += registers[instr[1]]
					else:
						if output[:4] == '0100':
							output += f"{int(instr[1]):b}" # treat as immediate value, need to be converted to binary
						else:
							raise Exception(f"neither register nor immediate on line {l}: {line}")
				else:
					raise Exception(f"not register 0-3 on line {l}: {line}")
				#MOV
				# imm = bin(int(instr[0]))[2:]

				# if output is '0100':
				# 	#pad to 6 bits for the immediate
				# 	for i in range(0, 6-len(imm)):
				# 		imm = '0'+imm
				# 	output += imm
			elif output == '1000':
				instr[0] = instr[0].replace(',', '');
				instr[1] = instr[1].replace(',', '');
				if (instr[0] in direction):
					output += direction[instr[0]]
					if (instr[1] in carry_in):
						output += carry_in[instr[1]]
						if (instr[2] in registers):
							output += registers[instr[2]]
						else:
							raise Exception(f"not a register on line {l}: {line}")
					else:
						raise Exception(f"does not specify \'in\' for carry or \'no\' for no carry on line {l}: {line}")
				else:
					raise Exception(f"does not specify direction on line {l}: {line}")
			elif output in B_type: #branching operation
				# branching
				if instr[0] in direction and instr[1] in reg_imm:
					output += direction[instr[0]]
					output += reg_imm[instr[1]]

					if instr[2] in registers:
						output += registers[instr[2]]
					else:
						if int(instr[2]) < 2:
							output += '0'
						if int(instr[2]) < 4:
							output += '0'
						output += f"{int(instr[2]):b}" # treat as immediate value
				else:
					raise Exception(f"neither register nor immediate on line {l}: {line}")
				
			elif output in D_type:
			# 	remove commas from register operand names and check
				instr[0] = instr[0].replace(',', '');

				if instr[0] in registers:
					output += registers[instr[0]]

					if int(instr[1]) < 2:
						output += '0'

					output += f"{int(instr[1]):b}"
				else:
					raise Exception(f"not a register on line {l}: {line}")
			else:
				output += '11111'
			#write binary to machine code output file
			machine_file.write(str(output) + '\t// ' + line + '\n')

	assembly_file.close()
	machine_file.close()

# convert("assembler/assembly.txt", "assembler/machine.txt", "assembler/lut.txt")
convert("Program3/program3.txt", "Program3/machine.txt", "Program3/lut.txt")