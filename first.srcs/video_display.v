
//****************************************************************************************//

module  video_display(
    input   wire              pixel_clk ,
    input   wire              sys_rst_n ,
    
    input   wire   [10:0]     pixel_xpos,  
    input   wire   [10:0]     pixel_ypos,  
    output  reg    [23:0]     pixel_data   
);

//parameter define
//current resolution
parameter  H_DISP = 11'd1280;                       
parameter  V_DISP = 11'd720;                        

localparam WHITE  = 24'b11111111_11111111_11111111;  
localparam BLACK  = 24'b00000000_00000000_00000000;  
localparam RED    = 24'b11111111_00001100_00000000;  
localparam GREEN  = 24'b00000000_11111111_00000000;  
localparam BLUE   = 24'b00000000_00000000_11111111;  
    
//*****************************************************
//**                    main code
//*****************************************************


always @(posedge pixel_clk ) begin
    if (!sys_rst_n)
        pixel_data <= 16'd0;
    else begin
        if((pixel_xpos >= 0) && (pixel_xpos < (H_DISP/5)*1))
            pixel_data <= WHITE;
        else if((pixel_xpos >= (H_DISP/5)*1) && (pixel_xpos < (H_DISP/5)*2))
            pixel_data <= BLACK;  
        else if((pixel_xpos >= (H_DISP/5)*2) && (pixel_xpos < (H_DISP/5)*3))
            pixel_data <= RED;  
        else if((pixel_xpos >= (H_DISP/5)*3) && (pixel_xpos < (H_DISP/5)*4))
            pixel_data <= GREEN;
        else 
            pixel_data <= BLUE;
    end
end

endmodule