module  decoder(
        input         [ 3: 0]  hex_in                   ,
        output  reg   [ 6: 0]  hex_out 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/



//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//hex_out
always  @(*) begin
            case(hex_in)  //共阳极7段数码管，为低电平亮
                4'd0: hex_out     =      7'b100_0000;                  
                4'd1: hex_out     =      7'b111_1001;
                4'd2: hex_out     =      7'b010_0100;
                4'd3: hex_out     =      7'b011_0000;
                4'd4: hex_out     =      7'b001_1001;
                4'd5: hex_out     =      7'b001_0010;
                4'd6: hex_out     =      7'b000_0010;
                4'd7: hex_out     =      7'b111_1000;
                4'd8: hex_out     =      7'b000_0000;
                4'd9: hex_out     =      7'b001_0000;
                default:
                      hex_out     =      7'b111_1111;
            endcase
end



endmodule