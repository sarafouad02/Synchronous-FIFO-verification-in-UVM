interface FIFO_if (clk);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
	input bit clk;
	logic [FIFO_WIDTH-1:0] data_in;
	logic rst_n, wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow;
	logic full, empty, almostfull, almostempty, underflow;

//modport DUT (input clk, rst_n, wr_en, rd_en, data_in , output wr_ack,overflow, full,empty, almostfull, almostempty, underflow, data_out);

// modport TEST (output rst_n, wr_en, rd_en, data_in, input wr_ack,overflow, full,empty, almostfull, almostempty, underflow, data_out, clk);

// modport monitor (input clk, rst_n, wr_en, rd_en, data_in,wr_ack,overflow, full,empty, almostfull, almostempty, underflow, data_out);

endinterface : FIFO_if
