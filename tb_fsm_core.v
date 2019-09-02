//////////////////////////////////////////////////////////////
// Name File          : tb_fsm_core.v                       //
// Autor              : Maksim                              //
// Company            :                                     //
// Description        : testbench for fsm_core module       //
// Start design       : 13.08.19                            //
// Last revision      : 13.08.19                            //
//////////////////////////////////////////////////////////////
     
`timescale 1ns / 100 ps
                                                      
module tb_fsm_core;
                                                      
//***************************************************************************
// Reg declarations
//***************************************************************************
  reg        clock;                         // declaration of signals  
  reg        arst;
  reg        ack;
  reg        ena;
  reg [22:0] data_in;

//***************************************************************************
// Wire declarations
//***************************************************************************
  wire        intr;
  wire        specreg;
  wire        stop;
  wire [22:0] data_out;

//***************************************************************************
// Code
//***************************************************************************
                                           // instantiation
     fsm_core dut(
              .clk      (clock),
	      .arst     (arst),
	      .ack      (ack),
              .ena      (ena),
	      .data_in  (data_in),

	      .intr     (intr),
	      .specreg  (specreg),
	      .stop     (stop),
	      .data_out (data_out)
              );


initial                                   // clock generator 
  begin
    clock = 0;
   #0 forever #5 clock = !clock;
  end


initial	                                  // Test stimulus
  begin
   #10 arst = 1'd0;
       ack  = 1'd0;
       ena  = 1'd0;
       data_in = 23'd0;

  
   #10 arst = 1'd1;
       ack  = 1'd0;
       ena  = 1'd0;
       data_in = 23'd0;

   #40 arst = 1'd0;
       ack  = 1'd1;
       ena  = 1'd1;
       data_in = 23'd0;

  
   #40 arst = 1'd0;
       ack  = 1'd1;
       ena  = 1'd1;
       data_in = 23'd65535;


   $display("Simulation is over, check the waveforms.");

   #1_000 $stop;
 


  end

endmodule 

