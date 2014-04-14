module meta_sync(/*AUTOARG*/
  // Outputs
  out,
  // Inputs
  clk, reset_n, in
  );
 
parameter DWIDTH = 1;
parameter EDGE_DETECT = 0;
 
input                clk;
input                reset_n;
 
input  [DWIDTH-1:0]  in;
 
output [DWIDTH-1:0]  out;
 
generate
genvar               i;
 
    for (i = 0; i < DWIDTH; i = i + 1) begin : meta
 
        meta_sync_single #(.EDGE_DETECT (EDGE_DETECT))
          meta_sync_single0 (
                      // Outputs
                      .out              (out[i]),
                      // Inputs
                      .clk              (clk),
                      .reset_n          (reset_n),
                      .in               (in[i]));
 
    end
 
endgenerate
 
endmodule
