//////////////////////////////////////////////////////////////
// Name File          : tb_fsm_main.v                       //
// Autor              : Maksim                              //
// Company            :                                     //
// Description        : testbench for fsm_main module       //
// Start design       : 26.08.19                            //
// Last revision      : 26.08.19                            //
//////////////////////////////////////////////////////////////

`timescale 1ns / 100 ps
                                                      
module tb_fsm_main;
                                                      
//***************************************************************************
// Reg declarations
//***************************************************************************
  reg        clock;                        // declaration of signals  
  reg        arst;
  reg        ack;
  reg        gpl_status;
  reg        pll_lock;
  reg        fx3_ready;
  reg [22:0] data_in;

  reg        task_arst;                   // for task purposes
  reg        task_ack;
  reg        task_gpl_status;
  reg        task_pll_lock;
  reg        task_fx3_ready;
  reg [22:0] task_data_in;

//***************************************************************************
// Wire declarations
//***************************************************************************
  wire        intr;
  wire        gpl_clk;
  wire        hw_rst;
  wire [22:0] data_out;

//***************************************************************************
// Code
//***************************************************************************
                                           // instantiation
     fsm_main dut(
              .clk             (clock),
	      .arst            (arst),
	      .ack             (ack),
              .gpl_status      (gpl_status),
	      .pll_lock        (pll_lock),
	      .fx3_ready       (fx3_ready),
	      .data_in         (data_in),

	      .intr            (intr),
	      .gpl_clk         (gpl_clk),
	      .hw_rst          (hw_rst),
	      .data_out        (data_out)
              );


initial                                   // clock generator 
  begin
    clock = 0;
   #0 forever #5 clock = !clock;
  end


initial	                                  // Test stimulus
  begin
   #10 arst       = 1'd0; 
       ack        = 1'd0;
       gpl_status = 1'd0;
       pll_lock   = 1'd0;
       fx3_ready  = 1'd0;
       data_in    = 23'd0;

 /*  #10 arst       = 1'd1; 
       ack        = 1'd1;
       gpl_status = 1'd1;
       pll_lock   = 1'd1;
       fx3_ready  = 1'd1;
       data_in    = 23'd77777;  */

   #10 STIMULUS (1'd1,1'd1,1'd1,1'd1,1'd1,23'd77777);
   #50 STIMULUS (1'd1,1'd1,1'd1,1'd1,1'd1,23'd55555);
 
 

  $display("Simulation is over, check the waveforms.");

   #1_000 $stop;
  end

task STIMULUS;                                                // task STIMULUS
   input        task_arst;
   input        task_ack;
   input        task_gpl_status;
   input        task_pll_lock;
   input        task_fx3_ready;
   input [22:0] task_data_in;
     begin
       arst       = task_arst;
       ack        = task_ack;
       gpl_status = task_gpl_status;
       pll_lock   = task_pll_lock;
       fx3_ready  = task_fx3_ready;
       data_in    = task_data_in;

       $display ("time = %t",$time, "-----", "data_in = %d",data_in);
     end
  
 endtask

endmodule 

