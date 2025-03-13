module fpga_top (
    input logic sysclk,

    output logic [3:0] led_r,
    output logic [3:0] led_b,

    input logic [1:0] sw,
    input logic [2:0] btn
);

  logic clk;
  logic locked;
  clk_wiz_0 clk_gen (
      .clk_in1 (sysclk),
      .clk_out1(clk),

      .reset(sw[0]),
      .locked
  );


  logic mem_we;
  logic [7:0] mem_dout;
  logic [9:0] mem_addr;


  hippo_memory #(
      .INIT_FILE("MEM_FILE.mem")
  ) memory (
      .clk_i(clk),
      .rst_i(sw[1]),

      .addr_i(mem_addr),
      .we_i  (mem_we),

      .data_i('hA7),

      .data_o(mem_dout)
  );

  // Interface with the memory via buttons.
  // This is designed around the Arty A7 dev board.
  // The memory is instantiated with the contents of the file "MEM_FILE.mem"
  //
  // The contents of the memory at the current address is displayed
  // Using the RGB LEDs as a bit display. I.e. LED[0] Red channel corresponds
  // to bit 0 of the value, LED[0] Blue channel corresponds to bit 4 of the
  // value.
  //
  // The memory address starts at 0 and can be incremented by 1 using button
  // 0. The memory address can also be reset back to 0 using button 1.
  //
  // The value under the current address can be overwritten with 'hA7
  // by pressing button 2.

  logic button_released;
  assign led_r = mem_dout[3:0];
  assign led_b = mem_dout[7:4];

  always_ff @(posedge clk) begin
    if (sw[1]) begin
      mem_addr <= 0;
      button_released <= 1;
      mem_we <= 0;
    end else if (btn[0] && button_released) begin
      mem_addr <= mem_addr + 1;
      button_released <= 0;
    end else if (btn[1] && button_released) begin
      mem_addr <= 0;
      button_released <= 0;
    end else if (btn[2] && button_released) begin
      mem_we <= 1;
      button_released <= 0;
    end else if (!btn[0] && !btn[1] && !btn[2]) begin
      button_released <= 1;
      mem_we <= 0;
    end
  end

endmodule

