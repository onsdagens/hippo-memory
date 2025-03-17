// mem
`timescale 1ns / 1ps

module interleaved_memory
  import config_pkg::*;
  import mem_pkg::*;
(
    //input logic clk,
    input logic clk_i,
    //input logic reset,
    input logic rst_i,
    //input mem_width_t width,
    input mem_width_t width_i,
    //input logic sign_extend,
    input logic sign_extend_i,
    //input logic [DMemAddrWidth-1:0] addr,
    input logic [DMemAddrWidth-1:0] addr_i,
    //input logic [31:0] data_in,
    input logic [31:0] data_i,
    //input logic write_enable,
    input logic write_enable_i,
    //output logic [31:0] data_out
    output logic [31:0] data_o
);
  logic [DMemAddrWidth-1:0] address_clocked;
  mem_width_t width_clocked;
  logic sign_extend_clocked;
  logic [7:0] block_0_dout;
  logic [7:0] block_1_dout;
  logic [7:0] block_2_dout;
  logic [7:0] block_3_dout;
  logic [7:0] block_0_din;
  logic [7:0] block_1_din;
  logic [7:0] block_2_din;
  logic [7:0] block_3_din;
  logic [DMemAddrWidth-2:0] block_0_addr;
  logic [DMemAddrWidth-2:0] block_1_addr;
  logic [DMemAddrWidth-2:0] block_2_addr;
  logic [DMemAddrWidth-2:0] block_3_addr;
  logic block_0_we;
  logic block_1_we;
  logic block_2_we;
  logic block_3_we;

  hippo_memory #(
      .MemFileName("data_0.mem")
  ) block_0 (
      .clk_i (clk_i),
      .rst_i (rst_i),
      .addr_i(block_0_addr),
      .we_i  (block_0_we),
      .data_i(block_0_din),
      .data_o(block_0_dout)
  );
  hippo_memory #(
      .MemFileName("data_1.mem")
  ) block_1 (
      .clk_i (clk_i),
      .rst_i (rst_i),
      .addr_i(block_1_addr),
      .we_i  (block_1_we),
      .data_i(block_1_din),
      .data_o(block_1_dout)
  );
  hippo_memory #(
      .MemFileName("data_2.mem")
  ) block_2 (
      .clk_i (clk_i),
      .rst_i (rst_i),
      .addr_i(block_2_addr),
      .we_i  (block_2_we),
      .data_i(block_2_din),
      .data_o(block_2_dout)
  );
  hippo_memory #(
      .MemFileName("data_3.mem")
  ) block_3 (
      .clk_i (clk_i),
      .rst_i (rst_i),
      .addr_i(block_3_addr),
      .we_i  (block_3_we),
      .data_i(block_3_din),
      .data_o(block_3_dout)
  );
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      address_clocked <= 0;
      width_clocked <= WORD;
      sign_extend_clocked <= 0;
    end
    sign_extend_clocked <= sign_extend_i;
    width_clocked <= width_i;
    address_clocked <= addr_i;
  end
  always_comb begin
    //this never happens since all possible modulo results are handled, but vivado still infers a latch if this is not defined
    block_0_we = 0;
    block_1_we = 0;
    block_2_we = 0;
    block_3_we = 0;
    if (addr % 4 == 1) begin
      block_0_addr = addr_i[DMemAddrWidth-1:2] + 1;
      block_1_addr = addr_i[DMemAddrWidth-1:2];
      block_2_addr = addr_i[DMemAddrWidth-1:2];
      block_3_addr = addr_i[DMemAddrWidth-1:2];
      block_0_din  = data_i[31:24];
      block_1_din  = data_i[7:0];
      block_2_din  = data_i[15:8];
      block_3_din  = data_i[23:16];
      if (write_enable_i) begin
        case (width_i)
          BYTE: begin
            block_0_we = 0;
            block_1_we = 1;
            block_2_we = 0;
            block_3_we = 0;
          end
          HALFWORD: begin
            block_0_we = 0;
            block_1_we = 1;
            block_2_we = 1;
            block_3_we = 0;
          end
          WORD: begin
            block_0_we = 1;
            block_1_we = 1;
            block_2_we = 1;
            block_3_we = 1;
          end
          default: begin
            block_0_we = 0;
            block_1_we = 0;
            block_2_we = 0;
            block_3_we = 0;
          end
        endcase
      end
    end else if (addr_i % 4 == 2) begin
      block_0_addr = addr_i[DMemAddrWidth-1:2] + 1;
      block_1_addr = addr_i[DMemAddrWidth-1:2] + 1;
      block_2_addr = addr_i[DMemAddrWidth-1:2];
      block_3_addr = addr_i[DMemAddrWidth-1:2];
      block_0_din  = data_i[23:16];
      block_1_din  = data_i[31:24];
      block_2_din  = data_i[7:0];
      block_3_din  = data_i[15:8];
      case (width_i)
        BYTE: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 1;
          block_3_we = 0;
        end
        HALFWORD: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 1;
          block_3_we = 1;
        end
        WORD: begin
          block_0_we = 1;
          block_1_we = 1;
          block_2_we = 1;
          block_3_we = 1;
        end
        default: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 0;
        end
      endcase
    end else if (addr_i % 4 == 3) begin
      block_0_addr = addr_i[DMemAddrWidth-1:2] + 1;
      block_1_addr = addr_i[DMemAddrWidth-1:2] + 1;
      block_2_addr = addr_i[DMemAddrWidth-1:2] + 1;
      block_3_addr = addr_i[DMemAddrWidth-1:2];
      block_0_din  = data_i[15:8];
      block_1_din  = data_i[23:16];
      block_2_din  = data_i[31:24];
      block_3_din  = data_i[7:0];
      case (width_i)
        BYTE: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 1;
        end
        HALFWORD: begin
          block_0_we = 1;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 1;
        end
        WORD: begin
          block_0_we = 1;
          block_1_we = 1;
          block_2_we = 1;
          block_3_we = 1;
        end
        default: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 0;
        end
      endcase
    end else if (addr_i % 4 == 0) begin
      block_0_addr = addr_i[DMemAddrWidth-1:2];
      block_1_addr = addr_i[DMemAddrWidth-1:2];
      block_2_addr = addr_i[DMemAddrWidth-1:2];
      block_3_addr = addr_i[DMemAddrWidth-1:2];
      block_0_din  = data_i[7:0];
      block_1_din  = data_i[15:8];
      block_2_din  = data_i[23:16];
      block_3_din  = data_i[31:24];
      case (width_i)
        BYTE: begin
          block_0_we = 1;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 0;
        end
        HALFWORD: begin
          block_0_we = 1;
          block_1_we = 1;
          block_2_we = 0;
          block_3_we = 0;
        end
        WORD: begin
          block_0_we = 1;
          block_1_we = 1;
          block_2_we = 1;
          block_3_we = 1;
        end
        default: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 0;
        end
      endcase
    end
    if (!write_enable_i) begin
      block_0_we = 0;
      block_1_we = 0;
      block_2_we = 0;
      block_3_we = 0;
    end
    if (address_clocked % 4 == 1) begin
      data_o = {block_0_dout, block_3_dout, block_2_dout, block_1_dout};
    end else if (address_clocked % 4 == 2) begin
      data_o = {block_1_dout, block_0_dout, block_3_dout, block_2_dout};
    end else if (address_clocked % 4 == 3) begin
      data_o = {block_2_dout, block_1_dout, block_0_dout, block_3_dout};
    end else if (address_clocked % 4 == 0) begin
      data_o = {block_3_dout, block_2_dout, block_1_dout, block_0_dout};
    end
    case (width_clocked)
      BYTE: begin
        if (sign_extend_clocked) begin
          data_o = signed'(data_o[7:0]);
        end else begin
          data_o = unsigned'(data_o[7:0]);
        end
      end
      HALFWORD: begin
        if (sign_extend_clocked) begin
          data_o = signed'(data_o[15:0]);
        end else begin
          data_o = unsigned'(data_o[15:0]);
        end
      end
      WORD: begin
        // sign extension doesnt matter for word wide access
      end
      default: begin
      end
    endcase
  end

endmodule
