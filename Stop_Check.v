module Stop_Check (
    input  wire  clk,
    input  wire  rst,
    input  wire  sampled_bit,
    input  wire  stop_check_en,
    output  reg  stop_err
);

assign stop_rst=rst&stop_check_en;

    always @(posedge clk or negedge stop_rst) begin
        if (!stop_rst) begin
            stop_err<='b0;
        end else if (sampled_bit=='b0) begin
                stop_err<='b1;
        end
    end

endmodule