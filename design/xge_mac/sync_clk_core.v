// `include "defines.v"
 
module sync_clk_core(/*AUTOARG*/
  // Inputs
  clk_xgmii_tx, reset_xgmii_tx_n
  );
 
input         clk_xgmii_tx;
input         reset_xgmii_tx_n;
 
//input         ctrl_tx_disable_padding;
 
//output        ctrl_tx_disable_padding_ccr;
 
 
/*AUTOREG*/
 
/*AUTOWIRE*/
 
//wire  [0:0]             sig_out;
 
//assign {ctrl_tx_disable_padding_ccr} = sig_out;
 
//meta_sync #(.DWIDTH (1)) meta_sync0 (
//                      // Outputs
//                      .out              (sig_out),
//                      // Inputs
//                      .clk              (clk_xgmii_tx),
//                      .reset_n          (reset_xgmii_tx_n),
//                      .in               ({
//                                          ctrl_tx_disable_padding
//                                         }));
 
endmodule
