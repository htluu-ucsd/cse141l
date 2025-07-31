// populate as desired for each of the programs
//always positive values as direction is handled in PC
module PC_LUT #(parameter D=12)(
  input       [ 2:0] addr,	   // target 8 values
  output logic[D-1:0] target);

  always_comb case(addr)
    0: target = 5;
	1: target = 20;
	2: target = '1;
	default: target = 'b0;  // hold PC  
  endcase

endmodule