`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 20:38:39
// Design Name: NATIVE CORDIC DDS
// Module Name: cordic_native
// Project Name: cordic_pipeline
// Target Devices: xc7z010clg400-1
// Tool Versions: Vivado 2018.2
// Description: The native cordic dds module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define LOG2_ITER_N 5
`define ITER_N      13
`define QUAN_BIT    14

// Amp 2^14 * 0.9
`define COS_INIT    14'd4477
`define ATAN_1	     14'd1024
`define ATAN_2	     14'd605
`define ATAN_3	     14'd319
`define ATAN_4	     14'd162
`define ATAN_5	     14'd81
`define ATAN_6	     14'd41
`define ATAN_7	     14'd20
`define ATAN_8	     14'd10
`define ATAN_9	     14'd5
`define ATAN_10     14'd3
`define ATAN_11     14'd1
`define ATAN_12     14'd1
`define ATAN_13     14'd0

module cordic_native(
    I_rst_n,                // synchronization reset
    I_clk,                  // clock
    I_init_phase,           // Initial phase
    I_change_phase,          // Indicate to change phase
    I_inc_phase,            // Phase increasing step
    O_cos,                  // output cos data
    O_sin                   // output sin data
    );
    
    input wire I_rst_n;
    input wire I_clk;
    input wire [`QUAN_BIT - 1: 0] I_init_phase;
    input wire I_change_phase;
    input wire [`QUAN_BIT - 1: 0] I_inc_phase;
    output reg [`QUAN_BIT - 1: 0] O_cos;
    output reg [`QUAN_BIT - 1: 0] O_sin;
    
    reg [`QUAN_BIT - 1: 0] R_current_phase = 0;
    wire [`QUAN_BIT - 1: 0] S_cos;
    wire [`QUAN_BIT - 1: 0] S_sin;
    
    parameter DIR_FWD = 1'b0;
    parameter DIR_BAK = 1'b1;
    reg R_phase_dir = DIR_FWD;
    reg R_cos_dir = DIR_FWD;
    
    // Control the direction of the phase increasing with flag R_phase_dir
    parameter MAX_PHASE = 14'd2047;
    parameter MIN_PHASE = -14'd2048;
    wire S_reach_top; // If reach max phase
    assign S_reach_top = (R_current_phase[`QUAN_BIT - 1]==0)&&(R_current_phase + I_inc_phase > MAX_PHASE);
    wire S_reach_bottom; // If reach min phase
    assign S_reach_bottom = (R_current_phase[`QUAN_BIT - 1]==1)&&(R_current_phase - I_inc_phase < MIN_PHASE);
    always@(posedge I_clk)
    begin
        if (I_rst_n == 0) R_phase_dir <= DIR_FWD;
        else begin
            if (R_phase_dir == DIR_FWD)
                if (S_reach_top) R_phase_dir <= DIR_BAK;
                else R_phase_dir <= DIR_FWD;
            else // (R_phase_dir == DIR_BAK)
            begin
                if (S_reach_bottom) R_phase_dir <= DIR_FWD;
                else R_phase_dir <= DIR_BAK;
            end
        end
    end
    
    always @(posedge I_clk)
    begin
        if (I_rst_n == 0) R_current_phase <= I_init_phase;
        else if (I_change_phase == 1'b1) R_current_phase <= I_init_phase;
        else 
            case(R_phase_dir)
            DIR_FWD: if (S_reach_top) R_current_phase <= MAX_PHASE - (R_current_phase + I_inc_phase - MAX_PHASE);
                     else R_current_phase <= R_current_phase + I_inc_phase;
            DIR_BAK: if (S_reach_bottom) R_current_phase <= MIN_PHASE + (R_current_phase - I_inc_phase - MIN_PHASE);
                     else R_current_phase <= R_current_phase - I_inc_phase;
            endcase
    end 
    
    cordic_sin cordic_sin_inst(
       .I_rst_n(I_rst_n),        // synchronization reset
       .I_clk(I_clk),          // clock
       .I_phase(R_current_phase),        // phase to be calculate
       .O_cos(S_cos),          // output cos data
       .O_sin(S_sin)          // output sin data
       );
       
       
   // delay 13 slots R_dir_delay to R_cos_dir
   reg [`ITER_N-1:0] R_dir_delay = 0;
   always @(posedge I_clk)
   begin
       R_dir_delay[0] <= R_phase_dir;
       R_dir_delay[1] <= R_dir_delay[0];
       R_dir_delay[2] <= R_dir_delay[1];
       R_dir_delay[3] <= R_dir_delay[2];
       R_dir_delay[4] <= R_dir_delay[3];
       R_dir_delay[5] <= R_dir_delay[4];
       R_dir_delay[6] <= R_dir_delay[5];
       R_dir_delay[7] <= R_dir_delay[6];
       R_dir_delay[8] <= R_dir_delay[7];
       R_dir_delay[9] <= R_dir_delay[8];
       R_dir_delay[10] <= R_dir_delay[9];
       R_dir_delay[11] <= R_dir_delay[10];
       R_dir_delay[12] <= R_dir_delay[11];
       R_cos_dir <= R_dir_delay[12];
   end
   always @(posedge I_clk)
   begin
       O_sin <= S_sin;
       if (R_cos_dir == DIR_FWD) O_cos <= S_cos;
       else O_cos <= -S_cos;
   end
    
endmodule
