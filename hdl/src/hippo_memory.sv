module hippo_memory #(
    parameter string INIT_FILE = "",
    parameter integer BRAM_WIDTH_BITS = 8,
    parameter integer BRAM_DEPTH = 1024,
    localparam integer AddrWidth = $clog2(BRAM_DEPTH)
) (
    input logic clk_i,
    input logic rst_i,

    input [AddrWidth-1:0] addr_i,

    input logic we_i,

    input logic [BRAM_WIDTH_BITS-1:0] data_i,


    output logic [BRAM_WIDTH_BITS-1:0] data_o
);
  logic [(BRAM_WIDTH_BITS/8)-1:0] we;
  generate
    genvar i;
    for (i = 0; i < BRAM_WIDTH_BITS / 8; i++) begin : gen_we
      assign we[i] = we_i;
    end : gen_we
  endgenerate
  sp_bram #(
      .INIT_FILE(INIT_FILE),
      .NB_COL(BRAM_WIDTH_BITS / 8),
      .RAM_DEPTH(BRAM_DEPTH)
  ) bram (
      .clk_i,
      .rst_ni(~rst_i),

      // we are probably fine with
      // tying this to 1?
      .req_i(1),

      .wdata_i(data_i),

      .addr_i(addr_i),

      // yes ?
      .bwe_i(we_i),

      .rdata_o(data_o)
  );

endmodule
