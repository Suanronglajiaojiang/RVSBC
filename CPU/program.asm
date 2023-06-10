//内存0x00的数作为判断计算类型的变量 
//有: 1代表+   2代表-  3代表*  4代表/  除此之外代表空操作
//内存0x04的数为被操作数 一般固定赋值给x3
//内存0x08的数为操作数 一般固定赋值给x4
//内存0x0c的数为结果 一般固定赋值给x5
//使用的寄存器限制为x1 ~ x7，注意如果遇到beq语句应
//留意参与判断的参数初始状态是否确定

// all the available asm instructions:

// add rd, rs1, rs2    | add           | rd = rs1 + rs2
// addi rd, rs1, imm   | add immediate | rd = rs1 + SignExt(imm)
// beq rs1, rs2, label | branch if =   | if (rs1 == rs2) PC = BTA
// jal rd, label       | jump and link | PC = JTA, rd = PC + 4
// lw rd, imm(rs1)     | load word     | rd = [Address]31:0
// slt rd, rs1, rs2    | set less than | rd = (rs1 < rs2)
// sub rd, rs1, rs2    | sub           | rd = rs1 — rs2
// sw rs2, imm(rs1)    | store word    | [Address]31:0 = rs2

//---------------------------------------------------------------
//初始化
reset:
addi	x1 x0 0
addi	x2 x0 0
addi	x3 x0 0
addi	x4 x0 0
addi	x5 x0 0
addi	x6 x0 0
addi	x7 x0 0

//---------------------------------------------------------------
//控制模块
control:
lw	x1 20(x0)	
addi	x2 x0 1		//x2作为裁决数
beq 	x1 x2 plus
addi	x2 x0 2
beq	x1 x2 minus
addi	x2 x0 3
beq 	x1 x2 mul
addi	x2 x0 4
beq	x1 x2 div
jal	x7 convertStart

//---------------------------------------------------------------
//加法
plus:
lw	x3 4(x0)
lw	x4 8(x0)
add	x5 x3 x4
sw	x5 12(x0)
addi	x1 x0 0
sw	x1 0(x0)
jal	x7 control

//---------------------------------------------------------------
//减法
minus:
lw	x3 4(x0)
lw	x4 8(x0)
sub	x5 x3 x4		//注意x3为被减数
sw	x5 12(x0)
addi	x1 x0 0
sw	x1 0(x0)
jal	x7 control

//---------------------------------------------------------------
//软件乘法
mul:
lw	x3 4(x0)		
lw	x4 8(x0)
addi	x6 x0 0		//x6计数值初始为0

mulin:
beq	x6 x3 mulout	// x6 == x3 时跳出到out处,x3应小于x4
add	x5 x5 x4		// x5 加 10
addi	x6 x6 1		//判断值自加
jal	x7 mulin
		
mulout:
sw	x5  12(x0)		
addi	x1 x0 0		
sw	x1 0(x0)	
jal	x7 control	

//---------------------------------------------------------------
//软件除法
div:
lw	x3 4(x0)		
lw	x4 8(x0)
addi	x5 x0 0		//x5计数值初始为0
addi	x6 x0 1		//x6初始为1，用于slt

divin:
sub	x3 x3 x4
slt	x1 x3 x0
beq	x1 x6 divout
addi	x5 x5 1
jal	x7 divin	

divout:
sw	x5  12(x0)	
addi	x1 x0 0
sw	x1 0(x0)
jal	x7 control



//---------------------------------------------------------------
//循环（防止意外跳转）
// done:
// beq	x7 x7 done


// binary to 8421BCD converter
convertStart:
addi x1 x0 1
addi x2 x0 10
lw x3 12(x0)
addi x4 x0 0
jal x5 lessThanTenBranch

lessThanTenBranch:
slt x6 x3 x2
beq x6 x1 sendASCII
sub x3 x3 x2
addi x4 x4 1
jal x5 lessThanTenBranch


sendASCII:
addi x3 x3 5376 // extend BCD to ASCII length and add color (+16'h1500)
sw x3 0(x0)
beq x4 x0 convertDone
add x3 x4 x0
addi x4 x0 0
jal x5 lessThanTenBranch


convertDone:
addi x0 x0 0
jal x5 convertDone
