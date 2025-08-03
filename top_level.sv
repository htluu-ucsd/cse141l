// sample top level design
module top_level(
  input clk,
        start,
        reset,
  output logic done);
  parameter D = 12,              // program counter width
            A = 4;               // ALU command bit width
  wire[D-1:0] target, 			     // jump
              offset,
              prog_ctr;
  wire[7:0]   datA, datB,		     // from RegFile
              mux_reg_store,
              muxB,
			        rslt,              // alu output
              dat_out;
  logic       sc_in,
              sc_o;   				   // shift/carry out from/to ALU
  wire        GenRegWrite,
              branch_en,              // from control to PC; relative jump enable
              branch_type,
              direction,
              // sc_en,
              MemWrite,
              MemToReg,
              halt,
              Reg0Write;
  wire[A-1:0] inst_cmd;
  wire[8:0]   mach_code;         // machine code
  wire[3:0]   rd_addrA, rd_addrB, wr_a_or_b, wr_addr; // address pointers to reg_file
  logic[1:0]  compareFlag;

  always @(posedge clk) begin
    if (reset | start) begin
      sc_in <= 0;
    end
    else begin
      sc_in <= sc_o;
    end
  end

// contains machine code
  instr_ROM ir1(.prog_ctr,
                .mach_code);

  //break instruction format
  assign inst_cmd = mach_code[8:5];
  assign rd_addrA = mach_code[4:3];
  assign rd_addrB = mach_code[2:0];

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D)) pl1(.addr(rd_addrB),
                      .target(target));

// control decoder
  Control ctl1(.Inst(mach_code),
               .compareFlag(compareFlag),
               .Reg0Write(Reg0Write),
               .GenPurpRegWrite(GenRegWrite),
               .WriteMem(MemWrite),
               .Branch(branch_en),
               .MemToReg(MemToReg),
               .Halt(halt));

  assign wr_a_or_b = (inst_cmd == 'b0101) ? rd_addrA : rd_addrB; //mov2 writes to 2nd arg
  assign wr_addr = Reg0Write ? '0 : wr_a_or_b;

  assign direction = mach_code[3];
  assign branch_type = mach_code[4];
  assign offset = branch_type ? target : datB; // branching

// fetch subassembly
  PC #(.D(D)) pc1(.start,
                  .reset, 		   // D sets program counter width
                  .clk,
                  .jump_en(branch_en),
                  .direction,
                  .target(offset),
                  .prog_ctr);

  assign mux_reg_store = ('b1110 == inst_cmd) ? dat_out : rslt;

  reg_file #(.pw(4)) rf1(.dat_in  (mux_reg_store),	 // loads, most ops
                         .clk,
                         .wr_en   (Reg0Write | GenRegWrite),
                         .wr_addr (wr_addr),      // in place operation
                         .rd_addrA(rd_addrA),
                         .rd_addrB(rd_addrB),
                         .datA_out(datA),
                         .datB_out(datB)); 

  assign muxB = (inst_cmd == 'b0100) ? {'0, rd_addrB} : datB; //for addi, immediate addition

  alu alu1(.instruction   (inst_cmd),
           .inA           (datA),
           .inB           (muxB),
           .direction(mach_code[4]),
           .use_carry(mach_code[3]),
           .carry_in_shift(sc_in),   // output from sc register
           .data_out      (rslt),
           .compareFlag,
           .carry_out     (sc_o)); // input to sc register  

  data_mem data_mem1(.dat_in(rslt),  // from reg_file
              .clk(clk),
              .wr_en (MemWrite), // stores
              .addr  ({4'b0, rd_addrB} + 8'd8), //offset by 8 for program 3
              .dat_out(dat_out));

// registered flags from ALU
  // always_ff @(posedge clk) begin
  //   if (sc_clr) sc_in <= 'b0;
  //   else sc_in <= sc_o;
  // end

  assign done = halt;
 
endmodule