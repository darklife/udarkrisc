#!/usr/bin/awk -f

BEGIN {

  for(i=0;i!=256;i++) NEG[i]=255-i;

  for(j=1;j!=ARGC;j++)
  {
    print "processing asm file " ARGV[j];
    
    FILE=ARGV[j];
    LINE=0;
    
    while(getline $0 < FILE)
    {
      if(NF)
      {
        if($0~/:/)
        {
          print "  label "$1" at line "LINE
          gsub(":","",$1); LABEL[$1]=LINE; RLABEL[LINE]=$1
        }
        else
        {
          print "  instr "$0" at line "LINE
          
          SRC[LINE]=$0

          for(i=2;i<=NF;i++)
          {
            if($i~/^%d/)
            {
              gsub("^%d","",$i); DREG=int($i); print "    DREG = "DREG
            }
            else
            if($i~/^%s/)
            {
              gsub("^%s","",$i); SREG=int($i); print "    SREG = "SREG
            }
            else
            {
              if(LABEL[$i])
              {
                if(LABEL[$i]>LINE) IMMX=(LABEL[$i]-LINE);
                else IMMX=NEG[LINE-LABEL[$i]];
                
                print "    IMMX = "IMMX" "LINE" to "LABEL[$i]
              }
              else
              {
                IMMS=int($i); print "    IMMS = "IMMS
              } 
            }
          }

          if($1=="ror") DST[LINE]=sprintf("%x%x%x%x",0 ,DREG,SREG,IMMS);
          if($1=="rol") DST[LINE]=sprintf("%x%x%x%x",1 ,DREG,SREG,IMMS);
          if($1=="add") DST[LINE]=sprintf("%x%x%x%x",2 ,DREG,SREG,IMMS);
          if($1=="sub") DST[LINE]=sprintf("%x%x%x%x",3 ,DREG,SREG,IMMS);
          if($1=="and") DST[LINE]=sprintf("%x%x%x%x",4 ,DREG,SREG,0);
          if($1=="or" ) DST[LINE]=sprintf("%x%x%x%x",5 ,DREG,SREG,0);
          if($1=="xor") DST[LINE]=sprintf("%x%x%x%x",6 ,DREG,SREG,0);
          if($1=="not") DST[LINE]=sprintf("%x%x%x%x",7 ,DREG,0,0);
          if($1=="lod") DST[LINE]=sprintf("%x%x%x%x",8 ,DREG,SREG,0);
          if($1=="sto") DST[LINE]=sprintf("%x%x%x%x",9 ,DREG,SREG,0);
          if($1=="imm") DST[LINE]=sprintf("%x%x%02x",10,DREG,IMMS);
          if($1=="mul") DST[LINE]=sprintf("%x%x%x%x",11,DREG,SREG,IMMS);
          if($1=="bra") DST[LINE]=sprintf("%x%x%02x",12,DREG,IMMX);
          if($1=="bsr") DST[LINE]=sprintf("%x%x%02x",13,DREG,IMMX);
          if($1=="ret") DST[LINE]=sprintf("%x%x%x%x",14,DREG,0,0);
          if($1=="lop") DST[LINE]=sprintf("%x%x%02x",15,DREG,IMMX);

          if($1=="nop") DST[LINE]=sprintf("%x%x%x%x",0 ,0,0,0);
          if($1=="mov") DST[LINE]=sprintf("%x%x%x%x",0 ,DREG,SREG,0);
          if($1=="inc") DST[LINE]=sprintf("%x%x%x%x",2 ,DREG,0,1);
          if($1=="dec") DST[LINE]=sprintf("%x%x%x%x",3 ,DREG,0,1);
          if($1=="clr") DST[LINE]=sprintf("%x%x%x%x",6 ,DREG,DREG,0);

          print "    CODE = " DST[LINE];

          LINE++;
        }
      }
    } 
    close(FILE);

    VFILE=FILE;
    gsub(".asm",".v",VFILE);

    print ""
    print "  processed code is from "FILE" to "VFILE":"
    print ""

    print "module rom(input CLK, input [9:0] ADDR, output reg [15:0] DATA);" > VFILE
    print "" > VFILE
    print "  reg [15:0] ROM [0:1023];" > VFILE
    print "" > VFILE
    print "  integer i;" > VFILE
    print "" > VFILE    
    print "  initial" > VFILE
    print "  begin" > VFILE
    print "    for(i=0;i!=1024;i=i+1)" > VFILE
    print "    begin" > VFILE
    print "      ROM[i] = 0;" > VFILE
    print "    end" > VFILE
    print "" > VFILE
    
    for(i=0;i!=1024;i++)
    {
      if(DST[i])
      {
        printf("  %04d:%s %20s %s\n",i,DST[i],RLABEL[i],SRC[i]);
        print "    ROM["i"] = 16'h"DST[i]";" > VFILE
      }
    }
    
    print "  end" > VFILE
    print "" > VFILE
    print "  always@(posedge CLK) DATA <= ROM[ADDR];" > VFILE
    print "endmodule" > VFILE
    
    close(VFILE)

    print "done."
  }
}
