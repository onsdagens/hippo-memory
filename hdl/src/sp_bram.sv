module sp_bram #(
    parameter string INIT_FILE = "",
    parameter int unsigned NB_COL = 4,  // Specify number of columns (number of bytes)
    parameter int unsigned COL_WIDTH = 8,  // Specify column width (byte width, typically 8 or 9)
    parameter int unsigned RAM_DEPTH = 1024,  // Specify RAM depth (number of entries)
    localparam int unsigned DataWidth = NB_COL * COL_WIDTH
) (
    input  logic                         clk_i,
    input  logic                         rst_ni,
    input  logic                         req_i,
    input  logic [$clog2(RAM_DEPTH)-1:0] addr_i,
    input  logic [        DataWidth-1:0] wdata_i,
    input  logic [           NB_COL-1:0] bwe_i,
    output logic [        DataWidth-1:0] rdata_o
);

  (* ram_style = "block" *)
  logic [DataWidth-1:0] BRAM[RAM_DEPTH];
  //logic [$clog2(RAM_DEPTH)-1:0] addr_q;

  generate
    integer ram_index;
    initial begin
      if (INIT_FILE == "") begin
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index++)
        BRAM[ram_index] = {(DataWidth) {1'b0}};
      end else begin
        $readmemh(INIT_FILE, BRAM);
      end
    end
  endgenerate

  for (genvar i = 0; i < NB_COL; i = i + 1) begin : g_byte_write
    always @(posedge clk_i) begin
      if (req_i)
        if (bwe_i[i]) begin
          BRAM[addr_i][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= wdata_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
        end
    end
  end : g_byte_write

  always_ff @(posedge clk_i) begin
    if (~rst_ni) rdata_o <= '0;
    else if (req_i) rdata_o <= BRAM[addr_i];
  end

endmodule
