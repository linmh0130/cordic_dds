`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 20:40:20
// Design Name: CORDIC SINE/COSINE CORE
// Module Name: cordic_sin
// Project Name: cordic_pipeline
// Target Devices: xc7z010clg400-1
// Tool Versions: Vivado 2018.2
// Description: The core module of the cordic algorithm
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

module cordic_sin(
    I_rst_n,        // synchronization reset
    I_clk,          // clock
    I_phase,        // phase to be calculate
    O_cos,          // output cos data
    O_sin          // output sin data
    );
    input wire I_rst_n;
    input wire I_clk;
    input wire [`QUAN_BIT - 1: 0] I_phase;
    output reg [`QUAN_BIT - 1: 0] O_cos = 0;
    output reg [`QUAN_BIT - 1: 0] O_sin = 0;
    
    // regs for iteration
    wire [`QUAN_BIT - 1: 0] S_cos_0 = `COS_INIT;
    wire [`QUAN_BIT - 1: 0] S_sin_0 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_1 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_1 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_1 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_2 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_2 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_2 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_3 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_3 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_3 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_4 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_4 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_4 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_5 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_5 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_5 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_6 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_6 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_6 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_7 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_7 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_7 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_8 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_8 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_8 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_9 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_9 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_9 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_10 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_10 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_10 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_11 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_11 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_11 = 0;
    reg [`QUAN_BIT - 1: 0] R_cos_12 = 0;
    reg [`QUAN_BIT - 1: 0] R_sin_12 = 0;
    reg [`QUAN_BIT - 1: 0] R_phs_12 = 0;
    
    // 1 round
    always@(posedge I_clk)
    begin
        if (I_rst_n == 1'b0) begin
            R_cos_1 <= 0;
            R_sin_1 <= 0;
            R_phs_1 <= 0;  
        end
        else begin
            if (I_phase[`QUAN_BIT - 1] == 1'b0) begin
                R_cos_1 <= S_cos_0;
                R_sin_1 <= S_sin_0 + S_cos_0;
                R_phs_1 <= I_phase - `ATAN_1;
            end
            else begin
                R_cos_1 <= S_cos_0;          
                R_sin_1 <= S_sin_0 - S_cos_0;          
                R_phs_1 <= I_phase + `ATAN_1;
            end
        end
    end
    
    // 2 round                                       
    always@(posedge I_clk)                           
    begin                                            
        if (I_rst_n == 1'b0) begin                   
            R_cos_2 <= 0;                            
            R_sin_2 <= 0;                            
            R_phs_2 <= 0;                            
        end                                          
        else begin                                   
            if (R_phs_1[`QUAN_BIT - 1] == 1'b0) begin
                R_cos_2 <= R_cos_1 - {R_sin_1[`QUAN_BIT-1],R_sin_1[`QUAN_BIT - 1:1]};                
                R_sin_2 <= R_sin_1 + {R_cos_1[`QUAN_BIT-1],R_cos_1[`QUAN_BIT - 1:1]};                   
                R_phs_2 <= R_phs_1 - `ATAN_2;        
            end                                      
            else begin                               
                R_cos_2 <= R_cos_1 + {R_sin_1[`QUAN_BIT-1],R_sin_1[`QUAN_BIT - 1:1]};             
                R_sin_2 <= R_sin_1 - {R_cos_1[`QUAN_BIT-1],R_cos_1[`QUAN_BIT - 1:1]};                   
                R_phs_2 <= R_phs_1 + `ATAN_2;        
            end                                      
        end                                          
    end
                                                  
    // 3 round                                                                       
    always@(posedge I_clk)                                                           
    begin                                                                            
        if (I_rst_n == 1'b0) begin                                                   
            R_cos_3 <= 0;                                                            
            R_sin_3 <= 0;                                                            
            R_phs_3 <= 0;                                                            
        end                                                                          
        else begin                                                                   
            if (R_phs_2[`QUAN_BIT - 1] == 1'b0) begin                                
                R_cos_3 <= R_cos_2 - {R_sin_2[`QUAN_BIT-1],R_sin_2[`QUAN_BIT-1],R_sin_2[`QUAN_BIT - 1:2]};
                R_sin_3 <= R_sin_2 + {R_cos_2[`QUAN_BIT-1],R_cos_2[`QUAN_BIT-1],R_cos_2[`QUAN_BIT - 1:2]};
                R_phs_3 <= R_phs_2 - `ATAN_3;                                        
            end                                                                      
            else begin                                                               
                R_cos_3 <= R_cos_2 + {R_sin_2[`QUAN_BIT-1],R_sin_2[`QUAN_BIT-1],R_sin_2[`QUAN_BIT - 1:2]};
                R_sin_3 <= R_sin_2 - {R_cos_2[`QUAN_BIT-1],R_cos_2[`QUAN_BIT-1],R_cos_2[`QUAN_BIT - 1:2]};
                R_phs_3 <= R_phs_2 + `ATAN_3;                                        
            end                                                                      
        end                                                                          
    end
    
    // 4 round                                                                                            
    always@(posedge I_clk)                                                                                
    begin                                                                                                 
        if (I_rst_n == 1'b0) begin                                                                        
            R_cos_4 <= 0;                                                                                 
            R_sin_4 <= 0;                                                                                 
            R_phs_4 <= 0;                                                                                 
        end                                                                                               
        else begin                                                                                        
            if (R_phs_3[`QUAN_BIT - 1] == 1'b0) begin                                                     
                R_cos_4 <= R_cos_3 - {R_sin_3[`QUAN_BIT-1],R_sin_3[`QUAN_BIT-1],R_sin_3[`QUAN_BIT-1],R_sin_3[`QUAN_BIT - 1:3]};
                R_sin_4 <= R_sin_3 + {R_cos_3[`QUAN_BIT-1],R_cos_3[`QUAN_BIT-1],R_cos_3[`QUAN_BIT-1],R_cos_3[`QUAN_BIT - 1:3]};
                R_phs_4 <= R_phs_3 - `ATAN_4;                                                             
            end                                                                                           
            else begin                                                                                    
                R_cos_4 <= R_cos_3 + {R_sin_3[`QUAN_BIT-1],R_sin_3[`QUAN_BIT-1],R_sin_3[`QUAN_BIT-1],R_sin_3[`QUAN_BIT - 1:3]};
                R_sin_4 <= R_sin_3 - {R_cos_3[`QUAN_BIT-1],R_cos_3[`QUAN_BIT-1],R_cos_3[`QUAN_BIT-1],R_cos_3[`QUAN_BIT - 1:3]};
                R_phs_4 <= R_phs_3 + `ATAN_4;                                                             
            end                                                                                           
        end                                                                                               
    end
    
    // 5 round                                                                                                                 
    always@(posedge I_clk)                                                                                                     
    begin                                                                                                                      
        if (I_rst_n == 1'b0) begin                                                                                             
            R_cos_5 <= 0;                                                                                                      
            R_sin_5 <= 0;                                                                                                      
            R_phs_5 <= 0;                                                                                                      
        end                                                                                                                    
        else begin                                                                                                             
            if (R_phs_4[`QUAN_BIT - 1] == 1'b0) begin                                                                          
                R_cos_5 <= R_cos_4 - {R_sin_4[`QUAN_BIT-1],R_sin_4[`QUAN_BIT-1],R_sin_4[`QUAN_BIT-1],R_sin_4[`QUAN_BIT-1],R_sin_4[`QUAN_BIT - 1:4]};
                R_sin_5 <= R_sin_4 + {R_cos_4[`QUAN_BIT-1],R_cos_4[`QUAN_BIT-1],R_cos_4[`QUAN_BIT-1],R_cos_4[`QUAN_BIT-1],R_cos_4[`QUAN_BIT - 1:4]};
                R_phs_5 <= R_phs_4 - `ATAN_5;                                                                                  
            end                                                                                                                
            else begin                                                                                                         
                R_cos_5 <= R_cos_4 + {R_sin_4[`QUAN_BIT-1],R_sin_4[`QUAN_BIT-1],R_sin_4[`QUAN_BIT-1],R_sin_4[`QUAN_BIT-1],R_sin_4[`QUAN_BIT - 1:4]};
                R_sin_5 <= R_sin_4 - {R_cos_4[`QUAN_BIT-1],R_cos_4[`QUAN_BIT-1],R_cos_4[`QUAN_BIT-1],R_cos_4[`QUAN_BIT-1],R_cos_4[`QUAN_BIT - 1:4]};
                R_phs_5 <= R_phs_4 + `ATAN_5;                                                                                  
            end                                                                                                                
        end                                                                                                                    
    end
    
    // 6 round                                                                                                                                      
    always@(posedge I_clk)                                                                                                                          
    begin                                                                                                                                           
        if (I_rst_n == 1'b0) begin                                                                                                                  
            R_cos_6 <= 0;                                                                                                                           
            R_sin_6 <= 0;                                                                                                                           
            R_phs_6 <= 0;                                                                                                                           
        end                                                                                                                                         
        else begin                                                                                                                                  
            if (R_phs_5[`QUAN_BIT - 1] == 1'b0) begin                                                                                               
                R_cos_6 <= R_cos_5 - {R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT - 1:5]};
                R_sin_6 <= R_sin_5 + {R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT - 1:5]};
                R_phs_6 <= R_phs_5 - `ATAN_6;                                                                                                       
            end                                                                                                                                     
            else begin                                                                                                                              
                R_cos_6 <= R_cos_5 + {R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT-1],R_sin_5[`QUAN_BIT - 1:5]};
                R_sin_6 <= R_sin_5 - {R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT-1],R_cos_5[`QUAN_BIT - 1:5]};
                R_phs_6 <= R_phs_5 + `ATAN_6;                                                                                                       
            end                                                                                                                                     
        end                                                                                                                                         
    end
    
    // 7 round                                                                                                                                                            
    always@(posedge I_clk)                                                                                                                                                
    begin                                                                                                                                                                 
        if (I_rst_n == 1'b0) begin                                                                                                                                        
            R_cos_7 <= 0;                                                                                                                                                 
            R_sin_7 <= 0;                                                                                                                                                 
            R_phs_7 <= 0;                                                                                                                                                 
        end                                                                                                                                                               
        else begin                                                                                                                                                        
            if (R_phs_6[`QUAN_BIT - 1] == 1'b0) begin                                                                                                                     
                R_cos_7 <= R_cos_6 - {R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT - 1:6]}; 
                R_sin_7 <= R_sin_6 + {R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT - 1:6]}; 
                R_phs_7 <= R_phs_6 - `ATAN_7;                                                                                                                             
            end                                                                                                                                                           
            else begin                                                                                                                                                    
                R_cos_7 <= R_cos_6 + {R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT-1],R_sin_6[`QUAN_BIT - 1:6]}; 
                R_sin_7 <= R_sin_6 - {R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT-1],R_cos_6[`QUAN_BIT - 1:6]}; 
                R_phs_7 <= R_phs_6 + `ATAN_7;                                                                                                                             
            end                                                                                                                                                           
        end                                                                                                                                                               
    end                                                                                                                                                                   
    
    // 8 round                                                                                                                                                                                
    always@(posedge I_clk)                                                                                                                                                                    
    begin                                                                                                                                                                                     
        if (I_rst_n == 1'b0) begin                                                                                                                                                            
            R_cos_8 <= 0;                                                                                                                                                                     
            R_sin_8 <= 0;                                                                                                                                                                     
            R_phs_8 <= 0;                                                                                                                                                                     
        end                                                                                                                                                                                   
        else begin                                                                                                                                                                            
            if (R_phs_7[`QUAN_BIT - 1] == 1'b0) begin                                                                                                                                         
                R_cos_8 <= R_cos_7 - {R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT - 1:7]};
                R_sin_8 <= R_sin_7 + {R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT - 1:7]};
                R_phs_8 <= R_phs_7 - `ATAN_8;                                                                                                                                                 
            end                                                                                                                                                                               
            else begin                                                                                                                                                                        
                R_cos_8 <= R_cos_7 + {R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT-1],R_sin_7[`QUAN_BIT - 1:7]};
                R_sin_8 <= R_sin_7 - {R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT-1],R_cos_7[`QUAN_BIT - 1:7]};
                R_phs_8 <= R_phs_7 + `ATAN_8;                                                                                                                                                 
            end                                                                                                                                                                               
        end                                                                                                                                                                                   
    end 
                                                                                                                                                                                          
    // 9 round                                                                                                                                                                                                                 
    always@(posedge I_clk)                                                                                                                                                                                                     
    begin                                                                                                                                                                                                                      
        if (I_rst_n == 1'b0) begin                                                                                                                                                                                             
            R_cos_9 <= 0;                                                                                                                                                                                                      
            R_sin_9 <= 0;                                                                                                                                                                                                      
            R_phs_9 <= 0;                                                                                                                                                                                                      
        end                                                                                                                                                                                                                    
        else begin                                                                                                                                                                                                             
            if (R_phs_8[`QUAN_BIT - 1] == 1'b0) begin                                                                                                                                                                          
                R_cos_9 <= R_cos_8 - {R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT - 1:8]};            
                R_sin_9 <= R_sin_8 + {R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT - 1:8]};            
                R_phs_9 <= R_phs_8 - `ATAN_9;                                                                                                                                                                                  
            end                                                                                                                                                                                                                
            else begin                                                                                                                                                                                                         
                R_cos_9 <= R_cos_8 + {R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT-1],R_sin_8[`QUAN_BIT - 1:8]};             
                R_sin_9 <= R_sin_8 - {R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT-1],R_cos_8[`QUAN_BIT - 1:8]};             
                R_phs_9 <= R_phs_8 + `ATAN_9;                                                                                                                                                                                  
            end                                                                                                                                                                                                                
        end                                                                                                                                                                                                                    
    end
    
    // 10 round                                                                                                                                                                                                                                   
    always@(posedge I_clk)                                                                                                                                                                                                                       
    begin                                                                                                                                                                                                                                        
        if (I_rst_n == 1'b0) begin                                                                                                                                                                                                               
            R_cos_10 <= 0;                                                                                                                                                                                                                        
            R_sin_10 <= 0;                                                                                                                                                                                                                        
            R_phs_10 <= 0;                                                                                                                                                                                                                        
        end                                                                                                                                                                                                                                      
        else begin                                                                                                                                                                                                                               
            if (R_phs_9[`QUAN_BIT - 1] == 1'b0) begin                                                                                                                                                                                            
                R_cos_10 <= R_cos_9 - {R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT - 1:9]};         
                R_sin_10 <= R_sin_9 + {R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT - 1:9]};         
                R_phs_10 <= R_phs_9 - `ATAN_10;                                                                                                                                                                                                    
            end                                                                                                                                                                                                                                  
            else begin                                                                                                                                                                                                                           
                R_cos_10 <= R_cos_9 + {R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT-1],R_sin_9[`QUAN_BIT - 1:9]};          
                R_sin_10 <= R_sin_9 - {R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT-1],R_cos_9[`QUAN_BIT - 1:9]};          
                R_phs_10 <= R_phs_9 + `ATAN_10;                                                                                                                                                                                                    
            end                                                                                                                                                                                                                                  
        end                                                                                                                                                                                                                                      
    end                                                                                                                                                                                                                                                        
    // 11 round                                                                                                                                                                                                                                                
    always@(posedge I_clk)                                                                                                                                                                                                                                     
    begin                                                                                                                                                                                                                                                      
        if (I_rst_n == 1'b0) begin                                                                                                                                                                                                                             
            R_cos_11 <= 0;                                                                                                                                                                                                                                     
            R_sin_11 <= 0;                                                                                                                                                                                                                                     
            R_phs_11 <= 0;                                                                                                                                                                                                                                     
        end                                                                                                                                                                                                                                                    
        else begin                                                                                                                                                                                                                                             
            if (R_phs_10[`QUAN_BIT - 1] == 1'b0) begin                                                                                                                                                                                                          
                R_cos_11 <= R_cos_10 - {R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT - 1:10]}; 
                R_sin_11 <= R_sin_10 + {R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT - 1:10]}; 
                R_phs_11 <= R_phs_10 - `ATAN_11;                                                                                                                                                                                                                
            end                                                                                                                                                                                                                                                
            else begin                                                                                                                                                                                                                                         
                R_cos_11 <= R_cos_10 + {R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT-1],R_sin_10[`QUAN_BIT - 1:10]};
                R_sin_11 <= R_sin_10 - {R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT-1],R_cos_10[`QUAN_BIT - 1:10]};
                R_phs_11 <= R_phs_10 + `ATAN_11;                                                                                                                                                                                                                
            end                                                                                                                                                                                                                                                
        end                                                                                                                                                                                                                                                    
    end                                                                                                                                                                                                                                                                                                                                                          
    // 12 round                                                                                                                                                                                                                                                
    always@(posedge I_clk)                                                                                                                                                                                                                                     
    begin                                                                                                                                                                                                                                                      
        if (I_rst_n == 1'b0) begin                                                                                                                                                                                                                             
            R_cos_12 <= 0;                                                                                                                                                                                                                                     
            R_sin_12 <= 0;                                                                                                                                                                                                                                     
            R_phs_12 <= 0;                                                                                                                                                                                                                                     
        end                                                                                                                                                                                                                                                    
        else begin                                                                                                                                                                                                                                             
            if (R_phs_11[`QUAN_BIT - 1] == 1'b0) begin                                                                                                                                                                                                          
                R_cos_12 <= R_cos_11 - {R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT - 1:11]}; 
                R_sin_12 <= R_sin_11 + {R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT - 1:11]}; 
                R_phs_12 <= R_phs_11 - `ATAN_12;                                                                                                                                                                                                                
            end                                                                                                                                                                                                                                                
            else begin                                                                                                                                                                                                                                         
                R_cos_12 <= R_cos_11 + {R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT-1],R_sin_11[`QUAN_BIT - 1:11]};
                R_sin_12 <= R_sin_11 - {R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT-1],R_cos_11[`QUAN_BIT - 1:11]};
                R_phs_12 <= R_phs_11 + `ATAN_12;                                                                                                                                                                                                                
            end                                                                                                                                                                                                                                                
        end                                                                                                                                                                                                                                                    
    end
    // 12 round                                                                                                                                                                                                                                                
    always@(posedge I_clk)                                                                                                                                                                                                                                     
    begin                                                                                                                                                                                                                                                      
        if (I_rst_n == 1'b0) begin                                                                                                                                                                                                                             
            O_cos <= 0;                                                                                                                                                                                                                                     
            O_sin <= 0;                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
        end                                                                                                                                                                                                                                                    
        else begin                                                                                                                                                                                                                                             
            if (R_phs_12[`QUAN_BIT - 1] == 1'b0) begin                                                                                                                                                                                                          
                O_cos <= R_cos_12 - {R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT - 1:12]}; 
                O_sin <= R_sin_12 + {R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT - 1:12]};                                                                                                                                                                                                             
            end                                                                                                                                                                                                                                                
            else begin                                                                                                                                                                                                                                         
                O_cos <= R_cos_12 + {R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT-1],R_sin_12[`QUAN_BIT - 1:12]};
                O_sin <= R_sin_12 - {R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT-1],R_cos_12[`QUAN_BIT - 1:12]};                                                                                                                                                                                                          
            end                                                                                                                                                                                                                                                
        end                                                                                                                                                                                                                                                    
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
endmodule
