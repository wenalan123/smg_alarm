/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-24 21:33
 * Last modified : 2018-04-24 21:33
 * Filename      : smg.v
 * Description   : 
 * *********************************************************************/
module  smg(
        input                   clk                     ,
        input                   rst_n                   ,
        //
        input         [ 1: 0]   adjust                  ,
        input         [ 3: 0]   sec_l                   ,
        input         [ 3: 0]   sec_h                   ,
        input         [ 3: 0]   min_l                   ,
        input         [ 3: 0]   min_h                   ,
        input         [ 3: 0]   hour_l                  ,
        input         [ 3: 0]   hour_h                  ,
        input         [ 3: 0]   alarm_min_l             ,
        input         [ 3: 0]   alarm_min_h             ,
        input         [ 3: 0]   alarm_hour_l            ,
        input         [ 3: 0]   alarm_hour_h            ,
        //sw17
        input                   sw17                    ,
         //smg
        output  wire  [ 6: 0]   HEX2                    ,
        output  wire  [ 6: 0]   HEX3                    ,
        output  wire  [ 6: 0]   HEX4                    ,
        output  wire  [ 6: 0]   HEX5                    ,
        output  wire  [ 6: 0]   HEX6                    ,
        output  wire  [ 6: 0]   HEX7                                         
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   TIME_0_2S   =       10_000_000                      ; 
reg     [ 3: 0]                 smg_min_l                       ;
reg     [ 3: 0]                 smg_min_h                       ;
reg     [ 3: 0]                 smg_hour_l                      ;
reg     [ 3: 0]                 smg_hour_h                      ; 

reg                             scan_flag                       ; 
reg     [23: 0]                 cnt1                            ;
wire                            add_cnt1                        ;
wire                            end_cnt1                        ;

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//cnt1
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end
end

assign  add_cnt1        =       1'b1;       
assign  end_cnt1        =       add_cnt1 && cnt1 == TIME_0_2S-1;

//scan_flag
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        scan_flag   <=  1'b0;
    end
    else if(end_cnt1)begin
        scan_flag   <=  ~scan_flag;
    end
end



//smg_min
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        smg_min_l   <=  min_l;
        smg_min_h   <=  min_h;
    end
    else if(adjust == 'd1 && scan_flag)begin
        smg_min_l   <=  4'd10;
        smg_min_h   <=  4'd10;
    end
    else if(sw17)begin
        smg_min_l   <=  alarm_min_l;
        smg_min_h   <=  alarm_min_h;
    end
    else begin
        smg_min_l   <=  min_l;
        smg_min_h   <=  min_h;
    end
end

//smg_hour
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        smg_hour_l   <=  hour_l;
        smg_hour_h   <=  hour_h;
    end
    else if(adjust == 'd2 && scan_flag)begin
        smg_hour_l   <=  4'd10;
        smg_hour_h   <=  4'd10;
    end
    else if(sw17)begin
        smg_hour_l   <=  alarm_hour_l;
        smg_hour_h   <=  alarm_hour_h;
    end
    else begin
        smg_hour_l   <=  hour_l;
        smg_hour_h   <=  hour_h;
    end
end


decoder decoder_inst0(
        .hex_in                 (sec_l                  ),
        .hex_out                (HEX2                   )
);
decoder decoder_inst1(
        .hex_in                 (sec_h                  ),
        .hex_out                (HEX3                   )
);
decoder decoder_inst2(
        .hex_in                 (smg_min_l              ),
        .hex_out                (HEX4                   )
);
decoder decoder_inst3(
        .hex_in                 (smg_min_h              ),
        .hex_out                (HEX5                   )
);
decoder decoder_inst4(
        .hex_in                 (smg_hour_l             ),
        .hex_out                (HEX6                   )
);
decoder decoder_inst5(
        .hex_in                 (smg_hour_h             ),
        .hex_out                (HEX7                   )
);

endmodule
