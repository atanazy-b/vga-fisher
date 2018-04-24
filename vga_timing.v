// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

//Sequential part:
module vga_timing (
  output reg [10:0] vcount=0,
  output reg vsync=0,
  output reg vblnk=0,
  output reg [10:0] hcount=0,
  output reg hsync=0,
  output reg hblnk=0,
  input wire pclk
  );



  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.
 localparam
 
    VCOUNT_MIN=0,
    VCOUNT_MAX=627,
    HCOUNT_MIN=0,
    HCOUNT_MAX=1055,
    VSYNC_ON=601,
    VSYNC_OFF=605,
    HSYNC_ON=840,
    HSYNC_OFF=968,
    VBLNK_ON=600,
    HBLNK_ON=800;
    
//Combinational part:

always@(posedge pclk)
fork
hcount = (hcount == HCOUNT_MAX) ? 0: hcount +1;
vcount = (hcount == HCOUNT_MAX)?((vcount == VCOUNT_MAX)? 0: vcount+1):vcount;

hblnk = (hcount >= HBLNK_ON)&&(hcount<=HCOUNT_MAX)? 1:0;
hsync = (hcount >= HSYNC_ON)&&(hcount<HSYNC_OFF)? 1:0;

vblnk = (vcount >= VBLNK_ON)&&(vcount<=VCOUNT_MAX)? 1:0;
vsync = (vcount >= VSYNC_ON)&&(vcount<VSYNC_OFF)? 1:0;

join
     
    
    
/*
always@(posedge pclk)
begin
    hcount = hcount + 1;
    if(hcount == HCOUNT_MAX)
    begin
        vcount = vcount + 1;
        hcount = 0;
        hblnk = 0;
        if(vcount == VCOUNT_MAX)
        begin
            vcount = 0;
            vblnk = 0;
        end
        
    end

    if(hcount == HBLNK_ON)
    begin
    hblnk = 1;
    end  
    
    if(hcount == HSYNC_ON)
    begin
    hsync = 1;
    end
    
    if(hcount == HSYNC_OFF)
    begin
    hsync = 0;
    end
    
    if(vcount == VBLNK_ON)
    begin
    vblnk = 1;
    end
    
    if(vcount == VSYNC_ON)
    begin
    vsync = 1;
    end
    
    if(vcount == VSYNC_OFF)
    begin
    vsync = 0;
    end
      
end        
 */   
    
endmodule