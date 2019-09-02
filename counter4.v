////////////////////////////////////////////////////////////////////////
// Name File	     : counter4.v        			      //																	//
// Autor	     : Maksim   				      //											//
// Company	     : 						      //																	//
// Description	     : Timer, Width=4 bits			      //	 												//
// Start design	     : 08.08.19				              //																//
// Last revision     : 25.08.19				              //																//
////////////////////////////////////////////////////////////////////////

`timescale 1ns / 100 ps

module counter4 #(parameter Width=4)	       // These parameters can be overridden
	     (clk,                             // clock
	      srst,                            // synchronous reset
	      arst,                            // asynchronous reset
	      start,                           // signal enable count
	      data,                            // count to this number
	      stop);                           // output flag (count is over)

  input wire             clk;
  input	wire             srst;
  input	wire             arst;
  input	wire             start;
  input wire [Width-1:0] data; 

  output reg             stop;

//***************************************************************************
// Reg declarations
//***************************************************************************
  reg [Width-1:0] counter;

//***************************************************************************
// Code
//***************************************************************************
  always @(negedge clk or negedge arst)
    if (srst || arst)
      counter <= 0;
    else
      if (start)
	counter <= counter + 1;
      

  always @(negedge clk or negedge arst)
    if (srst || arst)
      stop <= 1'b0;
    else
      if (counter == data)                 
        stop <= 1'b1;
      else
        stop <= 1'b0;		

endmodule 
