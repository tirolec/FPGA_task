/////////////////////////////////////////////////////////////////
// Name File          : top_test_fx3.v                         //
// Autor              : Maksim                                 //
// Company            :                                        //
// Description        : top file for test_fx3 project          //
// Start design       : 27.08.19                               //
// Last revision      : 28.08.19                               //
/////////////////////////////////////////////////////////////////

`timescale 1ns / 100 ps

module top_test_fx3 (
  input wire        CLK_40,                       // clock 40 MHz      
  input wire        ARST,                         // asynchronous reset
  input wire        PLL_LOCK,                     // PLL lock signal

  input wire [15:0] FX3_DQ_IN,                    // to FX3 chip pin
  input wire        FX3_WRn,                      // to FX3 chip pin
  input wire        FX3_RDn,                      // to FX3 chip pin
  input wire        FX3_FL_B,                     // to FX3 chip pin
  input wire        FX3_PENDn,                    // to FX3 chip pin
  input wire        FX3_GPIO26,                   // to FX3 chip pin, acknowledgement signal
  input wire        FX3_ADDR1,                    // to FX3 chip pin
  input wire        FX3_MEM_CLK,                  // to FX3 chip pin
  input wire        FX3_MEM_DO_TXD,               // to FX3 chip pin
  input wire        FX3_MEM_DI_RXD,               // to FX3 chip pin, FX3 Ready signal
  input wire        FX3_GPIO57,                   // to FX3 chip pin, GPI status siganl

  output wire [15:0] FX3_DQ_OUT,                  // to FX3 chip pin                         
  output wire        FX3_CSn,                     // to FX3 chip pin  
  output wire        FX3_OEn,                     // to FX3 chip pin  
  output wire        FX3_FL_A,                    // to FX3 chip pin
  output wire        FX3_GPIO23,                  // to FX3 chip pin, introduce signal
  output wire        FX3_GPIO25,                  // to FX3 chip pin
  output wire        FX3_FL_C,                    // to FX3 chip pin
  output wire        FX3_ADDR0,                   // to FX3 chip pin
  output wire        FX3_MEM_SSN,                 // to FX3 chip pin
  output wire        FX3_RST,                     // to FX3 chip pin, hardware reset signal
  output wire        FX3_PCLK                     // to FX3 chip pin, clock for GPL
);
 
//***************************************************************************
// Parameter definitions
//***************************************************************************                    

//***************************************************************************
// Reg declarations
//***************************************************************************
  
//***************************************************************************
// Wire declarations
//***************************************************************************
  wire [22:0] data_in;
  wire [22:0] data_out;

//***************************************************************************
// Code
//***************************************************************************                                                                                                                             
                                                                              // instantiation FSM_MAIN
fsm_main FSM_MAIN (
              .clk             (CLK_40),
	      .arst            (ARST),
	      .ack             (FX3_GPIO26),
              .gpl_status      (FX3_GPIO57),
	      .pll_lock        (PLL_LOCK),
	      .fx3_ready       (FX3_MEM_DI_RXD),
	      .data_in         (data_in),

	      .intr            (FX3_GPIO23),
	      .gpl_clk         (FX3_PCLK),
	      .hw_rst          (FX3_RST),
	      .data_out        (data_out)
              );
                                                                             // assignments
  assign data_in [15:0] = FX3_DQ_IN;
  assign data_in [16]   = FX3_WRn;
  assign data_in [17]   = FX3_RDn;
  assign data_in [18]   = FX3_FL_B;
  assign data_in [19]   = FX3_PENDn;
  assign data_in [20]   = FX3_ADDR1;
  assign data_in [21]   = FX3_MEM_CLK;
  assign data_in [22]   = FX3_MEM_DO_TXD;

  assign FX3_DQ_OUT     = data_out [15:0];
  assign FX3_CSn        = data_out [16];
  assign FX3_OEn        = data_out [17];
  assign FX3_FL_A       = data_out [18];
  assign FX3_GPIO25     = data_out [19];
  assign FX3_FL_C       = data_out [20];
  assign FX3_ADDR0      = data_out [21];
  assign FX3_MEM_SSN    = data_out [22];

endmodule 