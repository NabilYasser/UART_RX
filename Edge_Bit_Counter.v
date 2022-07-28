module Edge_Bit_Counter #(
    parameter Counter_Size='d5, Start_Point='d0
) (
    input   wire                     clk    ,
    input   wire                     rst    ,
    input   wire                     enable , 
    input   wire [Counter_Size-1:0]  Prescale   ,
    output  reg  [Counter_Size-1:0]  edge_cnt,
    output  wire                     finish
);
wire counter_rst;



    always @(posedge clk or negedge rst) begin
        if (!counter_rst) begin
            edge_cnt<=Start_Point;
        end else begin
            edge_cnt<=edge_cnt+'b1;
        end
    end

    assign finish=(edge_cnt==Prescale);
    assign counter_rst=(~finish & rst & enable );



    
endmodule