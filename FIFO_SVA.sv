module FIFO_SVA (clk, rst_n, data_in, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
	parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
	input  [FIFO_WIDTH-1:0] data_in;
	input rst_n, wr_en, rd_en;
	input bit clk;
	input  [FIFO_WIDTH-1:0] data_out;
	input wr_ack, overflow;
	input full, empty, almostfull, almostempty, underflow;

  always_comb begin
    // Full flag should only be high when   FIFO_TOP.dut.count == FIFO_DEPTH
    if (  FIFO_TOP.dut.count == FIFO_DEPTH) begin
        assert (full) else $error("Assertion failed: Full flag is incorrect");
    end
    cover (full) $display("Coverage: Full flag asserted");
    // Empty flag should only be high when   FIFO_TOP.dut.count == 0
    if (  FIFO_TOP.dut.count == 0) begin
        assert (empty) else $error("Assertion failed: Empty flag is incorrect");
    end
    cover (empty) $display("Coverage: Empty flag asserted");
    // Almost full flag should only be high when   FIFO_TOP.dut.count == FIFO_DEPTH - 2
    if (  FIFO_TOP.dut.count == FIFO_DEPTH - 1) begin
        assert (almostfull) else $error("Assertion failed: Almost full flag is incorrect");
    end
    cover (almostfull) $display("Coverage: Almost full flag asserted");
    // Almost empty flag should only be high when   FIFO_TOP.dut.count == 1
    if (  FIFO_TOP.dut.count == 1) begin
        assert (almostempty) else $error("Assertion failed: Almost empty flag is incorrect");
    end
    cover (almostempty) $display("Coverage: Almost empty flag asserted");
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////
property overflow_p;
	@(posedge clk) disable iff(!rst_n)
	 (wr_en&& full)|=> (overflow==1);
    endproperty
    assert property (overflow_p) else $error("Assertion failed: Overflow is incorrect");
    cover property (overflow_p) $display("Coverage: Overflow asserted");

property underflow_p;
  @(posedge clk) disable iff (!rst_n)
   (empty && rd_en)|=> (underflow==1);
    endproperty
    assert property (underflow_p) else $error("Assertion failed: underflow is incorrect");
    cover property (underflow_p) $display("Coverage: underflow asserted");

    property wr_ack_p;
  @(posedge clk) disable iff (!rst_n)
   (wr_en && FIFO_TOP.dut.count < FIFO_DEPTH)|=> (wr_ack==1);
    endproperty
    assert property (wr_ack_p) else $error("Assertion failed: wr_ack is incorrect");
    cover property (wr_ack_p) $display("Coverage: wr_ack asserted");
endmodule : FIFO_SVA
