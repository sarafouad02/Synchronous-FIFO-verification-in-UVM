package FIFO_coverage_collector_pkg;
    //import shared_pkg_FIFO::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import FIFO_sequencer_pkg::*;
	import FIFO_sequence_item_pkg::*;
	FIFO_sequence_item FIFO_seq_item;

	class FIFO_coverage_collector extends uvm_component;
		`uvm_component_utils(FIFO_coverage_collector)
		uvm_analysis_export #(FIFO_sequence_item) cov_export;
		uvm_tlm_analysis_fifo #(FIFO_sequence_item) cov_fifo;
		
	 covergroup FIFO_cg;
        // Bin for write_enable signal
        write_enable_cov : coverpoint FIFO_seq_item.wr_en {
            bins write_0 = {0};
            bins write_1 = {1};
        }
        // Bin for read_enable signal
        read_enable_cov : coverpoint FIFO_seq_item.rd_en {
            bins read_0 = {0};
            bins read_1 = {1};
        }
         // Coverpoint for overflow
        overflow_cov : coverpoint FIFO_seq_item.overflow {
            bins no_overflow = {0};
            bins has_overflow = {1};
        }
        // Coverpoint for full
        full_cov : coverpoint FIFO_seq_item.full {
            bins not_full = {0};
            bins is_full = {1};
        }

        // Coverpoint for empty
        empty_cov : coverpoint FIFO_seq_item.empty {
            bins not_empty = {0};
            bins is_empty = {1};
        }
        // Coverpoint for almost full
        almostfull_cov : coverpoint FIFO_seq_item.almostfull {
            bins not_almost_full = {0};
            bins is_almost_full = {1};
        }
        // Coverpoint for almost empty
        almostempty_cov : coverpoint FIFO_seq_item.almostempty {
            bins not_almost_empty = {0};
            bins is_almost_empty = {1};
        }
        // Coverpoint for underflow
        underflow_cov : coverpoint FIFO_seq_item.underflow {
            bins no_underflow = {0};
            bins has_underflow = {1};
        }
          // Coverpoint for ack
        wr_ack_cov : coverpoint FIFO_seq_item.wr_ack {
            bins no_wr_ack = {0};
            bins has_wr_ack = {1};
        }

         cross_rd_write_overflow: cross write_enable_cov, read_enable_cov, overflow_cov {

         // ignore_bins overflow_1_1_1= binsof(write_enable_cov.write_1)&&
         // binsof(read_enable_cov.read_1)&&binsof(overflow_cov.has_overflow);

         ignore_bins overflow_0_1_1 =binsof(write_enable_cov.write_0)&&
         binsof(read_enable_cov.read_1)&&binsof(overflow_cov.has_overflow);

         ignore_bins overflow_0_0_1 =binsof(write_enable_cov.write_0)&&
         binsof(read_enable_cov.read_0)&&binsof(overflow_cov.has_overflow);
         }

        cross_rd_write_full: cross write_enable_cov, read_enable_cov, full_cov{
        ignore_bins full_1_1_1 = binsof(write_enable_cov.write_1)&&
         binsof(read_enable_cov.read_1)&&binsof(full_cov.is_full);

         ignore_bins full_0_1_1 = binsof(write_enable_cov.write_0)&&
         binsof(read_enable_cov.read_1)&&binsof(full_cov.is_full);

        }
        cross_rd_write_empty: cross write_enable_cov, read_enable_cov, empty_cov;
        cross_rd_write_almostfull: cross write_enable_cov, read_enable_cov, almostfull_cov;
        cross_rd_write_almostempty: cross write_enable_cov, read_enable_cov, almostempty_cov;

        cross_rd_write_underflow: cross write_enable_cov, read_enable_cov, underflow_cov{
        ignore_bins underflow_1_0_1= binsof(write_enable_cov.write_1)&&
         binsof(read_enable_cov.read_0)&&binsof(underflow_cov.has_underflow);

          ignore_bins underflow_0_0_1= binsof(write_enable_cov.write_0)&&
         binsof(read_enable_cov.read_0)&&binsof(underflow_cov.has_underflow);
        }
        cross_rd_write_wr_ack: cross write_enable_cov, read_enable_cov, wr_ack_cov
        {

        ignore_bins wr_ack_0_0_1= binsof(write_enable_cov.write_0)&&
         binsof(read_enable_cov.read_0)&&binsof(wr_ack_cov.has_wr_ack);
          ignore_bins wr_ack_0_1_1= binsof(write_enable_cov.write_0)&&
         binsof(read_enable_cov.read_1)&&binsof(wr_ack_cov.has_wr_ack);
        
       }


        endgroup : FIFO_cg

	function new(string name = "FIFO_coverage_collector", uvm_component parent = null);
		super.new(name, parent);
		  FIFO_cg = new();
	endfunction : new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	cov_export = new("cov_export" ,this);
	cov_fifo = new("cov_fifo", this);
endfunction 
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	cov_export.connect(cov_fifo.analysis_export);	
endfunction

task run_phase(uvm_phase phase);
	super.connect_phase(phase);
	forever begin
		cov_fifo.get(FIFO_seq_item);
		FIFO_cg.sample();
	end
endtask
	endclass : FIFO_coverage_collector
endpackage : FIFO_coverage_collector_pkg


