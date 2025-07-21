// combinational -- no clock
// sample -- change as desired
module alu(
  input[3:0] instruction,    // 4-bit ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide datapath
  input[2:0] immediate; //for immediate addition
  input      sc_i,       // shift flag ???????????????????????
  output logic[7:0] accumulator,
  output logic[7:0] data, //for moving values between registers
  output logic[3:0] regs, //for specifying where to store
  output logic[1:0] compareFlag, //1X: A = B, 01: A > B, 00: A < B
  output logic carry_out,     // shift_carry out
  //              pari,     // reduction XOR (output)
	// 		         zero      // NOR (output)
);

always_comb begin 
  // accumulator = 'b0;
  // sc_o = 'b0;
  // zero = !accumulator;
  // pari = ^accumulator;

  case(instruction)
    0: accumulator = inA & inB; //bitwise and
    1: accumulator = inA | inB; //bitwise or
    2: {carry_out, accumulator} = inA + inB + sc_i; // add 2 8-bit unsigned; automatically makes carry-out
    3: {carry_out, accumulator} = inA - inB + sc_i;
    4: {carry_out, accumulator} = inA + immediate + sc_i; //add with intermediate
    5: data = dataA; //how to move between registers?
    6: //???
    7: compareFlag = {dataA == dataB, (dataA - dataB) > 0}; //compare dataA with dataB
    8: {carry_out, accumulator} = {inA, sc_i ? {dataA, 0} : {0, dataA}}; //shift 
    default:

    // 0: // add 2 8-bit unsigned; automatically makes carry-out
    //   {sc_o, accumulator} = inA + inB + sc_i;
    // 1: // left_shift
    //   {sc_o, accumulator} = {inA, sc_i};
    //     /*begin
    //   rslt[7:1] = ina[6:0];
    //   rslt[0]   = sc_i;
    //   sc_o      = ina[7];
    //     end*/
    // 2: // right shift (alternative syntax -- works like left shift
    //   {accumulator, sc_o} = {sc_i,inA};
    // 3: // bitwise XOR
    //   accumulator = inA ^ inB;
    // 4: // bitwise AND (mask)
    //   accumulator = inA & inB;
    // 5: // left rotate
    //   accumulator = {inA[6:0],inA[7]};
    // 6: // subtract
    //   {sc_o, accumulator} = inA - inB + sc_i;
    // 7: // pass A
    //   accumulator = inA;
  endcase
end
   
endmodule