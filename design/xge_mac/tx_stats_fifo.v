// `include "defines.v"
 
module tx_stats_fifo(/*AUTOARG*/
  // Outputs
  txsfifo_rdata, txsfifo_rempty,
  // Inputs
  clk_xgmii_tx, reset_xgmii_tx_n, wb_clk_i, wb_rst_i, txsfifo_wdata,
  txsfifo_wen
  );
 
input         clk_xgmii_tx;
input         reset_xgmii_tx_n;
input         wb_clk_i;
input         wb_rst_i;
 
input [13:0]  txsfifo_wdata;
input         txsfifo_wen;
 
output [13:0] txsfifo_rdata;
output        txsfifo_rempty;
 
generic_fifo #(
  .DWIDTH (14),
  .AWIDTH (`TX_STAT_FIFO_AWIDTH),
  .REGISTER_READ (1),
  .EARLY_READ (1),
  .CLOCK_CROSSING (1),
  .ALMOST_EMPTY_THRESH (7),
  .ALMOST_FULL_THRESH (12),
  .MEM_TYPE (`MEM_AUTO_SMALL)
)
fifo0(
    .wclk (clk_xgmii_tx),
    .wrst_n (reset_xgmii_tx_n),
    .wen (txsfifo_wen),
    .wdata (txsfifo_wdata),
    .wfull (),
    .walmost_full (),
 
    .rclk (wb_clk_i),
    .rrst_n (~wb_rst_i),
    .ren (1'b1),
    .rdata (txsfifo_rdata),
    .rempty (txsfifo_rempty),
    .ralmost_empty ()
);
 
endmodule
