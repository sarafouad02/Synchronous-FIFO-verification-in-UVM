
package FIFO_sequence_pkg;
	
	`include "uvm_macros.svh"
	import FIFO_sequence_item_pkg::*;
	//import shared_pkg_FIFO::*;

	import uvm_pkg::*;
	class FIFO_sequence_reset extends uvm_sequence #(FIFO_sequence_item);  //name of sequence item class
		`uvm_object_utils(FIFO_sequence_reset)
		FIFO_sequence_item FIFO_sqi_reset;
		function new(string name= "FIFO_sequence_reset");
			super.new(name);
		endfunction

		task body();
			FIFO_sqi_reset=FIFO_sequence_item::type_id::create("FIFO_sqi_reset");
			start_item(FIFO_sqi_reset);
			FIFO_sqi_reset.rst_n=0;
			FIFO_sqi_reset.data_in=0;
			FIFO_sqi_reset.wr_en=0;
			FIFO_sqi_reset.rd_en=0;
			finish_item(FIFO_sqi_reset);
		endtask
	endclass
	class FIFO_sequence_write_only extends uvm_sequence #(FIFO_sequence_item);

		`uvm_object_utils(FIFO_sequence_write_only)

		FIFO_sequence_item FIFO_write_only_item;

		function new(string name= "FIFO_sequence_write_only");
			super.new(name);
		endfunction
		task body();
			repeat(1000) begin
				FIFO_write_only_item=FIFO_sequence_item::type_id::create("FIFO_write_only_item");
				start_item(FIFO_write_only_item);
				FIFO_write_only_item.randomize() with { FIFO_write_only_item.wr_en == 1; FIFO_write_only_item.rd_en == 0; };
				finish_item(FIFO_write_only_item);
			end
		endtask
	endclass

class FIFO_sequence_read_only extends uvm_sequence #(FIFO_sequence_item);

		`uvm_object_utils(FIFO_sequence_read_only)

		FIFO_sequence_item FIFO_read_only_item;

		function new(string name= "FIFO_sequence_read_only");
			super.new(name);
		endfunction
		task body();
			repeat(1000) begin
				FIFO_read_only_item=FIFO_sequence_item::type_id::create("FIFO_read_only_item");
				start_item(FIFO_read_only_item);
				FIFO_read_only_item.randomize() with { FIFO_read_only_item.wr_en == 0; FIFO_read_only_item.rd_en == 1; };
				finish_item(FIFO_read_only_item);
			end
		endtask
	endclass

class FIFO_sequence_read_write extends uvm_sequence #(FIFO_sequence_item);

		`uvm_object_utils(FIFO_sequence_read_write)

		FIFO_sequence_item FIFO_read_write_item;

		function new(string name= "FIFO_sequence_read_write");
			super.new(name);
		endfunction
		task body();
			repeat(10000) begin
				FIFO_read_write_item=FIFO_sequence_item::type_id::create("FIFO_read_write_item");
				start_item(FIFO_read_write_item);
				FIFO_read_write_item.randomize();
				finish_item(FIFO_read_write_item);
			end
		endtask
	endclass

	
endpackage 
