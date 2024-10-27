////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(clk,rst_n, data_in, wr_en, rd_en,data_out, wr_ack, overflow, full, empty, almostfull,almostempty, underflow);
 parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
  input bit clk;
  input [FIFO_WIDTH-1:0] data_in;
  input rst_n, wr_en, rd_en;
  output reg [FIFO_WIDTH-1:0] data_out;
  output reg wr_ack, overflow,underflow;
  output full, empty, almostfull, almostempty;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
    wr_ack <= 0;
    overflow <= 0;
		for(int i=0; i<FIFO_DEPTH;i++)       
		mem[i]<=0;
	end
	else if ((wr_en && count < FIFO_DEPTH) )begin  
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		wr_ack <= 0; 
		if (full & wr_en)    
			overflow <= 1;
		else
			overflow <= 0;
	end
end
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
    underflow<=1'b0;
	end
	else if ((rd_en && count!=0)) begin 
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
  else begin
    if(empty && rd_en)   //correction
      underflow<=1'b1;
    else
      underflow<=1'b0;
  end
end
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		else if (({wr_en, rd_en} == 2'b11) && empty && !full)      
			count <= count + 1;
		else if(({wr_en, rd_en} == 2'b11)&& !empty &&full )
			count<=count-1;
	end
end
assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count==0)? 1 : 0;
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; // correction
assign almostempty = (count == 1)? 1 : 0;

///////////////////////////Assertions/////////////////////////////////////////////////////
  always_comb begin
    // Full flag should only be high when count == FIFO_DEPTH
    if (count == FIFO_DEPTH) begin
        assert (full) else $error("Assertion failed: Full flag is incorrect");
    end
    cover (full) $display("Coverage: Full flag asserted");

    // Empty flag should only be high when count == 0
    if (count == 0) begin
        assert (empty) else $error("Assertion failed: Empty flag is incorrect");
    end
    cover (empty) $display("Coverage: Empty flag asserted");

    // Almost full flag should only be high when count == FIFO_DEPTH - 2
    if (count == FIFO_DEPTH - 1) begin
        assert (almostfull) else $error("Assertion failed: Almost full flag is incorrect");
    end
    cover (almostfull) $display("Coverage: Almost full flag asserted");

    // Almost empty flag should only be high when count == 1
    if (count == 1) begin
        assert (almostempty) else $error("Assertion failed: Almost empty flag is incorrect");
    end
    cover (almostempty) $display("Coverage: Almost empty flag asserted");
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   // Count should be between 0 and FIFO_DEPTH
//   property p_valid_count;
//     @(posedge clk) disable iff (!rst_n)
//     (count <= FIFO_DEPTH);
//   endproperty
//   assert property (p_valid_count) else $error("Assertion failed: Invalid count value");
//   cover property (p_valid_count);


// property overflow_p;
// 	@(posedge clk) disable iff (!rst_n)
// 	 (wr_en&& full)|=> (overflow==1);
//     endproperty
//     assert property (overflow_p) else $error("Assertion failed: Overflow is incorrect");
//     cover property (overflow_p) $display("Coverage: Overflow asserted");

// property underflow_p;
//   @(posedge clk) disable iff (!rst_n)
//    (empty && rd_en)|=> (underflow==1);
//     endproperty
//     assert property (underflow_p) else $error("Assertion failed: underflow is incorrect");
//     cover property (underflow_p) $display("Coverage: underflow asserted");

//     property wr_ack_p;
//   @(posedge clk) disable iff (!rst_n)
//    (wr_en && count < FIFO_DEPTH)|=> (wr_ack==1);
//     endproperty
//     assert property (wr_ack_p) else $error("Assertion failed: wr_ack is incorrect");
//     cover property (wr_ack_p) $display("Coverage: wr_ack asserted");


//   // Write pointer should be valid (within FIFO depth)
//   property p_valid_wr_ptr;
//     @(posedge clk) disable iff (!rst_n)
//     (wr_ptr < FIFO_DEPTH);
//   endproperty
//   assert property (p_valid_wr_ptr) else $error("Assertion failed: Write pointer is out of bounds");
//   cover property (p_valid_wr_ptr);

//   // Read pointer should be valid (within FIFO depth)
//   property p_valid_rd_ptr;
//     @(posedge clk) disable iff (!rst_n)
//     (rd_ptr < FIFO_DEPTH);
//   endproperty
//   assert property (p_valid_rd_ptr) else $error("Assertion failed: Read pointer is out of bounds");
//   cover property (p_valid_rd_ptr);

endmodule