/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-23 10:25
 * Last modified : 2018-04-23 10:25
 * Filename      : debounce.v
 * Description   : 
 * *********************************************************************/
module  sw_debounce(
        input                   clk                     ,
        input                   rst_n                   ,
        //sw
        input                   sw_in                   ,
        output  wire            sw_out 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   TIME_20MS           =        1_000_000              ;//clk=50Mhz 20ms 
reg     [24: 0]                 cnt                             ;
wire                            add_cnt                         ;
wire                            end_cnt                         ;

reg     [ 1: 0]                 sw_r                            ; 

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//sw_r  打两拍，这里是异步处理
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        sw_r   <=      'd0;
    end
    else begin
        sw_r   <=      {sw_r[0],sw_in};
    end
end

//cnt
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt <= 0;
    end
    else if(add_cnt)begin
        if(end_cnt)
            cnt <= cnt;  
        else
            cnt <= cnt + 1;
    end
    else begin
        cnt <=  0;
    end
end

assign  add_cnt     =       sw_r[1] == 1'b1;       
assign  end_cnt     =       add_cnt && cnt == TIME_20MS-1;   

assign  sw_out      =       end_cnt;





endmodule

