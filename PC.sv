// program counter
// supports both relative jumps
module PC #(parameter D=12)(
  input start,
        reset,					// synchronous reset
        clk,
        direction,
		    jump_en,             // rel. jump enable
  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);

  always_ff @(posedge clk)
    if (reset | start) prog_ctr <= '0;
	  else if (jump_en) prog_ctr <= direction ? (prog_ctr + target) : (prog_ctr - target);
	  else prog_ctr <= prog_ctr + 12'b1;

endmodule