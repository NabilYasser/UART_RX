module Parity_Check #(
    parameter Data_size='d8
) (
    input  wire  clk         ,
    input  wire  rst         ,
    input  wire  par_check_en,
    input  wire  PAR_TYP     ,
    input  wire  sampled_bit ,
    input  wire [Data_size-1:0] P_DATA ,
    output reg   par_err
);
wire parity_rst;
reg parity_clac;
assign parity_rst=rst &par_check_en;

    always @(*) begin
        if (!PAR_TYP) begin
            parity_clac=^P_DATA;
        end else begin
            parity_clac=~^P_DATA;
        end

    end

    always @(posedge clk or negedge rst) begin
        if (!parity_rst) begin
            par_err<='b0;
        end else if (sampled_bit==parity_clac) begin
            par_err<='b0;
        end else begin
            par_err<='b1;
        end

    end
endmodule