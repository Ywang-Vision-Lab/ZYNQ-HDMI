

module video_driver(
    input    wire        pixel_clk ,
    input    wire        sys_rst_n ,
    
    //VGA
    output   wire        video_hs  ,     
    output   wire        video_vs  ,     
    output   wire        video_de  ,     
    output   wire[23:0]  video_rgb ,    //RGB888
    
    input    wire[23:0]  pixel_data,   
    output   wire[10:0]  pixel_xpos,   
    output   wire[10:0]  pixel_ypos    
);

//parameter define

//1280*720 
parameter  H_SYNC   =  11'd40   ;   
parameter  H_BACK   =  11'd220  ;  
parameter  H_DISP   =  11'd1280 ; 
parameter  H_FRONT  =  11'd110  ;  
parameter  H_TOTAL  =  11'd1650 ; 

parameter  V_SYNC   =  11'd5    ;    
parameter  V_BACK   =  11'd20   ;   
parameter  V_DISP   =  11'd720  ;  
parameter  V_FRONT  =  11'd5    ;    
parameter  V_TOTAL  =  11'd750  ;  


reg  [10:0] cnt_h;
reg  [10:0] cnt_v;


wire       video_en;
wire       data_req;

//*****************************************************
//**                    main code
//*****************************************************

assign video_de  = video_en;

assign video_hs  = ( cnt_h < H_SYNC ) ? 1'b0 : 1'b1;  
assign video_vs  = ( cnt_v < V_SYNC ) ? 1'b0 : 1'b1;  

//data output enable 
assign video_en  = (((cnt_h >= H_SYNC+H_BACK) && (cnt_h < H_SYNC+H_BACK+H_DISP))
                 &&((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                 ?  1'b1 : 1'b0;

//data 
assign video_rgb = video_en ? pixel_data : 24'd0;

//data request signal
assign data_req = (((cnt_h >= H_SYNC+H_BACK-1'b1) && 
                    (cnt_h < H_SYNC+H_BACK+H_DISP-1'b1))
                  && ((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                  ?  1'b1 : 1'b0;

//
assign pixel_xpos = data_req ? (cnt_h - (H_SYNC + H_BACK - 1'b1)) : 11'd0;
assign pixel_ypos = data_req ? (cnt_v - (V_SYNC + V_BACK - 1'b1)) : 11'd0;

//aux counter for Horizontal
always @(posedge pixel_clk ) begin
    if (!sys_rst_n)
        cnt_h <= 11'd0;
    else begin
        if(cnt_h < H_TOTAL - 1'b1)
            cnt_h <= cnt_h + 1'b1;
        else 
            cnt_h <= 11'd0;
    end
end

//aux counter for Vertical
always @(posedge pixel_clk ) begin
    if (!sys_rst_n)
        cnt_v <= 11'd0;
    else if(cnt_h == H_TOTAL - 1'b1) begin
        if(cnt_v < V_TOTAL - 1'b1)
            cnt_v <= cnt_v + 1'b1;
        else 
            cnt_v <= 11'd0;
    end
end

endmodule