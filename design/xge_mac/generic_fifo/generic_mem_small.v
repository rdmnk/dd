// `include "defines.v"
 
/* synthesis ramstyle = "M512" */
 
module generic_mem_small(
 
    wclk,
    wrst_n,
    wen,
    waddr,
    wdata,
 
    rclk,
    rrst_n,
    ren,
    roen,
    raddr,
    rdata
);
 
//---
// Parameters
 
parameter DWIDTH = 32;
parameter AWIDTH = 3;
parameter RAM_DEPTH = (1 << AWIDTH);
parameter REGISTER_READ = 0;
 
//---
// Ports
 
input               wclk;
input               wrst_n;
input               wen;
input  [AWIDTH-1:0] waddr;
input  [DWIDTH-1:0] wdata;
 
input               rclk;
input               rrst_n;
input               ren;
input               roen;
input  [AWIDTH-1:0] raddr;
output [DWIDTH-1:0] rdata;
 
// Registered outputs
reg    [DWIDTH-1:0] rdata;
 
 
//---
// Local declarations
 
// Registers
 
reg  [DWIDTH-1:0] mem_rdata;
reg  [AWIDTH-1:0] raddr_d1;
 
 
// Memory
 
reg  [DWIDTH-1:0] mem [0:RAM_DEPTH-1];
 
// Variables
 
integer         i;
 
 
//---
// Memory Write
 
// Generate synchronous write
always @(posedge wclk)
begin
    if (wen) begin
        mem[waddr[AWIDTH-1:0]] <= wdata;
    end
end
 
//---
// Memory Read
 
// Generate registered memory read
 
`ifdef XIL
 
//always @(posedge rclk)
//begin
//    if (ren) begin
//        raddr_d1 <= raddr;
//    end
//end
//always @(raddr_d1, rclk)
//begin
//    mem_rdata = mem[raddr_d1[AWIDTH-1:0]];
//end
 
always @(posedge rclk)
begin
    if (!rrst_n) begin
        mem_rdata <= {(DWIDTH){1'b0}};
    end else if (ren) begin
        mem_rdata <= mem[raddr[AWIDTH-1:0]];
    end
end
 
`else
 
//always @(posedge rclk or negedge rrst_n)
//begin
//    if (!rrst_n) begin
//        mem_rdata <= {(DWIDTH){1'b0}};
//    end else if (ren) begin
//        mem_rdata <= mem[raddr[AWIDTH-1:0]];
//    end
//end
 
always @(posedge rclk)
begin
    if (ren) begin
        raddr_d1 <= raddr;
    end
end
always @(raddr_d1, rclk)
begin
    mem_rdata = mem[raddr_d1[AWIDTH-1:0]];
end
 
`endif
 
generate
    if (REGISTER_READ) begin
 
        // Generate registered output
        always @(posedge rclk or negedge rrst_n)
        begin
            if (!rrst_n) begin
                rdata <= {(DWIDTH){1'b0}};
            end else if (roen) begin
                rdata <= mem_rdata;
            end
        end
 
    end
    else begin
 
        // Generate unregisters output
        always @(mem_rdata)
        begin
            rdata = mem_rdata;
        end
 
    end
endgenerate
 
endmodule
