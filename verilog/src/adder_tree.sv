//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2019 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

module adder_tree #(N, W, A = ($clog2(N) > 0) ? $clog2(N) : 1)
  ( input   [W-1:0] data_in[N]
  , output  [W+A-1:0] data_out
  );
// --------------------------------------------------------------------
// synthesis translate_off
  initial begin
    assert(N > 0) else $fatal;
  end
// synthesis translate_on
// --------------------------------------------------------------------

  // --------------------------------------------------------------------
  localparam H = 2 ** (A - 1); // half of ceil(number of inputs)
  localparam R = N - H;        // upper remainder

  // --------------------------------------------------------------------
  generate
    if(N == 1) begin : one
      assign data_out = data_in[0];
    end
    else if(A == 1) begin : bottom
      assign data_out = data_in[1] + data_in[0];
    end
    else begin : branch
      wire [W+A-2:0] data_out_lo, data_out_hi;

      adder_tree #(.N(H), .W(W)) lo(data_in[0:H-1], data_out_lo);

      if(R == 1)
        assign data_out_hi = {1'b0, data_in[N-1]};
      else if(R == 2)
        assign data_out_hi = {1'b0, data_in[N-1]} + {1'b0, data_in[N-2]};
      else
        adder_tree #(.N(R), .W(W)) hi(data_in[H:N-1], data_out_hi);

      assign data_out = data_out_hi + data_out_lo;
    end
  endgenerate

// --------------------------------------------------------------------
endmodule
