`include "fifo.v"

module tb #(parameter depth = 4,width = 3,ptr_width = $clog2(depth));
	reg clk_i,rst_i,wr_en_i,rd_en_i;
	reg [width-1:0] wdata_i;

	wire [width-1:0] rdata_o; 
	wire full_o,empty_o,overflow_o,underflow_o;

	integer i;
	reg [8*10:0] testcase;

fifo #(.depth(depth),.width(width),.ptr_width(ptr_width)) dut(
					.clk_i(clk_i),
					.rst_i(rst_i),
					.wr_en_i(wr_en_i),
					.rd_en_i(rd_en_i),
					.wdata_i(wdata_i),
					.rdata_o(rdata_o),
					.full_o(full_o),
					.empty_o(empty_o),
					.overflow_o(overflow_o),
					.underflow_o(underflow_o));

	always #5 clk_i = ~clk_i;


	task reset();
		 begin
			  wdata_i = 0;
			  wr_en_i = 0;
			  rd_en_i = 0;
			  rst_i = 1;

			  repeat(2) @(negedge clk_i);
			  rst_i = 0;
		 end
	endtask

	task write(input integer num);
		 begin
			  for(i=0;i<num;i=i+1) begin
				   @(negedge clk_i);
				   wr_en_i = 1;
				   wdata_i = $random();
			  end

		 end
	endtask

	task read(input integer num);
		 begin
			  for(i=0;i<num;i=i+1) begin
				   @(negedge clk_i);
				   rd_en_i = 1;
			  end
		 end
	endtask

	initial begin
		 clk_i = 0;
		 reset();

		 if(!$value$plusargs("testcase=%s",testcase))
			  $display("FAILED TO GET TESTCASE FROM THE USER");



		 case(testcase)
			  "FULL": write(depth);
			  "EMPTY": begin
				   write(depth);
				   read(depth);
			  end

			  "OVERFLOW": write(depth+1);
			  "UNDERFLOW": begin
				   write(depth+1);
				   read(depth+1);
			  end

			  default: $display("NO TC");
		 endcase

	end

	initial #1000 $finish();

endmodule
