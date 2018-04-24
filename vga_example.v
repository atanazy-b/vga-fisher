// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
  input wire clk,
  output reg vs,
  output reg hs,
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b,
  output wire pclk_mirror,
  inout wire ps2_clk,
  inout wire ps2_data
  );

  // Converts 100 MHz clk into 40 MHz pclk.
  // This uses a vendor specific primitive
  // called MMCME2, for frequency synthesis.
  wire clk100MHz;  
  wire clk_in;
  wire locked;
  wire clk_fb;
  wire clk_ss;
  wire clk_out;
  wire pclk;
  (* KEEP = "TRUE" *) 
  (* ASYNC_REG = "TRUE" *)
  reg [7:0] safe_start = 0;
  
  
  clk_wiz_0 clk_wiz_0
    (
    // Clock out ports  
    .clk100MHz(clk100MHz),
    .clk40MHz(pclk),
    // Status and control signals               
   // Clock in ports
    .clk_in1(clk)
    );
  
  
/*
  IBUF clk_ibuf (.I(clk),.O(clk_in));

  MMCME2_BASE #(
    .CLKIN1_PERIOD(10.000),
    .CLKFBOUT_MULT_F(10.000),
    .CLKOUT0_DIVIDE_F(25.000))
  clk_in_mmcme2 (
    .CLKIN1(clk_in),
    .CLKOUT0(clk_out),
    .CLKOUT0B(),
    .CLKOUT1(),
    .CLKOUT1B(),
    .CLKOUT2(),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(clk_fb),
    .CLKFBOUTB(),
    .CLKFBIN(clk_fb),
    .LOCKED(locked),
    .PWRDWN(1'b0),
    .RST(1'b0)
  );

  BUFH clk_out_bufh (.I(clk_out),.O(clk_ss));
  always @(posedge clk_ss) safe_start<= {safe_start[6:0],locked};

  BUFGCE clk_out_bufgce (.I(clk_out),.CE(safe_start[7]),.O(pclk));
*/
  // Mirrors pclk on a pin for use by the testbench;
  // not functionally required for this design to work.

  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );

  // Instantiate the vga_timing module, which is
  // the module you are designing for this lab.

  wire [10:0] vcount, hcount;
  wire vsync, hsync;
  wire vblnk, hblnk;
  
  vga_timing my_timing (
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),
    .pclk(pclk)
  );
  
  wire [10:0] vcount_bckgrd, hcount_bckgrd;
  wire vsync_bckgrd, hsync_bckgrd;
  wire vblnk_bckgrd, hblnk_bckgrd;
  wire [11:0] rgb;
   
  draw_background my_drawbackground (
    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblnk_in(vblnk),
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblnk_in(hblnk),
    .clk(pclk),
    
    .rgb_out(rgb),
    .vcount_out(vcount_bckgrd),
    .vsync_out(vsync_bckgrd),
    .vblnk_out(vblnk_bckgrd),
    .hcount_out(hcount_bckgrd),
    .hsync_out(hsync_bckgrd),
    .hblnk_out(hblnk_bckgrd)
  );  
  // This is a simple test pattern generator.
  
  wire [10:0] vcount_rect, hcount_rect;
  wire vsync_rect, hsync_rect;
  wire vblnk_rect, hblnk_rect;
  wire [11:0] rgb_rect;
  wire [11:0] xpos;
  wire [11:0] ypos;
  
  
  
  draw_rect 
    #(
    
        .rect_width(60),
        .rect_length(90),
        .rect_colour(315)
     )
        
  my_drawrect (
      .rgb_in(rgb),
      .vcount_in(vcount_bckgrd),
      .vsync_in(vsync_bckgrd),
      .vblnk_in(vblnk_bckgrd),
      .hcount_in(hcount_bckgrd),
      .hsync_in(hsync_bckgrd),
      .hblnk_in(hblnk_bckgrd),
      .clk(pclk),
      .xpos(xpos),
      .ypos(ypos),
      
      .rgb_out(rgb_rect),
      .vcount_out(vcount_rect),
      .vsync_out(vsync_rect),
      .vblnk_out(vblnk_rect),
      .hcount_out(hcount_rect),
      .hsync_out(hsync_rect),
      .hblnk_out(hblnk_rect)
);



MouseCtl MouseCtl(
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos),
    .ypos(ypos),
    .clk(clk100MHz)
);

wire [11:0] xpos_MD;
wire [11:0] ypos_MD;
wire [10:0] vcount_MD, hcount_MD;
wire vsync_MD, hsync_MD;
wire vblnk_MD, hblnk_MD;
wire [3:0] red_MD; 
wire [3:0] green_MD; 
wire [3:0] blue_MD;

MouseDisplay MouseDisplay(
    .pixel_clk(pclk),
    .xpos(xpos),
    .ypos(ypos),
    .red_in(rgb_rect[11:8]),
    .green_in(rgb_rect[7:4]),
    .blue_in(rgb_rect[3:0]),
    .vcount(vcount_rect),
    .vsync_in(vsync_rect),
    .vblnk_in(vblnk_rect),
    .hcount(hcount_rect),
    .hsync_in(hsync_rect),
    .hblnk_in(hblnk_rect),
    
    .red_out(red_MD),
    .green_out(green_MD),
    .blue_out(blue_MD),
    .vsync_out(vsync_MD),
    .hsync_out(hsync_MD)
);    
      
  always @(posedge pclk)
  begin
    // Just pass these through.
    hs <= hsync_MD;
    vs <= vsync_MD;
     
    r <= red_MD;
    g <= green_MD;
    b <= blue_MD;
    
 /*   // During blanking, make it it black.
    if (vblnk || hblnk) {r,g,b} <= 12'h0_0_0; 
    else
    begin
      // Active display, top edge, make a yellow line.
      if (vcount == 0) {r,g,b} <= 12'hf_f_0;
      // Active display, bottom edge, make a red line.
      else if (vcount == 599) {r,g,b} <= 12'hf_0_0;
      // Active display, left edge, make a green line.
      else if (hcount == 0) {r,g,b} <= 12'h0_f_0;
      // Active display, right edge, make a blue line.
      else if (hcount == 799) {r,g,b} <= 12'h0_0_f;
      // Active display, interior, fill with gray.
      
      //Litera T
      else if (vcount >= 20 && vcount<= 320 && hcount>=150 && hcount<=210) {r,g,b} <= 12'hf_0_0; 
      else if (vcount >= 20 && vcount<= 80 && hcount>= 60 && hcount<=300) {r,g,b} <= 12'hf_0_0;
      // Cyfra 3
      else if (vcount >= 20 && vcount<= 320 && hcount>=580 && hcount<=640) {r,g,b} <= 12'hf_f_0;
      else if (vcount >= 20 && vcount<= 80 && hcount>=400 && hcount<=640) {r,g,b} <= 12'hf_f_0;
      else if (vcount >=140 && vcount<= 200 && hcount>=460 && hcount<=640) {r,g,b} <= 12'hf_f_0;
      else if (vcount >=260 && vcount<= 320 && hcount>=400 && hcount<=640) {r,g,b} <= 12'hf_f_0;
      
      // You will replace this with your own test.
      else {r,g,b} <= 12'h8_8_8;    
    end*/
  end

endmodule
