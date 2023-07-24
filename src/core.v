`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:23:48 02/14/2015 
// Design Name: 
// Module Name:    core 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`define ROR 4'd0
`define ROL 4'd1
`define ADD 4'd2
`define SUB 4'd3
`define AND 4'd4
`define OR  4'd5
`define XOR 4'd6
`define NOT 4'd7
`define LOD 4'd8
`define STO 4'd9
`define IMM 4'd10
`define MUL 4'd11
`define BRA 4'd12
`define BSR 4'd13
`define RET 4'd14
`define LOP 4'd15

module core(
    input               CLK,
    input               RES,
    output              RD,
    output              WR,
    output      [15:0]  ADDR,
    inout       [15:0]  DATA
    );

    wire        [15:0]  IDATA;

    wire        [ 3:0]  INST =    IDATA[15:12];
    wire        [ 3:0]  DPTR =    IDATA[11: 8];
    wire        [ 3:0]  SPTR =    IDATA[ 7: 4];
    wire        [ 3:0]  OPTS =    IDATA[ 3: 0];

    reg         [15:0]  PC;

    reg signed  [15:0]  REG [0:15];

    wire signed [15:0]  IMMS = { IDATA[7]?8'hff:8'h00, IDATA[7:0] };
    wire signed [15:0]  DREG = REG[DPTR];
    wire signed [15:0]  SREG = REG[SPTR];
    wire signed [15:0]  DMUX   [0:15]; 

    assign DMUX[`ROR] = SREG>>>OPTS;                  // dreg = sreg>>>opts
    assign DMUX[`ROL] = SREG<<<OPTS;                  // dreg = sreg<<<opts
    assign DMUX[`ADD] = (OPTS?DREG+OPTS:DREG+SREG);   // dreg = dreg+opts or dreg+sreg
    assign DMUX[`SUB] = (OPTS?DREG-OPTS:DREG-DREG);   // dreg = dreg-opts or dreg-sreg
    assign DMUX[`XOR] = DREG^SREG;                    // dreg = dreg xor sreg
    assign DMUX[`AND] = DREG&SREG;                    // dreg = dreg and sreg
    assign DMUX[ `OR] = DREG|SREG;                    // dreg = dreg or  sreg
    assign DMUX[`NOT] = ~DREG;                        // dreg = not dreg
    assign DMUX[`LOD] = DATA;                         // dreg = *sreg
    assign DMUX[`STO] = DREG;
    assign DMUX[`IMM] = IMMS;                         // dreg = imms
    assign DMUX[`MUL] = (DREG*SREG)>>>OPTS;           // dreg = (dreg*sreg)>>>opts
    assign DMUX[`BRA] = DREG;
    assign DMUX[`BSR] = PC+1;                         // dreg = pc+1, pc += imms
    assign DMUX[`RET] = DREG;
    assign DMUX[`LOP] = DREG-1;                       // dreg = dreg-1
    
    always@(posedge CLK)
    begin       
        REG[DPTR] <=    DMUX[INST];
        
        PC <=          !RES ? 0 : 
                 INST==`RET ? DREG : 
                              PC+(INST==`BSR||INST==`BRA||(INST==`LOP&&!DREG[15])?IMMS:1);
    end

    assign RD    = INST==`LOD;
    assign WR    = INST==`STO;
    assign DATA  = RD ? 16'hzzzz : DREG;
    assign ADDR  = SREG;

    rom rom(CLK,PC[9:0],IDATA);

endmodule
