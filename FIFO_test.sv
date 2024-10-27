package FIFO_test_pkg;
	import uvm_pkg::*;
	import FIFO_env_pkg::*;
	import FIFO_config_pkg::*;
	import FIFO_sequence_pkg::*;
	//import FIFO_agent_pkg::*;
	//import shared_pkg_FIFO::*;
	
	//import shift_config::*;
	`include "uvm_macros.svh"

	class FIFO_test extends  uvm_test;
		`uvm_component_utils(FIFO_test)

		//virtual FIFO_interface FIFO_test_vif;
		FIFO_env FIFO_env_obj ;
		FIFO_config_object FIFO_config_obj_test;
		FIFO_sequence_reset reset_seq;
		FIFO_sequence_write_only write_only_seq;	
		FIFO_sequence_read_only read_only_seq;
		FIFO_sequence_read_write read_write_seq;
		function new (string name = "FIFO_test", uvm_component parent = null);
			super.new(name,parent);	
		endfunction 
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		FIFO_env_obj = FIFO_env::type_id::create("FIFO_env_obj",this);
		FIFO_config_obj_test= FIFO_config_object::type_id::create("FIFO_config_obj_test",this);	
		reset_seq=FIFO_sequence_reset::type_id::create("reset_seq", this);
		write_only_seq=FIFO_sequence_write_only::type_id::create("write_only_seq", this);
		read_only_seq=FIFO_sequence_read_only::type_id::create("read_only_seq", this);
		read_write_seq=FIFO_sequence_read_write::type_id::create("read_write_seq", this);
		
if (!uvm_config_db#(virtual FIFO_if)::get(this , "", "FIFO_IF",FIFO_config_obj_test.FIFO_config_vif))
        `uvm_fatal("build_phase", "Virtual interface not found");

      // Set the virtual interface for components
      uvm_config_db#(FIFO_config_object)::set(this, "*", "CFG", FIFO_config_obj_test);

	endfunction :build_phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		`uvm_info("run_phase","reset asserted", UVM_LOW)
		reset_seq.start(FIFO_env_obj.agt.sqr);
		`uvm_info("run_phase","reset deasserted", UVM_LOW)
		//write_only sequence
		`uvm_info("run_phase","write_only started", UVM_LOW)
		write_only_seq.start(FIFO_env_obj.agt.sqr);
		`uvm_info("run_phase","write_only finished", UVM_LOW)
		//read_only sequence
		`uvm_info("run_phase","read_only started", UVM_LOW)
		read_only_seq.start(FIFO_env_obj.agt.sqr);
		`uvm_info("run_phase","read_only finished", UVM_LOW)
		//read_write sequence
		`uvm_info("run_phase","read_write started", UVM_LOW)
		read_write_seq.start(FIFO_env_obj.agt.sqr);
		`uvm_info("run_phase","read_write finished", UVM_LOW)


		phase.drop_objection(this);
	endtask : run_phase

	endclass : FIFO_test
	
endpackage : FIFO_test_pkg
