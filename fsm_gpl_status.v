/////////////////////////////////////////////////////////////////
// Name File          : fsm_gpl_status.v                       //
// Autor              : Maksim                                 //
// Company            :                                        //
// Description        : FSM for test_fx3 project               //
// Start design       : 23.08.19                               //
// Last revision      : 23.08.19                               //
/////////////////////////////////////////////////////////////////
    
`timescale 1ns / 100 ps

module fsm_gpl_status (                        
  input wire clk,                                                           // clock 40 MHz      
  input wire arst,                                                          // asynchronous reset
  input wire ena,                                                           // enable signal
  input wire gpl_status,                                                    // input GPL status signal

  output reg specreg                                                        // special register for check connection cable ("1"-pass, "0"-fail) 
  );

//***************************************************************************
// Parameter definitions
//***************************************************************************                    
  localparam [3:0] IDLE_S=4'd0, COMPARE_S=4'd1, WRITE_S=4'd2;                      // symbolic state declaration

//***************************************************************************
// Reg declarations
//***************************************************************************
  reg [3:0] state_reg, state_next;                                                 // signal declaration FSM

  reg [2:0] counter;                                                               // [11:0] for devide 40 MHz into 4095 times (for Relise)
                                                                                   // [2:0]                                    (for Debug)         
//***************************************************************************
// Wire declarations
//***************************************************************************

//***************************************************************************
// Code
//***************************************************************************                                                                                  
  always @(negedge clk or negedge arst)                                           // FSM code starts here
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
        
  always @(state_reg or ena or gpl_status or counter)                             // next-state logic and output logic
    begin
       state_next <= state_reg; 

      case (state_reg)
    IDLE_S: begin                                                                 // default state  
	      counter <= 3'd0;                                                    // reset counter
	      specreg <= 1'd0;

              if (ena)
	        state_next <= COMPARE_S;
	      else 
	        state_next <= IDLE_S;
	    end

 COMPARE_S: begin
              specreg <= 1'd0;

              if ((counter == 3'd0) && gpl_status )
	        state_next <= WRITE_S;
	      else 
	        state_next <= COMPARE_S;
	     end

   WRITE_S: begin                                              
              specreg <= 1'd1;

              if (!(counter == 3'd0))
	        state_next <= COMPARE_S;
	      else 
	        state_next <= WRITE_S;	        
	    end
	    
   default: begin 
	      state_next <= IDLE_S;
	    end
      endcase     
    end // always                           
                                                                               // FSM code end here

  always @(negedge clk)                                                        // counter
    begin
      counter <= counter + 3'd1;	
    end

endmodule 