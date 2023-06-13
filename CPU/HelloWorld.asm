addi x1 x0 0
addi x2 x0 32
addi x3 x0 128
addi x4 x0 200
addi x8 x0 0
addi x10 x0 1792
addi x10 x10 1792
addi x10 x10 1792 //x10 = 0x1500, for display color
addi x6 x0 1000
add x6 x6 x6
add x6 x6 x6
add x6 x6 x6
add x6 x6 x6
add x6 x6 x6
add x6 x6 x6
add x6 x6 x6
add x6 x6 x6
add x6 x6 x6

print:
addi x7 x0 0
add x8 x2 x10
sw x8 256(x1)
addi x1 x1 4
addi x2 x2 1
beq x2 x3 clearASCII
beq x1 x4 clearPos
jal x5 NOP

clearASCII:
addi x2 x0 32
jal x5 print

clearPos:
addi x1 x0 0
jal x5 print

NOP:
addi x0 x0 0
addi x7 x7 1
beq x7 x6 print
jal x5 NOP

done:
beq	x9 x9 done