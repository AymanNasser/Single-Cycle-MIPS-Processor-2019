
def Assembler(root):
    registers = [
        "$0", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3", "$t0", "$t1",
        "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$s0", "$s1", "$s2", "$s3",
        "$s4", "$s5", "$s6", "$s7", "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra" ]
    registers_index = ["00000","00001","00010","00011","00100","00101","00110","00111","01000","01001","01010","01011"
                       ,"01100","01101","01110","01111","10000","10001","10010","10011","10100","10101","10110","10111",
                       "11000","11001","11010","11011","11100","11101","11110","11111"]

    functionsDetails = [
            {"name":"add","format":"R","opCode":"000000","funct":"100000"},
            {"name":"and","format":"R","opCode":"000000","funct":"100100"},
            {"name":"or","format":"R","opCode":"000000","funct":"100101"},
            {"name":"sll","format":"R","opCode":"000000","funct":"000000"},
            {"name":"jr","format":"R","opCode":"000000","funct":"001000"},
            {"name":"slt","format":"R","opCode":"000000","funct":"101010"},
            {"name":"addi","format":"I","opCode":"001000","funct":"-1"},
            {"name":"ori","format":"I","opCode":"001101","funct":"-1"},
            {"name":"lw","format":"I","opCode":"100011","funct":"-1"},
            {"name":"sw","format":"I","opCode":"101011","funct":"-1"},
            {"name":"beq","format":"I","opCode":"000100","funct":"-1"},
            {"name":"j","format":"J","opCode":"000010","funct":"-1"},
            {"name":"jal","format":"J","opCode":"000011","funct":"-1"}]

    def bin_digits(n, bits):
        n = int(n)
        s = bin( n & int("1"*bits,2))[2:]
        return ("{0:0>%s}" % (bits)).format(s)

    newline =[] # the new line that will be translated from each instruction

    f = open(root, "r") #r for read , w for write;
    commands = []
    linecounter = 0 #the instruction memory index , also known as PC/4
    for line in f:
        commands.append((line.strip()).replace("("," ").replace(")"," ")) #command is a list of instructions after removing the \n at the end of each line
    try:
        for index,instruction in enumerate(commands):
            splitted = instruction.split() #splitted contains each word separately , but the words are splitted by , or space, so use replace to remove them
            if len(splitted) > 4: #no label line
                label_index = 1
            else:
                label_index = 0
            for k_index,k in enumerate(functionsDetails):
                if k["name"] == splitted[0 + label_index]:
                    newline.append(functionsDetails[k_index]["opCode"])
                    y = functionsDetails.index(k) #the index of the function identified from the functon Details array

            if functionsDetails[y]["name"] == "j" or functionsDetails[y]["name"] == "jal":
                for jump_to_index,line_containing_label in enumerate(commands):
                    if line_containing_label.split()[0].replace(":","") == splitted[1]:
                        newline[linecounter] = newline[linecounter] + str(bin_digits(jump_to_index,26))

            elif functionsDetails[y]["name"] == "beq":
                for jump_to_index,line_containing_label in enumerate(commands):
                    if line_containing_label.split()[0].replace(":","") == splitted[3]:
                        newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[1 + label_index].replace(",", ""))]
                        newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[2 + label_index].replace(",", ""))]
                        newline[linecounter] = newline[linecounter] + str(bin_digits( (jump_to_index - (index + 1)),16))

            elif functionsDetails[y]["name"] == "jr":
                newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[1 + label_index].replace(",", ""))]
                newline[linecounter] = newline[linecounter] + "00000"
                newline[linecounter] = newline[linecounter] + "00000"
                newline[linecounter] = newline[linecounter] + "00000"
                newline[linecounter] = newline[linecounter] + functionsDetails[y]["funct"]

            elif functionsDetails[y]["name"] == "sll":
                newline[linecounter] = newline[linecounter] + "00000"
                newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[2 + label_index].replace(",", ""))]
                newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[1 + label_index].replace(",", ""))]
                newline[linecounter] = newline[linecounter] + str(bin_digits(splitted[3 + label_index],5))
                newline[linecounter] = newline[linecounter] + functionsDetails[y]["funct"]

            elif functionsDetails[y]["format"] == "R":
                newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[2 + label_index].replace(",","")) ]
                newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[3 + label_index].replace(",", ""))]
                newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[1 + label_index].replace(",", ""))]
                newline[linecounter] = newline[linecounter] + "00000"
                newline[linecounter] = newline[linecounter] + functionsDetails[y]["funct"]

            elif functionsDetails[y]["format"] == "I":
                if functionsDetails[y]["name"] == "addi" or functionsDetails[y]["name"] == "ori":
                    newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[2 + label_index].replace(",", ""))]
                    newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[1 + label_index].replace(",", ""))]
                    newline[linecounter] = newline[linecounter] + bin_digits(splitted[3 + label_index].replace(",", ""), 16)

                elif functionsDetails[y]["name"] == "sw" or functionsDetails[y]["name"] == "lw":
                    newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[3 + label_index].replace(",", ""))]
                    newline[linecounter] = newline[linecounter] + registers_index[registers.index(splitted[1 + label_index].replace(",", ""))]
                    newline[linecounter] = newline[linecounter] + bin_digits(splitted[2 + label_index].replace(",", ""), 16)
            if linecounter != (len(commands) - 1 ):
                newline[linecounter] = newline[linecounter] + "\n"
            linecounter = linecounter + 1
    except:
        print("Intruction Not Supported")
        print("Supported Instructions :")
        for i in functionsDetails:
            print("     ",i["name"])
    newfile = open("output.txt","w+")
    for line in newline:
        newfile.write(line)
    newfile.close()
    f.close()
    return 0

Assembler("../test.txt")
