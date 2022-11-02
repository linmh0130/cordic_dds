`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 21:34:55
// Design Name: 
// Module Name: cordic_sin_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic_sin_tb();
    reg rst_n = 1'b1;
    reg I_clk = 1'b0;
    reg [13:0] phase = -14'd1024; // -45deg
    wire [13:0] S_cos;
    wire [13:0] S_sin;

always #5 I_clk = ~I_clk;
cordic_sin cordic_sin_inst(
    .I_rst_n(rst_n),        // synchronization reset
    .I_clk(I_clk),          // clock
    .I_phase(phase),        // phase to be calculate
    .O_cos(S_cos),          // output cos data
    .O_sin(S_sin)          // output sin data
    );

endmodule
