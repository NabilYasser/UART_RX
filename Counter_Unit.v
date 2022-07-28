module Counter_Unit #(
    parameter Counter_Size='d5
) (
    input  wire clk,
    input  wire rst,
    input  wire enable,
    input  wire Data_enable, 
    input  wire [Counter_Size-1:0]  Prescale   ,
    output wire                     Finish_edge,
    output wire                     Finish_data,
    output wire [2:0]               bits_counter,
    output wire [Counter_Size-1:0]  edge_cnt

);
    wire Bits_counter_enable;
    assign Bits_counter_enable= Finish_edge & Data_enable; //!


    Bits_Counter  u_Bits_Counter(
    	.clk    (clk    ),
        .rst    (rst    ),
        .enable (Bits_counter_enable ),
        .bits_counter(bits_counter),
        .finish (Finish_data )
    );


    Edge_Bit_Counter  u_Edge_Bit_Counter(
    	.clk      (clk      ),
        .rst      (rst      ),
        .enable   (enable   ),
        .Prescale (Prescale ),
        .edge_cnt (edge_cnt ),
        .finish   (Finish_edge   )
    );
    
    
endmodule