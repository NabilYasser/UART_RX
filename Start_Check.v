module Start_Check (
    input  wire  clk,
    input  wire  rst,
    input  wire  sampled_bit,
    input  wire  start_check_en,
    output  reg  start_err
);
assign start_rst=rst&start_check_en;

    always @(posedge clk or negedge start_rst) begin
        if (!start_rst) begin
            start_err<='b0;
        end else if (sampled_bit=='b1) begin
                start_err<='b1;
        end
    end

endmodule