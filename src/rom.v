module rom(input CLK, input [9:0] ADDR, output reg [15:0] DATA);

  reg [15:0] ROM [0:1023];

  integer i;

  initial
  begin
    for(i=0;i!=1024;i=i+1)
    begin
      ROM[i] = 0;
    end

    ROM[0] = 16'h0000;
    ROM[1] = 16'ha000;
    ROM[2] = 16'ha101;
    ROM[3] = 16'ha202;
    ROM[4] = 16'ha303;
    ROM[5] = 16'ha404;
    ROM[6] = 16'ha505;
    ROM[7] = 16'ha606;
    ROM[8] = 16'ha707;
    ROM[9] = 16'ha808;
    ROM[10] = 16'ha909;
    ROM[11] = 16'haa0a;
    ROM[12] = 16'hab0b;
    ROM[13] = 16'hac0c;
    ROM[14] = 16'had0d;
    ROM[15] = 16'hae0e;
    ROM[16] = 16'haf0f;
    ROM[17] = 16'h6880;
    ROM[18] = 16'h6010;
    ROM[19] = 16'h032d;
    ROM[20] = 16'ha408;
    ROM[21] = 16'h8720;
    ROM[22] = 16'h7700;
    ROM[23] = 16'h9720;
    ROM[24] = 16'hf4fc;
    ROM[25] = 16'h0000;
    ROM[26] = 16'h6020;
    ROM[27] = 16'hc0ff;
    ROM[28] = 16'h0000;
  end

  always@(posedge CLK) DATA <= ROM[ADDR];
endmodule
