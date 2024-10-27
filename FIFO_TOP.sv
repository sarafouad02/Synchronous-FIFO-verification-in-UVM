import uvm_pkg::*;
import FIFO_test_pkg::*;
`include "uvm_macros.svh"
module FIFO_TOP ();
bit clk;
initial begin
    clk=0;
    forever
    begin
         #1 clk=~clk;
     end
  end

  FIFO_if 			f_if(clk);
  // tb_FIFO 			tb(f_if);
  FIFO   			dut( clk,
   f_if.rst_n, 
   f_if.data_in, 
   f_if.wr_en, 
   f_if.rd_en,
   f_if.data_out, 
   f_if.wr_ack, 
   f_if.overflow, 
   f_if.full, 
   f_if.empty, 
   f_if.almostfull,
   f_if.almostempty, 
   f_if.underflow
    );
  bind FIFO FIFO_SVA FIFO_sva_inst(
    
   clk,
   f_if.rst_n, 
   f_if.data_in, 
   f_if.wr_en, 
   f_if.rd_en,
   f_if.data_out, 
   f_if.wr_ack, 
   f_if.overflow, 
   f_if.full, 
   f_if.empty, 
   f_if.almostfull,
   f_if.almostempty, 
   f_if.underflow
    );
  // FIFO_monitor 		monitor(f_if);

  initial begin
    uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_IF",f_if);
    run_test("FIFO_test");
end


endmodule : FIFO_TOP
