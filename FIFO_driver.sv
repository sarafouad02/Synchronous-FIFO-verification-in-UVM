package FIFO_driver_pkg;
	//import shared_pkg_FIFO::*;
	import uvm_pkg::*;
	import FIFO_config_pkg::*;
	//import shift_config::*;
	`include "uvm_macros.svh"
	//import FIFO_sequencer_pkg::*;
	import FIFO_sequence_item_pkg::*;
	class FIFO_driver extends uvm_driver #(FIFO_sequence_item);
		`uvm_component_utils(FIFO_driver)
		//virtual alsu_interface alsu_driver_vif;
		FIFO_config_object FIFO_config_obj_driver;
		virtual FIFO_if FIFO_vif;
		FIFO_sequence_item FIFO_seq_item;

		//virtual alsu_interface alsu_driver_vif;

	function new (string name = "FIFO_driver", uvm_component parent = null);
			super.new(name,parent);	
		endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);	
		forever begin
		
		FIFO_seq_item=FIFO_sequence_item::type_id::create("FIFO_seq_item");
		@(negedge FIFO_vif.clk);
		//#1;
		seq_item_port.get_next_item(FIFO_seq_item);
		FIFO_vif.rst_n = FIFO_seq_item.rst_n;
		FIFO_vif.data_in= FIFO_seq_item.data_in;
		FIFO_vif.wr_en= FIFO_seq_item.wr_en;
		FIFO_vif.rd_en=FIFO_seq_item.rd_en;
				seq_item_port.item_done();
		`uvm_info("run_phase",FIFO_seq_item.convert2string_stimulus(), UVM_HIGH)
	end
endtask : run_phase


endclass 
	
endpackage 

