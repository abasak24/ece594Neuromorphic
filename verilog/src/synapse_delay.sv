// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module synapse_delay #(WEIGHT)
( input spike_to_delay
, output spike_out
, input clk
, input reset
);
// --------------------------------------------------------------------
// synthesis translate_off
  initial
  begin
    assert(WEIGHT > 1) else $fatal;
  end
// synthesis translate_on
// --------------------------------------------------------------------

  // --------------------------------------------------------------------

  // --------------------------------------------------------------------
  enum reg [1:0]
    { IDLE = 2'b01,
      WAIT = 2'b10
    } state, next_state;

  // --------------------------------------------------------------------
  always_ff @(posedge clk)
    if(reset)
      state <= IDLE;
    else
      state <= next_state;

  // --------------------------------------------------------------------
  wire counter_done;
  
  always_comb
    case(state)
      IDLE:    if(spike_to_delay)
                 next_state <= WAIT;
               else
                 next_state <= IDLE;
               
      WAIT:    if(counter_done)
                 next_state <= IDLE;
               else
                 next_state <= WAIT;
                              
      default: next_state <= IDLE;
    endcase
  
  // --------------------------------------------------------------------
  reg [$clog2(WEIGHT)-1:0] counter;
  assign counter_done = (counter <= 0);

  always_ff @(posedge clk)
    if(state == IDLE)
      counter <= WEIGHT - 2;
    else if((state == WAIT) & ~counter_done)
      counter <= counter - 1;

  // --------------------------------------------------------------------
  assign spike_out = (state == WAIT) & (next_state == IDLE);
  
// --------------------------------------------------------------------
endmodule
