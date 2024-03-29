// `include "defines.v"
 
module stats_sm(/*AUTOARG*/
  // Outputs
  stats_tx_octets, stats_tx_pkts, stats_rx_octets, stats_rx_pkts,
  // Inputs
  wb_clk_i, wb_rst_i, txsfifo_rdata, txsfifo_rempty, rxsfifo_rdata,
  rxsfifo_rempty, clear_stats_tx_octets, clear_stats_tx_pkts,
  clear_stats_rx_octets, clear_stats_rx_pkts
  );
 
 
input         wb_clk_i;
input         wb_rst_i;
 
input  [13:0] txsfifo_rdata;
input         txsfifo_rempty;
 
input  [13:0] rxsfifo_rdata;
input         rxsfifo_rempty;
 
output [31:0] stats_tx_octets;
output [31:0] stats_tx_pkts;
 
output [31:0] stats_rx_octets;
output [31:0] stats_rx_pkts;
 
input         clear_stats_tx_octets;
input         clear_stats_tx_pkts;
input         clear_stats_rx_octets;
input         clear_stats_rx_pkts;
 
/*AUTOREG*/
// Beginning of automatic regs (for this module's undeclared outputs)
reg [31:0]              stats_rx_octets;
reg [31:0]              stats_rx_pkts;
reg [31:0]              stats_tx_octets;
reg [31:0]              stats_tx_pkts;
// End of automatics
 
 
/*AUTOWIRE*/
 
reg           txsfifo_rempty_d1;
reg           rxsfifo_rempty_d1;
 
reg [31:0]    next_stats_tx_octets;
reg [31:0]    next_stats_tx_pkts;
 
reg [31:0]    next_stats_rx_octets;
reg [31:0]    next_stats_rx_pkts;
 
always @(posedge wb_clk_i or posedge wb_rst_i) begin
 
    if (wb_rst_i == 1'b1) begin
 
        txsfifo_rempty_d1 <= 1'b1;
        rxsfifo_rempty_d1 <= 1'b1;
 
        stats_tx_octets <= 32'b0;
        stats_tx_pkts <= 32'b0;
 
        stats_rx_octets <= 32'b0;
        stats_rx_pkts <= 32'b0;
 
    end
    else begin
 
        txsfifo_rempty_d1 <= txsfifo_rempty;
        rxsfifo_rempty_d1 <= rxsfifo_rempty;
 
        stats_tx_octets <= next_stats_tx_octets;
        stats_tx_pkts <= next_stats_tx_pkts;
 
        stats_rx_octets <= next_stats_rx_octets;
        stats_rx_pkts <= next_stats_rx_pkts;
 
    end
 
end
 
always @(/*AS*/clear_stats_rx_octets or clear_stats_rx_pkts
         or clear_stats_tx_octets or clear_stats_tx_pkts
         or rxsfifo_rdata or rxsfifo_rempty_d1 or stats_rx_octets
         or stats_rx_pkts or stats_tx_octets or stats_tx_pkts
         or txsfifo_rdata or txsfifo_rempty_d1) begin
 
    next_stats_tx_octets = {32{~clear_stats_tx_octets}} & stats_tx_octets;
    next_stats_tx_pkts = {32{~clear_stats_tx_pkts}} & stats_tx_pkts;
 
    next_stats_rx_octets = {32{~clear_stats_rx_octets}} & stats_rx_octets;
    next_stats_rx_pkts = {32{~clear_stats_rx_pkts}} & stats_rx_pkts;
 
    if (!txsfifo_rempty_d1) begin
        next_stats_tx_octets = next_stats_tx_octets + {18'b0, txsfifo_rdata};
        next_stats_tx_pkts = next_stats_tx_pkts + 32'b1;
    end
 
    if (!rxsfifo_rempty_d1) begin
        next_stats_rx_octets = next_stats_rx_octets + {18'b0, rxsfifo_rdata};
        next_stats_rx_pkts = next_stats_rx_pkts + 32'b1;
    end
 
end
 
endmodule
