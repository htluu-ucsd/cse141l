// combinational -- no clock
// sample -- change as desired
module alu(
  input[3:0] instruction,    // 4-bit ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide datapath
  input[2:0] immediate; //for immediate addition
  input      sc_i,       // shift flag ???????????????????????
  
  output logic[7:0] data_out, //for moving values between registers
  output logic[3:0] regs, //for specifying where to store
  output logic[1:0] compareFlag, //11: no compare, 10: A = B, 01: A > B, 00: A < B
  output logic carry_out,     // shift_carry out
               halt,
);

always_comb begin
  halt = 0;
  compareFlag = 2'b11;

  case(instruction)
    0: data_out = inA & inB; //bitwise and
    1: data_out = inA | inB; //bitwise or
    2: {carry_out, data_out} = inA + inB + sc_i; // add 2 8-bit unsigned; automatically makes carry-out
    3: {carry_out, data_out} = inA - inB + sc_i;
    4: {carry_out, data_out} = inA + immediate + sc_i; //add with intermediate
    5: data_out = dataA; // copy data in 
    6: data_out = dataA; // copy data in
    7: begin
      data_out = '1;
      compareFlag = {dataA == dataB, (dataA - dataB) > 0}; //compare dataA with dataB
    end
    8: {carry_out, data_out} = {inA, sc_i ? {dataA, 0} : {0, dataA}}; // shift by 1 only?
    // 9: // branch
    // 10: // beq
    // 11: // bgt
    // 12: // blt
    13: data_out = dataA;
    // 14: // load
    15: {halt, data_out} = '1; // halt
    default:
      data_out = '1;

  endcase
end
   
endmodule