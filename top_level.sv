// sample top level design
module top_level(
  input clk,
        reset,
  output logic done);
  parameter D = 12,              // program counter width
            A = 4;               // ALU command bit width
  wire[D-1:0] target, 			     // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA, datB,		     // from RegFile
              muxB, 
			        rslt,              // alu output
              dat_out,
              immed;
  logic       sc_in;   				   // shift/carry out from/to ALU
  wire        relj,              // from control to PC; relative jump enable
              sc_clr,
              sc_en,
              MemWrite,
              MemToReg,
              halt;
              // ALUSrc;		         // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;         // machine code
  wire[2:0]   rd_addrA, rd_adrB; // address pointers to reg_file
  wire[1:0]   compareFlag;

// fetch subassembly
  PC #(.D(D)) pc1(.reset, 		   // D sets program counter width
                  .clk,
                  .reljump_en(relj), // .absjump_en(absj),
                  .target,
                  .prog_ctr);

// lookup table to facilitate jumps/branches
  // PC_LUT #(.D(D))
  //   pl1(.addr(how_high),
  //       .target);

// contains machine code
  instr_ROM ir1(.prog_ctr,
                .mach_code);

// control decoder
  Control ctl1(.Inst(mach_code),
               .Reg0Write(),
               .GenPurpRegWrite(),
               .WriteMem(MemWrite),
               .Branch(relj),
               .MemToReg(MemToReg),
               .Halt(halt));

  assign rd_addrA = mach_code[2:0];
  assign rd_addrB = mach_code[4:3];
  assign alu_cmd  = mach_code[8:5];

  reg_file #(.pw(4)) rf1(.dat_in  (dat_out),	 // loads, most ops
                         .clk,
                         .wr_en   (RegWrite),
                         .wr_addr (rd_addrA),      // in place operation
                         .rd_addrA(rd_addrA),
                         .rd_addrB(rd_addrB),
                         .datA_out(datA),
                         .datB_out(datB)); 

  // assign muxB = ALUSrc? immed : datB;

  alu alu1(.instruction   (alu_cmd),
           .inA           (datA),
           .inB           (datB),//(muxB),
           .immediate     (immed),
           .carry_in_shift(sc),   // output from sc register
           .data_out      (rslt),
           .compareFlag,
           .carry_out     (sc_o)); // input to sc register  

  dat_mem dm1(.dat_in(rslt),  // from reg_file
              .clk,
              .wr_en (MemWrite), // stores
              .addr  (datA),
              .dat_out);

// registered flags from ALU
  always_ff @(posedge clk) begin
    if (sc_clr) sc_in <= 'b0;
    else if (sc_en) sc_in <= sc_o;
  end

  assign done = prog_ctr == 128;
 
endmodule