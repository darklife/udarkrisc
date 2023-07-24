`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:56 02/14/2015 
// Design Name: 
// Module Name:    soc 
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

module soc(
    input               CLK,
    input               RES,
    input      [11:0]   IN0,
    input      [11:0]   IN1,
    input      [11:0]   IN2,
    input      [11:0]   IN3,
    output reg [11:0]   OUT0 = 0,
    output reg [11:0]   OUT1 = 0,
    output reg [11:0]   OUT2 = 0,
    output reg [11:0]   OUT3 = 0
    );

    wire [15:0] ADDR0;
    wire [15:0] DATA0;
    wire RD0,WR0;

    core core0(
        .CLK(CLK),
        .RES(RES),
        .RD(RD0),
        .WR(WR0),
        .ADDR(ADDR0),
        .DATA(DATA0)
    );

    wire [15:0] ADDR1;
    wire [15:0] DATA1;
    wire RD1,WR1;

    core core1(
        .CLK(CLK),
        .RES(RES),
        .RD(RD1),
        .WR(WR1),
        .ADDR(ADDR1),
        .DATA(DATA1)
    );

    wire [15:0] ADDR2;
    wire [15:0] DATA2;
    wire RD2,WR2;

    core core2(
        .CLK(CLK),
        .RES(RES),
        .RD(RD2),
        .WR(WR2),
        .ADDR(ADDR2),
        .DATA(DATA2)
    );

    wire [15:0] ADDR3;
    wire [15:0] DATA3;
    wire RD3,WR3;

    core core3(
        .CLK(CLK),
        .RES(RES),
        .RD(RD3),
        .WR(WR3),
        .ADDR(ADDR3),
        .DATA(DATA3)
    );

    always@(posedge CLK)
    begin
        if(WR0) OUT0 = DATA0;
        if(WR1) OUT1 = DATA1;
        if(WR2) OUT2 = DATA2;
        if(WR3) OUT3 = DATA3;
    end

    assign DATA0 = RD0 ? IN0 : 16'hzzzz;
    assign DATA1 = RD1 ? IN1 : 16'hzzzz;
    assign DATA2 = RD2 ? IN2 : 16'hzzzz;
    assign DATA3 = RD3 ? IN3 : 16'hzzzz;

endmodule
