# FPGA Example

This directory contains a synthesizeable minimal usage example of Hippo memory.  

The example shows an interface with the memory via buttons.
This is designed around the Arty A7 dev board.
The memory is instantiated with the contents of the file "MEM_FILE.mem"

The content of the memory at the current address is displayed
Using the RGB LEDs as a bit display. I.e. LED[0] Red channel corresponds
to bit 0 of the value, LED[0] Blue channel corresponds to bit 4 of the
value.

The memory address starts at 0 and can be incremented by 1 using button
0. The memory address can also be reset back to 0 using button 1.

The value under the current address can be overwritten with 'hA7
by pressing button 2.
