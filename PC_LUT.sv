// populate as desired for each of the programs
//always positive values as direction is handled in PC
module PC_LUT #(parameter D=12)(
  input       [ 2:0] addr,	   // target 8 values
  output logic[D-1:0] target);

  always_comb case(addr)
    0: target = 'd7; //NOSWAP
    1: target = 'd6; //WHILE
    2: target = 'd6; //AFTERWHILE
    3: target = 'd8; //AFTERNORMALIZE
	default: target = 'd0;  // hold PC  
  endcase

endmodule