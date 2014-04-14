//`include "defines.v"
 
module sync_clk_xgmii_tx(/*AUTOARG*/
  // Outputs
  ctrl_tx_enable_ctx, status_local_fault_ctx, status_remote_fault_ctx,
  // Inputs
  clk_xgmii_tx, reset_xgmii_tx_n, ctrl_tx_enable,
  status_local_fault_crx, status_remote_fault_crx
  );
 
input         clk_xgmii_tx;
input         reset_xgmii_tx_n;
 
input         ctrl_tx_enable;
 
input         status_local_fault_crx;
input         status_remote_fault_crx;
 
output        ctrl_tx_enable_ctx;
 
output        status_local_fault_ctx;
output        status_remote_fault_ctx;
 
/*AUTOREG*/
 
/*AUTOWIRE*/
 
wire  [2:0]             sig_out;
 
assign ctrl_tx_enable_ctx = sig_out[2];
assign status_local_fault_ctx = sig_out[1];
assign status_remote_fault_ctx = sig_out[0];
 
meta_sync #(.DWIDTH (3)) meta_sync0 (
                      // Outputs
                      .out              (sig_out),
                      // Inputs
                      .clk              (clk_xgmii_tx),
                      .reset_n          (reset_xgmii_tx_n),
                      .in               ({
                                          ctrl_tx_enable,
                                          status_local_fault_crx,
                                          status_remote_fault_crx
                                         }));
 
endmodule
