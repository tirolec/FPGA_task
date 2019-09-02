/////////////////////////////////////////////////////////////////
// Name File          : fsm_vectors.v                          //
// Autor              : Maksim                                 //
// Company            :                                        //
// Description        : FSM for test_fx3 project               //
// Start design       : 13.08.19                               //
// Last revision      : 22.08.19                               //
/////////////////////////////////////////////////////////////////

`timescale 1ns / 100 ps

module fsm_vectors (                        
  input wire        clk,                                                       // clock      
  input wire        arst,                                                      // asynchronous reset
  input wire        ack,                                                       // acknowledgement signal
  input wire        ena,                                                       // enable signal
  input wire [22:0] data_in,                                                   // data on the bus

  output reg        intr,                                                      // introduce signal 
  output wire [3:0] specreg,                                                   // bus for special register for accumulate errors (every bit "0"-pass, "1"-fail)
  output reg        stop,                                                      // stop flag, all processes in FSM is over
  output reg [22:0] data_out                                                   // data out on the bus 
  );

//***************************************************************************
// Parameter definitions
//***************************************************************************                    
  localparam [3:0] IDLE_S=4'd0, V0_REP_0_S=4'd1, V0_REP_1_S=4'd2, V0_REP_2_S=4'd3, V0_REP_3_S=4'd4, STOP_S=4'd5; // symbolic state declaration

//***************************************************************************
// Reg declarations
//***************************************************************************
  reg [3:0] state_reg, state_next;                                                 // signal declaration FSM

  reg ena_core_0;                                                                  // registers for CORE_XXX purpose
  reg ena_core_1;
  reg ena_core_2;
  reg ena_core_3;
                                                              
//***************************************************************************
// Wire declarations
//***************************************************************************
  wire stop_core_0;
  wire specreg_core_0;

  wire stop_core_1;
  wire specreg_core_1;

  wire stop_core_2;
  wire specreg_core_2;

  wire stop_core_3;
  wire specreg_core_3;

  wire [3:0] sel_mux;          
  
  wire [22:0] data_out_core_0;
  wire [22:0] data_out_core_1;
  wire [22:0] data_out_core_2;
  wire [22:0] data_out_core_3;

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
        
  always @(state_reg or ack or ena or data_in or stop_core_0 or stop_core_1 or stop_core_2 or stop_core_3) // next-state logic and output logic
    begin
       state_next <= state_reg; 

      case (state_reg)
    IDLE_S: begin                                                                 // default state  
	      ena_core_0 <= 1'd0;
              ena_core_1 <= 1'd0;
	      ena_core_2 <= 1'd0;
	      ena_core_3 <= 1'd0;
              stop       <= 1'd0;

              if (ena)
	        state_next <= V0_REP_0_S;
	      else 
	        state_next <= IDLE_S;
	    end

V0_REP_0_S: begin                                                                 // vector0, repeat0 state
              ena_core_0 <= 1'd1;                                                 // start CORE_0
              ena_core_1 <= 1'd0;
	      ena_core_2 <= 1'd0;
	      ena_core_3 <= 1'd0;
	      stop       <= 1'd0;

              if (stop_core_0)
	        state_next <= V0_REP_1_S;
	      else 
	        state_next <= V0_REP_0_S;
	     end

V0_REP_1_S: begin                                              
              ena_core_0 <= 1'd0;                                                 // start CORE_1
              ena_core_1 <= 1'd1;
              ena_core_2 <= 1'd0;
	      ena_core_3 <= 1'd0;
              stop       <= 1'd0;

              if (stop_core_1)
	        state_next <= V0_REP_2_S;
	      else 
	        state_next <= V0_REP_1_S;	        
	    end

V0_REP_2_S: begin
              ena_core_0 <= 1'd0;                                                 // start CORE_2
              ena_core_1 <= 1'd0; 
              ena_core_2 <= 1'd1;
	      ena_core_3 <= 1'd0;
              stop       <= 1'd0;

              if (stop_core_2)
	        state_next <= V0_REP_3_S;
	      else 
	        state_next <= V0_REP_2_S;  
	    end 

V0_REP_3_S: begin
              ena_core_0 <= 1'd0;                                                 // start CORE_3
              ena_core_1 <= 1'd0; 
              ena_core_2 <= 1'd0;
	      ena_core_3 <= 1'd1;
              stop       <= 1'd0;

              if (stop_core_3)
	        state_next <= STOP_S;
	      else 
	        state_next <= V0_REP_3_S;  
	        
	    end 

    STOP_S: begin
              ena_core_0 <= 1'd0;                                                 // stop all processes
              ena_core_1 <= 1'd0; 
              ena_core_2 <= 1'd0;
	      ena_core_3 <= 1'd0;
              stop       <= 1'd1;
	        
	    end 

	 
   default: begin 
	      state_next <= IDLE_S;
	    end
      endcase     
    end // always                           
                                                                               // FSM code end here
				   

                                                                               // instantiation CORE_0
fsm_core #(35535) CORE_0 (                                                     // These parameters can be overridden
                  .clk      (clk),
		  .arst     (arst),
		  .ack      (ack),
		  .ena      (ena_core_0),
		  .data_in  (data_in),
		  .intr     (intr_core_0),
		  .specreg  (specreg_core_0),
		  .stop     (stop_core_0),
		  .data_out (data_out_core_0)
		  );

                                                                               // instantiation CORE_1
fsm_core #(55555) CORE_1 (                                                     // These parameters can be overridden
                  .clk      (clk),
		  .arst     (arst),
		  .ack      (ack),
		  .ena      (ena_core_1),
		  .data_in  (data_in),
		  .intr     (intr_core_1),
		  .specreg  (specreg_core_1),
		  .stop     (stop_core_1),
		  .data_out (data_out_core_1)
		  );

                                                                               // instantiation CORE_2
fsm_core #(77777) CORE_2 (                                                     // These parameters can be overridden
                  .clk      (clk),
		  .arst     (arst),
		  .ack      (ack),
		  .ena      (ena_core_2),
		  .data_in  (data_in),
		  .intr     (intr_core_2),
		  .specreg  (specreg_core_2),
		  .stop     (stop_core_2),
		  .data_out (data_out_core_2)
		  );

                                                                               // instantiation CORE_3
fsm_core #(22222) CORE_3 (                                                     // These parameters can be overridden
                  .clk      (clk),
		  .arst     (arst),
		  .ack      (ack),
		  .ena      (ena_core_3),
		  .data_in  (data_in),
		  .intr     (intr_core_3),
		  .specreg  (specreg_core_3),
		  .stop     (stop_core_3),
		  .data_out (data_out_core_3)
		  );

  assign specreg[0] = specreg_core_0;
  assign specreg[1] = specreg_core_1;
  assign specreg[2] = specreg_core_2;
  assign specreg[3] = specreg_core_3;
                                                                              // MUX code for intr signal starts here
  assign sel_mux = {ena_core_3,ena_core_2,ena_core_1,ena_core_0};

  always @(sel_mux or intr_core_0 or intr_core_1 or intr_core_2 or intr_core_3)
    begin
      case (sel_mux)
	4'b0001 : intr = intr_core_0;
	4'b0010 : intr = intr_core_1;
        4'b0100 : intr = intr_core_2;
	4'b1000 : intr = intr_core_3;
	default : intr = intr_core_0;
      endcase  
    end // always sel_mux                                                    // MUX code for intr signal end here
  
  always @(sel_mux or data_out_core_0 or data_out_core_1 or data_out_core_2 or data_out_core_3)  // MUX code for data_out bus starts here
    begin
      case (sel_mux)
	4'b0001 : data_out = data_out_core_0;
	4'b0010 : data_out = data_out_core_1;
        4'b0100 : data_out = data_out_core_2;
	4'b1000 : data_out = data_out_core_3;
	default : data_out = data_out_core_0;
      endcase  
    end // always sel_mux                                                    // MUX code for data_out bus end here

endmodule 