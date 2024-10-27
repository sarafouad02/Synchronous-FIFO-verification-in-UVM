
package FIFO_sequence_item_pkg;
	//import shared_pkg_FIFO::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class FIFO_sequence_item extends uvm_sequence_item;
		`uvm_object_utils(FIFO_sequence_item)
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	rand logic [FIFO_WIDTH-1:0] data_in;
	rand logic rst_n, wr_en, rd_en;
	 logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow;
	 logic full, empty, almostfull, almostempty, underflow;
	 integer RD_EN_ON_DIST=30;
	 integer WR_EN_ON_DIST=70;

function new(string name = "FIFO_sequence_item");
	super.new(name);
endfunction 

	function string convert2string();
		return $sformatf("%s rst = 0b%0b,data in=%s,wr_en= 0b%0b, rd_en=0b%0b, data_out=0b%0b, wr_ack=0b%0b, full=0b%0b,
			empty= 0b%0b, almostfull=0b%0b, almostempty=0b%0b,underflow= 0b%b, overflow=0b%b",
			super.convert2string(),rst_n,data_in, wr_en ,rd_en, data_out, wr_ack, full,empty, almostfull,almostempty, underflow, overflow);
		endfunction 

	function string convert2string_stimulus();
		return $sformatf(" rst = 0b%0b,data_in=%s, wr_en = 0b%0b, rd_en=0b%0b",rst_n, data_in, wr_en ,rd_en);
	endfunction

	constraint c {
	rst_n dist{1:=98, 0:=2};

	wr_en dist {1:=WR_EN_ON_DIST, 0:= (100 - WR_EN_ON_DIST)};
	rd_en dist {1:=RD_EN_ON_DIST, 0:= (100 - RD_EN_ON_DIST)};

	}

	endclass 
	
endpackage 

