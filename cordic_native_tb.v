`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 22:34:25
// Design Name: 
// Module Name: cordic_native_tb
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


module cordic_native_tb();

reg rst_n = 1'b1;
reg I_clk = 1'b0;
reg [13:0] phase = -14'd2048;   // -90deg
reg [13:0] inc_phase = 14'd2; //
reg change_phase = 1'b0; 
wire [13:0] S_cos;
wire [13:0] S_sin;

initial begin
    //#2 change_phase = 1'b1;
    //#3 I_clk = 1'b1;
    //#5 I_clk = 1'b0;
    //#5 I_clk = 1'b1;
    //#0 change_phase = 1'b0;
end
always #5 I_clk = ~I_clk;


cordic_native cordic_native_inst(
        .I_rst_n(rst_n),                // synchronization reset
        .I_clk(I_clk),                  // clock
        .I_init_phase(phase),           // Initial phase
        .I_change_phase(change_phase),          // Indicate to change phase
        .I_inc_phase(inc_phase),            // Phase increasing step
        .O_cos(S_cos),                  // output cos data
        .O_sin(S_sin)                   // output sin data
        );

endmodule
