//////////////////////////////////////////////////////////////
// Name File          : tb_top_test_fx3.v                   //
// Autor              : Maksim                              //
// Company            :                                     //
// Description        : testbench for top_test_fx3 module   //
// Start design       : 28.08.19                            //
// Last revision      : 28.08.19                            //
//////////////////////////////////////////////////////////////

`timescale 1ns / 100 ps
                                                      
module tb_top_test_fx3;
                                                      
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
 top_test_fx3 DUT(
              .CLK_40             (clock),
	      .ARST               (arst),
	      .FX3_GPIO26         (ack),
              .FX3_GPIO57         (gpl_status),
	      .PLL_LOCK           (pll_lock),
	      .FX3_MEM_DI_RXD     (fx3_ready),
	      .FX3_DQ_IN          (data_in [15:0]),
	      .FX3_WRn            (data_in [16]),
	      .FX3_RDn            (data_in [17]),
	      .FX3_FL_B           (data_in [18]),
	      .FX3_PENDn          (data_in [19]),
	      .FX3_ADDR1          (data_in [20]),
	      .FX3_MEM_CLK        (data_in [21]),
	      .FX3_MEM_DO_TXD     (data_in [22]),

	      .FX3_GPIO23         (intr),
	      .FX3_PCLK           (gpl_clk),
	      .FX3_RST            (hw_rst),
	      .FX3_DQ_OUT         (data_out [15:0]),
	      .FX3_CSn            (data_out [16]),
	      .FX3_OEn            (data_out [17]),
	      .FX3_FL_A           (data_out [18]),
	      .FX3_GPIO25         (data_out [19]),
	      .FX3_FL_C           (data_out [20]),
	      .FX3_ADDR0          (data_out [21]),
	      .FX3_MEM_SSN        (data_out [22])
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

   #10 STIMULUS (1'd1,1'd1,1'd1,1'd1,1'd1,23'd77777);        // call task
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

