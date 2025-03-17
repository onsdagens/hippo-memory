module tb_interleaved;
  import mem_cfg_pkg::*;


  logic clk;
  logic rst;

  mem_width_t mem_width;
  logic [9:0] mem_addr;
  logic mem_we;

  logic [31:0] mem_din;
  logic [31:0] mem_dout;
  interleaved_memory #() dut (
      .clk_i(clk),
      .rst_i(rst),

      .width_i(mem_width),
      .sign_extend_i(0),  // let's not sign extend
      .addr_i(mem_addr),
      .write_enable_i(mem_we),

      .data_i(mem_din),

      .data_o(mem_dout)
  );


  always #10 clk = ~clk;

  initial begin
    $dumpfile("spram.fst");
    $dumpvars;

    clk = 0;
    rst = 1;
    mem_addr = 0;
    mem_we = 0;
    mem_width = BYTE;
    mem_din = 0;
    #20;
    rst = 0;
    #20;
    mem_addr = 0;
    mem_we = 1;
    mem_width = BYTE;
    mem_din = 'hA7;
    #20;
    mem_we = 0;
    #20;
    mem_addr = 4;
    mem_width = WORD;
    mem_din = 'h0DEFACED;
    mem_we = 1;
    #20;
    mem_we = 0;
    #20;
    mem_addr = 0;
    #20;
    assert(mem_dout == 'hA7);
    mem_addr = 4;
    #20;
    assert(mem_dout == 'h0DEFACED);
    mem_addr = 3;
    #20;
    assert(mem_dout == 'hEFACED00);
    mem_addr = 2;
    #20;
    assert(mem_dout == 'hACED0000);
    mem_addr = 1;
    #20;
    assert(mem_dout == 'hED000000);
    mem_din = 'h13;
    mem_addr = 2;
    mem_we = 1;
    mem_width = BYTE;
    #20;
    mem_we = 0;
    mem_addr = 1;
    mem_width = WORD;
    #20;
    assert(mem_dout == 'hed001300);
    #20;
    
    $finish;
  end
endmodule
