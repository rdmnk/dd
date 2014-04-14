 //`include "defines.v"
 
module rx_stats_fifo(/*AUTOARG*/
  // Outputs
  rxsfifo_rdata, rxsfifo_rempty,
  // Inputs
  clk_xgmii_rx, reset_xgmii_rx_n, wb_clk_i, wb_rst_i, rxsfifo_wdata,
  rxsfifo_wen
  );
 
input         clk_xgmii_rx;
input         reset_xgmii_rx_n;
input         wb_clk_i;
input         wb_rst_i;
 
input [13:0]  rxsfifo_wdata;
input         rxsfifo_wen;
 
output [13:0] rxsfifo_rdata;
output        rxsfifo_rempty;
 
generic_fifo #(
  .DWIDTH (14),
  .AWIDTH (`RX_STAT_FIFO_AWIDTH),
  .REGISTER_READ (1),
  .EARLY_READ (1),
  .CLOCK_CROSSING (1),
  .ALMOST_EMPTY_THRESH (7),
  .ALMOST_FULL_THRESH (12),
  .MEM_TYPE (`MEM_AUTO_SMALL)
)
fifo0(
    .wclk (clk_xgmii_rx),
    .wrst_n (reset_xgmii_rx_n),
    .wen (rxsfifo_wen),
    .wdata (rxsfifo_wdata),
    .wfull (),
    .walmost_full (),
 
    .rclk (wb_clk_i),
    .rrst_n (~wb_rst_i),
    .ren (1'b1),
    .rdata (rxsfifo_rdata),
    .rempty (rxsfifo_rempty),
    .ralmost_empty ()
);
 
endmodule
