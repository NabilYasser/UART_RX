module Deserializer #(
    parameter bits_couner_size='d3 , Data_size='d8
) (
    input  wire sampled_bit,
    input  wire clk        ,
    input  wire rst        , 
    input  wire deser_en   ,
    input  wire [bits_couner_size-1:0] bits_counter, 
    output reg  [Data_size-1:0] Data 

);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        Data<='b0;
    end else if(deser_en) begin
        Data[bits_counter]<=sampled_bit;
        //! the enable siganl should be only at the last clock now there is some glitch switching
       //Data<={sampled_bit,Data[Data_size-1:1]};
    end
end
    
endmodule