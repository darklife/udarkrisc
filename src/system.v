`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:21:40 02/14/2015
// Design Name:   core
// Module Name:   Z:/Users/marcelo/Documents/Verilog/RISCv2/src/system.v
// Project Name:  RISCv2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module system;

	// Inputs
	reg CLK;
	reg RES;

	// Outputs
	wire        RD;
	wire        WR;
	wire [15:0] ADDR;

	// Bidirs
	wire [15:0] DATA;

	// Instantiate the Unit Under Test (UUT)
	core uut (
		.CLK(CLK), 
		.RES(RES), 
		.RD(RD), 
		.WR(WR), 
		.ADDR(ADDR), 
		.DATA(DATA)
	);

    reg [15:0] RAM [0:15];
    
    reg [15:0] DATAO = 0;

    integer j;

    initial
    begin
        for(j=0;j!=16;j=j+1)
        begin
            RAM[j] = j;
        end
    end

    reg [3:0] RPTR = 0;
    reg [3:0] XPTR = 0;

    assign DATA = RD ? DATAO : 16'hzzzz;

    always@(posedge CLK)
    begin
        DATAO <= RAM[RPTR];
        if(RD)
        begin
            RPTR <= RPTR+1;
        end
        
        if(WR)
        begin
            RAM[XPTR] <= DATA;
            XPTR <= XPTR+1;
        end
    end
    
    integer i;

	initial begin
		// Initialize Inputs
		CLK = 0;
		RES = 0;

        for(i=0;i!=10000;i=i+1)
        begin
            #10 CLK = !CLK;
            if(i>10)
            begin
                RES = 1;
            end
        end 
	end
      
endmodule
