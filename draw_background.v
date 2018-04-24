`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2018 13:49:11
// Design Name: 
// Module Name: draw_background
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


module draw_background(
    input wire clk,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );
    
    reg [11:0] rgb_nxt;
    
    always@(posedge clk)
        begin
        hcount_out <= hcount_in;
        hsync_out <= hsync_in;
        hblnk_out <= hblnk_in;
        vcount_out <= vcount_in;
        vsync_out <= vsync_in;
        vblnk_out <= vblnk_in;
        rgb_out <= rgb_nxt;
        
        end
        
    always @*
       begin    
 // During blanking, make it it black.
       if (vblnk_in || hblnk_in) rgb_nxt = 12'h0_0_0; 
       else
       begin
         // Active display, top edge, make a yellow line.
         if (vcount_in == 0) rgb_nxt = 12'hf_f_0;
         // Active display, bottom edge, make a red line.
         else if (vcount_in == 599) rgb_nxt = 12'hf_0_0;
         // Active display, left edge, make a green line.
         else if (hcount_in == 0) rgb_nxt = 12'h0_f_0;
         // Active display, right edge, make a blue line.
         else if (hcount_in == 799) rgb_nxt = 12'h0_0_f;
         // Active display, interior, fill with gray.
         
         //Litera T
         else if (vcount_in >= 20 && vcount_in<= 320 && hcount_in>=150 && hcount_in<=210) rgb_nxt = 12'hf_0_0; 
         else if (vcount_in >= 20 && vcount_in<= 80 && hcount_in>= 60 && hcount_in<=300) rgb_nxt = 12'hf_0_0;
         // Cyfra 3
         else if (vcount_in >= 20 && vcount_in<= 320 && hcount_in>=580 && hcount_in<=640) rgb_nxt = 12'hf_f_0;
         else if (vcount_in >= 20 && vcount_in<= 80 && hcount_in>=400 && hcount_in<=640) rgb_nxt = 12'hf_f_0;
         else if (vcount_in >=140 && vcount_in<= 200 && hcount_in>=460 && hcount_in<=640) rgb_nxt = 12'hf_f_0;
         else if (vcount_in >=260 && vcount_in<= 320 && hcount_in>=400 && hcount_in<=640) rgb_nxt = 12'hf_f_0;
         
         // You will replace this with your own test.
         else rgb_nxt = 12'h8_8_8;    
       end
    end    
        
endmodule

