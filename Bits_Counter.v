module Bits_Counter #(
    parameter Counter_Size='d3, Start_Point='d0,Num_of_Bits=3'b111
) (
    input   wire                     clk    ,
    input   wire                     rst    ,
    input   wire                     enable ,
    output  reg [Counter_Size-1:0]   bits_counter,
    output  wire                      finish
);
//wire counter_rst;




    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            bits_counter<=Start_Point;
        end else if (enable) begin
            bits_counter<=bits_counter+'b1;
        end
    end
                /*
        always @(posedge clk or negedge rst) begin
        if (!rst) begin
            finish<='b0;
        end else if ((bits_counter==Num_of_Bits)&& enable) begin
            finish<='b1;
        end
    end*/
   // assign counter_rst=(~ & rst );
   assign finish=(bits_counter==Num_of_Bits) & enable;
    
endmodule