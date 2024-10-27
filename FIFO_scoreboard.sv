package FIFO_scoreboard_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import FIFO_sequencer_pkg::*;
	import FIFO_sequence_item_pkg::*;
	//import shared_pkg_FIFO::*;	

	class FIFO_scoreboard extends  uvm_scoreboard;
			`uvm_component_utils(FIFO_scoreboard)
			uvm_analysis_export #(FIFO_sequence_item) sb_export;
			uvm_tlm_analysis_fifo #(FIFO_sequence_item) sb_fifo;
			FIFO_sequence_item seq_item_sb;

parameter FIFO_DEPTH = 8;
		parameter FIFO_WIDTH = 16;
	 	logic [FIFO_WIDTH-1:0] data_out_ref; 
        logic full_ref;                         
        logic empty_ref;                         
        logic almostfull_ref;                 
        logic almostempty_ref;                  
        logic underflow_ref;                    
        logic wr_ack_ref;                      
        logic overflow_ref;   
        logic [FIFO_WIDTH-1:0] data_in_ref;
	    logic rst_n_ref, wr_en_ref, rd_en_ref;  
	    logic [FIFO_WIDTH-1:0] queue[$]; // Queue to store FIFO data


			integer error_count =0;
			integer correct_count =0;
	
	function new (string name = "FIFO_scoreboard", uvm_component parent = null);
		super.new(name,parent);	
	endfunction 
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sb_export = new("sb_export", this);
		sb_fifo=new("sb_fifo", this);
	endfunction

	 function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		sb_export.connect(sb_fifo.analysis_export);
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
		sb_fifo.get(seq_item_sb);
    
		ref_model(seq_item_sb);


		if(seq_item_sb.data_out != data_out_ref &&seq_item_sb.rst_n) begin
			`uvm_error("run_phase", $sformatf("comparison failed at time %0t,Transaction by DUT for out is:
       %s while reference is %b",$time,seq_item_sb.convert2string(), data_out_ref));
			error_count=error_count+1;
		end
		else begin
			`uvm_info("run_phase", $sformatf("correct data out: %s ",seq_item_sb.convert2string()), UVM_MEDIUM);
				correct_count=correct_count+1;
    end
		end
	endtask : run_phase
	task ref_model(FIFO_sequence_item FIFO_seq_item_chk);
		
logic [FIFO_WIDTH-1:0] temp_data_out; // Temporary variable for data out

    if (!rst_n_ref) begin
        queue = {}; // Clear the queue on reset
    end
    else begin
    	 // FIFO status signals
        full_ref = (queue.size() == FIFO_DEPTH);
        empty_ref = queue.empty();
        almostfull_ref = (queue.size() == FIFO_DEPTH-2);
        almostempty_ref = (queue.size() == 1);
        underflow_ref= (rd_en_ref&&queue.empty());
        overflow_ref= (wr_en_ref&&(queue.size() == FIFO_DEPTH));

        // Read operation
        if ((rd_en_ref &&!empty_ref)||(rd_en_ref&&wr_en_ref&&!empty_ref && full_ref)) begin
            
           data_out_ref = queue.pop_front(); // Read data from the front of the queue
        end
        // Write operation
        if ((wr_en_ref && !full_ref )||(wr_en_ref&&rd_en_ref&&empty_ref&& !full_ref)) 
         begin
            queue.push_back(data_in_ref);
        end  
    end    
endtask

function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("report_phase", $sformatf("total successful out transactions : %0d",correct_count), UVM_MEDIUM);
	`uvm_info("report_phase", $sformatf("total failed out transactions : %0d",error_count), UVM_MEDIUM);

endfunction
	endclass : FIFO_scoreboard
endpackage : FIFO_scoreboard_pkg



