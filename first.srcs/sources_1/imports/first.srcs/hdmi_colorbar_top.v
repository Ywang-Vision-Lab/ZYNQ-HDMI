

//****************************************************************************************//

module  hdmi_colorbar_top(
    input   wire        sys_clk     ,
    input   wire        sys_rst_n   ,
    
    output  wire        tmds_clk_p  ,   
    output  wire        tmds_clk_n  ,
    output  wire[2:0]   tmds_data_p ,    
    output  wire[2:0]   tmds_data_n ,
    output  wire        tmds_oen       
);

 
wire          pixel_clk;
wire          pixel_clk_5x;
wire          clk_locked;

wire  [10:0]  pixel_xpos_w;
wire  [10:0]  pixel_ypos_w;
wire  [23:0]  pixel_data_w;

wire          video_hs;
wire          video_vs;
wire          video_de;
wire  [23:0]  video_rgb;

//*****************************************************
//**                    main code
//*****************************************************

//PLL 
clk_wiz_0  clk_wiz_0(
    .clk_in1        (sys_clk      ),      //100Mz
    .clk_out1       (pixel_clk    ),      //74.25Mhz 
    .clk_out2       (pixel_clk_5x ),      //5*pixel_clk
    .reset          (~sys_rst_n   ), 
    .locked         (clk_locked   )
);


video_driver u_video_driver(
    .pixel_clk      (pixel_clk   ),
    .sys_rst_n      (sys_rst_n   ),

    .video_hs       (video_hs    ),
    .video_vs       (video_vs    ),
    .video_de       (video_de    ),
    .video_rgb      (video_rgb   ),

    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .pixel_data     (pixel_data_w)
    );


video_display  u_video_display(
    .pixel_clk      (pixel_clk   ),
    .sys_rst_n      (sys_rst_n   ),

    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .pixel_data     (pixel_data_w)
    );

//VGA2HDMI
dvi_transmitter_top u_rgb2dvi_0(
    .pclk           (pixel_clk   ),
    .pclk_x5        (pixel_clk_5x),
    .reset_n        (sys_rst_n & clk_locked),
                
    .video_din      (video_rgb  ),
    .video_hsync    (video_hs   ), 
    .video_vsync    (video_vs   ),
    .video_de       (video_de   ),
                
    .tmds_clk_p     (tmds_clk_p ),
    .tmds_clk_n     (tmds_clk_n ),
    .tmds_data_p    (tmds_data_p),
    .tmds_data_n    (tmds_data_n), 
    .tmds_oen       (tmds_oen   )
    );

endmodule 