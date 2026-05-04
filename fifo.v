module fifo #(parameter depth = 4, width = 3, ptr_width = $clog2(depth)) 
(clk_i,rst_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,empty_o,overflow_o,underflow_o);
	
	input clk_i,rst_i,wr_en_i,rd_en_i;
	input [width-1:0] wdata_i;
	
	output reg [width-1:0] rdata_o;
	output reg full_o,empty_o,overflow_o,underflow_o;

	reg [ptr_width-1:0] wr_pntr,rd_pntr;
	reg wr_tggle,rd_tggle;

	reg [width-1:0] fifo [depth-1:0];
	integer i;

	always@(negedge clk_i) begin
		 if(rst_i) begin
			  full_o <= 0;
			  empty_o <= 1;
			  overflow_o <= 0;
			  underflow_o <= 0;
			  rdata_o <= 0;

			  {wr_pntr,rd_pntr, wr_tggle, rd_tggle} <= 0;

			  for(i=0;i<depth;i=i+1) fifo[i] <= 0;
		 end
		 else begin
			  if(wr_en_i) begin
				   if (full_o) overflow_o <= 1;
				   else begin
						fifo[wr_pntr] <= wdata_i;
						if(wr_pntr == depth-1) begin
							 wr_tggle <= ~wr_tggle;
							 wr_pntr <= 0;
						end
						else wr_pntr <= wr_pntr + 1;
				   end
			
			  end

			  if(rd_en_i) begin
				   if(empty_o) underflow_o <= 1;
				   else begin
						rdata_o <= fifo[rd_pntr];
						if(rd_pntr == depth-1) begin
							 	rd_tggle <= ~rd_tggle;
								rd_pntr <= 0;
						end
						else rd_pntr <= rd_pntr + 1;
				   end
		 	   end
		 end
	end

	always@(*) begin
		 empty_o = 0;
		 full_o = 0;

		 if(wr_pntr == rd_pntr && wr_tggle == rd_tggle) empty_o = 1;
		 if(wr_pntr == rd_pntr && wr_tggle != rd_tggle) full_o = 1;
	end
endmodule

