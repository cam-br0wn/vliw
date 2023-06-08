# This is a primitive RISC-V assembly to hex-file converter
# This is not meant to serve as anything other than a testing tool
# Note that it does not check for architecture-compliant assembly, it's just a parser

# IMPORTANT: run this from the test directory! (for correct file referencing)
# This parser uses spaces to split
# Thus, all instructions should have format: 
# R-type: inst rd rs1 rs2
# I-type: inst rd rs1 imm
# S-type: inst rs2 rs1 offset
# B-type: inst rs1 rs2 offset
# J-type: inst rd offset
import sys

def int_to_bin(value, bit_width):
    if value < 0:
        value = (1 << bit_width) + value
    format_string = '{:0' + str(bit_width) + 'b}'
    return format_string.format(value)

def hex_to_bin(hex_str, length):
    bin_str = ''
    for i in range(len(hex_str)):
        bin_str = bin_str + format(int(hex_str[i], 16), '04b')
    return bin_str.zfill(length)

def bin_to_hex(bin_str):
    return format(int(bin_str, 2), '08x')

def parse(line):
    # remove the new-line and split on spaces
    line_arr = line[:len(line)-1].split(' ')
    is_hex = [False] * len(line_arr)
    inst_str = line_arr[0].lower()
    for i in range(1, len(line_arr)):
        if (line_arr[i][0:2] == '0x'):
            is_hex[i] = True
            line_arr[i] = line_arr[i][2:]
        else:
            line_arr[i] = line_arr[i].strip('x')
    
    if inst_str == 'nop':
        bits = '00000000000000000000000000000000'
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'add':
        funct7 = '0000000'
        funct3 = '000'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'sub':
        funct7 = '0100000'
        funct3 = '000'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'xor':
        funct7 = '0000000'
        funct3 = '100'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'or':
        funct7 = '0000000'
        funct3 = '110'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'and':
        funct7 = '0000000'
        funct3 = '111'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'sll':
        funct7 = '0000000'
        funct3 = '001'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'srl':
        funct7 = '0000000'
        funct3 = '101'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'sra':
        funct7 = '0100000'
        funct3 = '101'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'slt':
        funct7 = '0000000'
        funct3 = '010'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'sltu':
        funct7 = '0000000'
        funct3 = '011'
        opcode = '0110011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        rs2 = int_to_bin(int(line_arr[3]), 5)
        bits = funct7 + rs2 + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'addi':
        funct3 = '000'
        opcode = '0010011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'xori':
        funct3 = '100'
        opcode = '0010011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'ori':
        funct3 = '110'
        opcode = '0010011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'andi':
        funct3 = '111'
        opcode = '0010011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'slli':
        funct3 = '001'
        opcode = '0010011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        shtyp = '0000000'
        if is_hex[3]:
            shamt = hex_to_bin(line_arr[3], 5)
        else:
            shamt = int_to_bin(int(line_arr[3]), 5)
        bits = shtyp + shamt + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'srli':
        funct3 = '101'
        opcode = '0010011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        shtyp = '0000000'
        if is_hex[3]:
            shamt = hex_to_bin(line_arr[3], 5)
        else:
            shamt = int_to_bin(int(line_arr[3]), 5)
        bits = shtyp + shamt + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'srai':
        funct3 = '101'
        opcode = '0010011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        shtyp = '0100000'
        if is_hex[3]:
            shamt = hex_to_bin(line_arr[3], 5)
        else:
            shamt = int_to_bin(int(line_arr[3]), 5)
        bits = shtyp + shamt + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'slti':
        funct3 = '010'
        opcode = '0010011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'sltiu':
        funct3 = '011'
        opcode = '0010011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'lb':
        funct3 = '000'
        opcode = '0000011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    
    elif inst_str == 'lh':
        funct3 = '001'
        opcode = '0000011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)

    
    elif inst_str == 'lw':
        funct3 = '010'
        opcode = '0000011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'lbu':
        funct3 = '100'
        opcode = '0000011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'lhu':
        funct3 = '101'
        opcode = '0000011'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'sb':
        funct3 = '000'
        opcode = '0100011'
        rs2 = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm[0:7] + rs2 + rs1 + funct3 + imm[7:12] + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'sh':
        funct3 = '001'
        opcode = '0100011'
        rs2 = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm[0:7] + rs2 + rs1 + funct3 + imm[7:12] + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'sw':
        funct3 = '010'
        opcode = '0100011'
        rs2 = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm[0:7] + rs2 + rs1 + funct3 + imm[7:12] + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'beq':
        funct3 = '000'
        opcode = '1100011'
        rs1 = int_to_bin(int(line_arr[1]), 5)
        rs2 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        # have to divide by 16 via a sign-ext bit shift
        imm = imm[0] + imm[0] + imm[0] + imm[0] + imm[0:8]
        # SV: 12 11 10 09 08 07 06 05 04 03 02 01
        # py: 00 01 02 03 04 05 06 07 08 09 10 11
        bits = imm[0] + imm[2:8] + rs2 + rs1 + funct3 + imm[8:12] + imm[1] + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'bne':
        funct3 = '001'
        opcode = '1100011'
        rs1 = int_to_bin(int(line_arr[1]), 5)
        rs2 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        # have to divide by 16 via a sign-ext bit shift
        imm = imm[0] + imm[0] + imm[0] + imm[0] + imm[0:8]
        bits = imm[0] + imm[2:8] + rs2 + rs1 + funct3 + imm[8:12] + imm[1] + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'blt':
        funct3 = '100'
        opcode = '1100011'
        rs1 = int_to_bin(int(line_arr[1]), 5)
        rs2 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        # have to divide by 16 via a sign-ext bit shift
        imm = imm[0] + imm[0] + imm[0] + imm[0] + imm[0:8]
        bits = imm[0] + imm[2:8] + rs2 + rs1 + funct3 + imm[8:12] + imm[1] + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'bge':
        funct3 = '101'
        opcode = '1100011'
        rs1 = int_to_bin(int(line_arr[1]), 5)
        rs2 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        # have to divide by 16 via a sign-ext bit shift
        imm = imm[0] + imm[0] + imm[0] + imm[0] + imm[0:8]
        bits = imm[0] + imm[2:8] + rs2 + rs1 + funct3 + imm[8:12] + imm[1] + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'bltu':
        funct3 = '110'
        opcode = '1100011'
        rs1 = int_to_bin(int(line_arr[1]), 5)
        rs2 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        # have to divide by 16 via a sign-ext bit shift
        imm = imm[0] + imm[0] + imm[0] + imm[0] + imm[0:8]
        bits = imm[0] + imm[2:8] + rs2 + rs1 + funct3 + imm[8:12] + imm[1] + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'bgeu':
        funct3 = '111'
        opcode = '1100011'
        rs1 = int_to_bin(int(line_arr[1]), 5)
        rs2 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        # have to divide by 16 via a sign-ext bit shift
        imm = imm[0] + imm[0] + imm[0] + imm[0] + imm[0:8]
        bits = imm[0] + imm[2:8] + rs2 + rs1 + funct3 + imm[8:12] + imm[1] + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'jal':
        opcode = '1101111'
        rd = int_to_bin(int(line_arr[1]), 5)
        if is_hex[2]:
            imm = hex_to_bin(line_arr[2], 20)
        else:
            imm = int_to_bin(int(line_arr[2]), 20)
        imm = imm[0] + imm[0] + imm[0] + imm[0] + imm[0:16]
        bits = imm[0] + imm[10:20] + imm[9] + imm[1:9] + rd + opcode
        # SV: 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01
        # py: 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    elif inst_str == 'jalr':
        funct3 = '000'
        opcode = '1100111'
        rd = int_to_bin(int(line_arr[1]), 5)
        rs1 = int_to_bin(int(line_arr[2]), 5)
        if is_hex[3]:
            imm = hex_to_bin(line_arr[3], 12)
        else:
            imm = int_to_bin(int(line_arr[3]), 12)
        bits = imm + rs1 + funct3 + rd + opcode
        assert len(bits) == 32
        return bin_to_hex(bits)
    
    else:
        raise ValueError("Could not determine the instruction: " + inst_str)

def main():

    # assembly input file
    asm_file = open(sys.argv[1], "r")
    # hex output file
    hex_file_name = sys.argv[1].split('.')[0].split('/')[1]
    # print(hex_file_name)
    hex_file = open('bin/' + hex_file_name + '.hex', 'w')

    hex_file.write(format(0, '08x') + ' / ' + format(0, '08x') + ';\n')
    mem_addr = 4
    data_section_entered = False
    mem_lines = 1

    for line in asm_file.readlines():
        if line == '\n':
            continue
        elif line == '.DATA\n':
            data_section_entered = True
            continue

        if not data_section_entered:
            hex_file.write(format(mem_addr, '08x') + ' / ' + str(parse(line)) + ';\n')
        else:
            if line[0:2] == '0x':
                hex_file.write(format(mem_addr, '08x') + ' / ' + line[2:len(line)-1].zfill(8) + ';\n')
            else:
                hex_file.write(format(mem_addr, '08x') + ' / ' + format(int(line[:len(line)-1]), '08x') + ';\n')
        mem_addr += 4
        mem_lines += 1


    asm_file.close()
    hex_file.close()
    print("There are " + str(mem_lines) + " lines of RAM required to run this program.")
    return

if __name__ == '__main__':
    main()
