/////////////////////////////////////////////////////////////////
// Name File          : fsm_main.v                             //
// Autor              : Maksim                                 //
// Company            :                                        //
// Description        : FSM for test_fx3 project               //
// Start design       : 25.08.19                               //
// Last revision      : 26.08.19                               //
/////////////////////////////////////////////////////////////////
   
`timescale 1ns / 100 ps

module fsm_main (
  input wire        clk,                          // clock 40 MHz      
  input wire        arst,                         // asynchronous reset
  input wire        ack,                          // acknowledgement signal
  input wire        gpl_status,                   // GPL status signal
  input wire        pll_lock,                     // PLL lock signal
  input wire        fx3_ready,                    // FX3 chip ready signal
  input wire [22:0] data_in,                      // data_in bus

  output wire       intr,                         // introduce signal
  output wire       gpl_clk,                      // clock for GPL
  output reg        hw_rst,                       // hardware reset signal
  output wire [22:0] data_out                     // data_out bus
);

//***************************************************************************
// Parameter definitions
//***************************************************************************                    
  localparam [2:0] IDLE_S=3'd0, RST_1_S=3'd1, START_S=3'd2, STOP_S=3'd3;                         // symbolic state declaration

//***************************************************************************
// Reg declarations
//***************************************************************************
  reg [2:0] state_reg, state_next;                                                                // signal declaration FSM

  reg        tmr_start;                                                                           // signal count enable for TIMER
  reg [12:0] tmr_delay = 13'd8;                                                                   // delay clocks for TIMER (8 clk for Debug, 8000 clk for Release)
  reg        tmr_srst;                                                                            // signal reset TIMER

  reg        ena_fsm_gpl_status;                                                                  // signal enable for fsm_gpl_status module
  reg        ena_fsm_vectors;                                                                     // signal enable for fsm_vectors module

//***************************************************************************
// Wire declarations
//***************************************************************************
  wire       tmr_stop;                                                                             // for TIMER purpose
  wire       stop_fsm_vectors;                                                                     // signal stop for fsm_vectors module
  wire [3:0] specreg_vectors;                                                                      // for fsm_vectors
  wire       specreg_gpl_status;                                                                   // for fsm_gpl_status
  wire [4:0] specreg;                                                                              // bus for collect errors (MSB is GPL status)

//***************************************************************************
// Code
//***************************************************************************
  always @(posedge clk or negedge arst) 
    begin 
      if (arst==0)
        begin
          state_reg  <= IDLE_S;                                                     // realisation transition in state IDLE                                                      
	end
      else
        begin 
          state_reg <= state_next;                                                  // state register
	end
    end
        
  always @(state_reg or ack or gpl_status or pll_lock or fx3_ready or data_in or tmr_stop or stop_fsm_vectors)   // next-state logic and output logic
    begin
       state_next <= state_reg; 

      case (state_reg)
    IDLE_S: begin                                                                 // default state
              tmr_start <= 1'd0;
	      tmr_srst  <= 1'd0; 
	      hw_rst    <= 1'd0;
	      ena_fsm_vectors <= 1'd0;
	      ena_fsm_gpl_status <= 1'd0;

	      if (pll_lock && fx3_ready)
                begin
	          state_next <= RST_1_S; 
	        end 
	      else 
		  begin
		    state_next <= IDLE_S;
		  end   
	    end

   RST_1_S: begin
              tmr_start <= 1'd1;                                            // timer is on
	      tmr_srst  <= 1'd0;
	      hw_rst    <= 1'd1;                                            // HW_RST is on
	      ena_fsm_vectors <= 1'd0;
	      ena_fsm_gpl_status <= 1'd0;
                if (tmr_stop)                                               // output flag TIMER
		  begin 
	            state_next <= START_S;  
		  end // tmr_stop
		else 
		  begin
		    state_next <= RST_1_S;
		  end   
	     end

   START_S: begin 
              tmr_srst  <= 1'd1;  
              tmr_start <= 1'd0;
	      hw_rst    <= 1'd0;                                            // HW_RST is off after delay 200 uS
	      ena_fsm_vectors <= 1'd1;                                      // fsm_vectors module is on
	      ena_fsm_gpl_status <= 1'd1;                                   // fsm_gpl_status module is on
                if (stop_fsm_vectors)
                  begin 
	            state_next <= STOP_S;  
		  end
		else 
		  begin
		    state_next <= START_S;
		  end   
	    end

    STOP_S: begin 
	      tmr_srst  <= 1'd1;  
              tmr_start <= 1'd0; 
              hw_rst    <= 1'd0;
	      ena_fsm_vectors <= 1'd0;                                     // fsm_vectors module is off
              ena_fsm_gpl_status <= 1'd0;
	    end

	 
   default: begin 
	      state_next <= IDLE_S;
	    end
      endcase     
    end   

  assign gpl_clk = clk;
  assign specreg = {specreg_gpl_status,specreg_vectors};
                                                                               // instantiation TIMER
counter4 #(13) TIMER (                                                         // These parameters can be overridden
                  .clk   (clk),
		  .srst  (tmr_srst),
		  .arst  (~arst),
		  .start (tmr_start),
		  .data  (tmr_delay),
		  .stop  (tmr_stop)
		  );
                                                                               // instantiation FSM_VECTORS                                                           
fsm_vectors FSM_VECTORS (
                  .clk      (clk),
		  .arst     (~arst),
		  .ack      (ack),
		  .ena      (ena_fsm_vectors),
		  .data_in  (data_in),
		  .intr     (intr),
		  .specreg  (specreg_vectors),
		  .stop     (stop_fsm_vectors),
		  .data_out (data_out)
		  );
                                                                              // instantiation FSM_GPL_STATUS
fsm_gpl_status FSM_GPL_STATUS (
                 .clk        (clk),
		 .arst       (~arst),
		 .ena        (ena_fsm_gpl_status),
		 .gpl_status (gpl_status),
		 .specreg    (specreg_gpl_status)
		 );

endmodule 