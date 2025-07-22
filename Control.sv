// control decoder
module Control (
  input [8:0] Inst,
  output logic Reg0Write,         // write to accum. reg.
               GenPurpRegWrite,   // write to general purpose reg.
               WriteMem,          // write to data memory
               Branch,            // branch instruction, update pc
               MemToReg,          // select memory output to register
               Halt               // halt program
);

wire[3:0] Opcode;
assign Opcode = Inst[8:5]

always_comb begin
  case (opcode)

    // AND
    4'b0000: begin
      Reg0Write = 1;
      GenPurpRegWrite = 1;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // OR
    4'b0001: begin
      Reg0Write = 1;
      GenPurpRegWrite = 1;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // ADD
    4'b0010: begin
      Reg0Write = 1;
      GenPurpRegWrite = 1;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // SUB
    4'b0011: begin
      Reg0Write = 1;
      GenPurpRegWrite = 1;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // ADDI
    4'b0100: begin
      Reg0Write = 1;
      GenPurpRegWrite = 1;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // MOV3
    4'b0101: begin
      Reg0Write = 1;
      GenPurpRegWrite = 1;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // MOV2
    4'b0110: begin
      Reg0Write = 1;
      GenPurpRegWrite = 1;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // CMP
    4'b0111: begin
      Reg0Write = 0;
      GenPurpRegWrite = 0;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // SHIFT
    4'b1000: begin
      Reg0Write = 1;
      GenPurpRegWrite = 1;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // BEQ
    4'b1001: begin
      Reg0Write = 0;
      GenPurpRegWrite = 0;
      WriteMem = 0;
      Branch = 1;
      MemToReg = 0;
      Halt = 0;
    end

    // BGT
    4'b1010: begin
      Reg0Write = 0;
      GenPurpRegWrite = 0;
      WriteMem = 0;
      Branch = 1;
      MemToReg = 0;
      Halt = 0;
    end

    // BLT
    4'b1011: begin
      Reg0Write = 0;
      GenPurpRegWrite = 0;
      WriteMem = 0;
      Branch = 1;
      MemToReg = 0;
      Halt = 0;
    end

    // BRANCH
    4'b1100: begin
      Reg0Write = 0;
      GenPurpRegWrite = 0;
      WriteMem = 0;
      Branch = 1;
      MemToReg = 0;
      Halt = 0;
    end

    // STORE
    4'b1101: begin
      Reg0Write = 0;
      GenPurpRegWrite = 0;
      WriteMem = 1;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

    // LOAD
    4'b1110: begin
      Reg0Write = 1;
      GenPurpRegWrite = 1;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 1;
      Halt = 0;
    end

    // HALT
    4'b1111: begin
      Reg0Write = 0;
      GenPurpRegWrite = 0;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 1;
    end

    default: begin
      Reg0Write = 0;
      GenPurpRegWrite = 0;
      WriteMem = 0;
      Branch = 0;
      MemToReg = 0;
      Halt = 0;
    end

  endcase
end 
	
endmodule