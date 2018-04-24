`timescale 1ns/1ps

module draw_rect
        #(parameter
        
        rect_width=0,
        rect_length=0,
        rect_colour=0
        )
 (       
    input wire clk,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
);  

reg [11:0] rgb_nxt;
reg [11:0] xpos_nxt;
reg [11:0] ypos_nxt;

    always@(posedge clk)
        begin
        hcount_out <= hcount_in;
        hsync_out <= hsync_in;
        hblnk_out <= hblnk_in;
        vcount_out <= vcount_in;
        vsync_out <= vsync_in;
        vblnk_out <= vblnk_in;
        rgb_out <= rgb_nxt;
        xpos_nxt <= xpos;
        ypos_nxt <= ypos;
        end



    always@*
        begin 
            if(vcount_in >=ypos_nxt && vcount_in <=rect_width+ypos_nxt && hcount_in >=xpos_nxt && hcount_in <= xpos_nxt+rect_length) rgb_nxt = rect_colour;
            else
            begin
            rgb_nxt<=rgb_in;
            end  
        end
endmodule             