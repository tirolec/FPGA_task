//////////////////////////////////////////////////////////////
// Name File          : tb_fsm_gpl_status.v                 //
// Autor              : Maksim                              //
// Company            :                                     //
// Description        : testbench for fsm_gpl_status module //
// Start design       : 23.08.19                            //
// Last revision      : 23.08.19                            //
//////////////////////////////////////////////////////////////

`timescale 1ns / 100 ps
                                                      
module tb_fsm_gpl_status;
                                                      
//***************************************************************************
// Reg declarations
//***************************************************************************
  reg clock;                               // declaration of signals  
  reg arst;
  reg gpl_status;
  reg ena;

//***************************************************************************
// Wire declarations
//***************************************************************************
  wire specreg;

//***************************************************************************
// Code
//***************************************************************************
                                           // instantiation
fsm_gpl_status dut(
              .clk        (clock),
	      .arst       (arst),
	      .gpl_status (gpl_status),
              .ena        (ena),

	      .specreg    (specreg)
              );


initial                                   // clock generator 
  begin
    clock = 0;
   #0 forever #5 clock = !clock;
  end


initial	                                  // Test stimulus
  begin
   #10 arst        = 1'd0;
       gpl_status  = 1'd0;
       ena         = 1'd0;
  
   #10 arst        = 1'd1;
       gpl_status  = 1'd0;
       ena         = 1'd0;    

   #40 arst        = 1'd0;
       gpl_status  = 1'd1;
       ena         = 1'd1;    
  
   #40 arst        = 1'd0;
       gpl_status  = 1'd1;
       ena         = 1'd1;  

   #40 arst        = 1'd0;
       gpl_status  = 1'd1;
       ena         = 1'd1;

   #90 arst        = 1'd0;
       gpl_status  = 1'd0;
       ena         = 1'd1;

   $display("Simulation is over, check the waveforms.");

   #1_000 $stop;

  end

endmodule 

