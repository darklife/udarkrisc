start:
	nop

	imm     0  %d0
	imm	1  %d1
	imm 	2  %d2
	imm 	3  %d3
	imm     4  %d4
	imm	5  %d5
	imm 	6  %d6
	imm 	7  %d7
	imm     8  %d8
	imm	9  %d9
	imm 	10 %d10
	imm 	11 %d11
	imm     12 %d12
	imm	13 %d13
	imm 	14 %d14
	imm 	15 %d15

	clr     %d8
	xor 	%s1 %d0
	ror	%s2 %d3 13
	imm 	8 %d4
loop:
	lod	%p8 %d7
	not	%d7
	sto	%p8 %d7
	lop 	%d4 loop
	nop	

	xor	%d0 %d0

stop:
	bra stop
	nop
	