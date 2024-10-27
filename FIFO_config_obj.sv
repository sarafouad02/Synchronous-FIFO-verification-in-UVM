package FIFO_config_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class FIFO_config_object extends uvm_object;
		`uvm_object_utils(FIFO_config_object)
		virtual FIFO_if FIFO_config_vif;

		function new(string name="FIFO_config_object");
		super.new(name);
		endfunction
	endclass
endpackage 

