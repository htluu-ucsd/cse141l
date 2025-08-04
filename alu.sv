// combinational -- no clock
// sample -- change as desired
module alu(
  input[3:0] instruction,    // 4-bit ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide datapath
  input direction,
  input use_carry,
  input carry_in_shift,       //doubles as carry in and shift flag
  
  output logic[7:0] data_out, //for moving values between registers
  output logic[1:0] compareFlag, //11: no compare, 10: A = B, 01: A > B, 00: A < B
  output logic carry_out     // shift_carry out
);

always_comb begin
  carry_out = 0;
  if (instruction == 7) compareFlag = {inA == inB, (inA - inB) > 0};
  else compareFlag = 2'b11;

  case(instruction)
    0: data_out = inA & inB; //bitwise and
    1: data_out = inA | inB; //bitwise or
    2: {carry_out, data_out} = inA + inB + carry_in_shift; // add 2 8-bit unsigned; automatically makes carry-out
    3: {carry_out, data_out} = inA - inB + carry_in_shift;
    4: {carry_out, data_out} = inA + inB + carry_in_shift; //add with intermediate
    5: data_out = inB; // copy data in from 2nd reg (mov3 ff sss)
    6: data_out = inA; // copy data in from 1st reg (mov3 ff sss)
    // 7: data_out = '1; // cmp result
    8: begin //shift by 1, high for left shift
      if (direction) {carry_out, data_out} = {inB, use_carry ? carry_in_shift : 1'b0};
      else {data_out, carry_out} = {use_carry ? carry_in_shift : 1'b0, inB};
    end
    9: data_out = inB;
    10: data_out = inB;
    11: data_out = inB;
    12: data_out = inB;
    13: data_out = inB; //store
    // 14: // load
    // 15: // halt
    default: data_out = '1;

  endcase
end
   
endmodule