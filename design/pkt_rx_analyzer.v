module pkt_rx_analyzer (
	input 		rst_b,
	input		clk,
	input 		avail,
	input 		val,
	input [63:0]	data,
	input 		eop,
	input 		sop,
	input [2:0]	mod,
	input 		err
);

reg [31:0] octet_num;

always @(posedge clk) begin
	if(!rst_b) begin
		octet_num <= 	32'b0;
	end
	else begin
		octet_num <= 	eop ? 32'b0 : 
				val ? octet_num + 1: octet_num;
	end
end

endmodule

