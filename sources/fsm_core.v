/////////////////////////////////////////////////////////////////
// Name File          : fsm_core.v                             //
// Autor              : Maksim                                 //
// Company            :                                        //
// Description        : FSM for test_fx3 project               //
// Start design       : 12.08.19                               //
// Last revision      : 26.08.19                               //
/////////////////////////////////////////////////////////////////
     
`timescale 1ns / 100 ps

module fsm_core #(parameter DATA_OUT_VALUE=65535) (                            // These parameters can be overridden, data out value on data_out port
  input wire        clk,                                                       // clock      
  input wire        arst,                                                      // asynchronous reset
  input wire        ack,                                                       // acknowledgement signal
  input wire        ena,                                                       // enable signal
  input wire [22:0] data_in,                                                   // data on the bus

  output reg        intr,                                                      // introduce signal 
  output reg        specreg,                                                   // special register for compare task, "0"-pass, "1"-fail
  output reg        stop,                                                      // stop flag, all processes in FSM is over
  output reg [22:0] data_out                                                   // data out on the bus 
  );

//***************************************************************************
// Parameter definitions
//***************************************************************************                    
  localparam [3:0] IDLE_S=4'd0, LOAD_S=4'd1, WAIT_S=4'd2, COMPARE_S=4'd3;         // symbolic state declaration

//***************************************************************************
// Reg declarations
//***************************************************************************
  reg [3:0] state_reg, state_next;                                                 // signal declaration FSM
                                                              
//***************************************************************************
// Wire declarations
//***************************************************************************
  

//***************************************************************************
// Code
//***************************************************************************
  always @(negedge clk or negedge arst) 
    begin 
      if (arst)
        begin
          state_reg  <= IDLE_S;                                                   // realisation transition in state IDLE                                                      
	end
      else
        begin 
          state_reg <= state_next;                                                // state register
	end
    end // always
        
  always @(state_reg or ack or ena or data_in)                                    // next-state logic and output logic
    begin
       state_next <= state_reg; 

      case (state_reg)
    IDLE_S: begin                                                                 // default state 
              stop     <= 1'd0;
	      intr     <= 1'd0;
	      specreg  <= 1'd1;
	      data_out <= 23'd0;

              if (ena)
	        state_next <= LOAD_S;
	      else 
	        state_next <= IDLE_S;
	    end

    LOAD_S: begin
              data_out <= DATA_OUT_VALUE;
	      intr     <= 1'd1;
              stop     <= 1'd0;
              specreg  <= 1'd1;
	      
	      state_next <= WAIT_S;    
	     end

    WAIT_S: begin
              stop     <= 1'd0;
	      intr     <= 1'd0;
	      specreg  <= 1'd1;
              data_out <= DATA_OUT_VALUE;

              if (ack)
	        state_next <= COMPARE_S;                 
	      else 
	        state_next <= WAIT_S;  
	    end

 COMPARE_S: begin 
              stop     <= 1'd1;                                                  // stop is "1"
	      intr     <= 1'd0;
	      data_out <= DATA_OUT_VALUE;

              if (data_in == DATA_OUT_VALUE)
	        specreg <= 1'd0;                                                 // pass
              else
	        specreg <= 1'd1;                                                 // fail	          
	    end
	 
   default: begin 
	      state_next <= IDLE_S;
	    end
      endcase     
    end // always   
                                   
endmodule 