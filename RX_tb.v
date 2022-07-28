`timescale 1ns/10ps
module RX_tb  ();
reg clk_Top;
reg rst_Top;
reg RX_IN_Top;
reg [4:0] Prescale_Top;
reg PAR_EN_TOP;
reg PAR_TYP_Top;
wire Data_Valid_Top;
wire [7:0] P_Data_Top;

parameter  Clock_Period = 5;
always #(2.5) clk_Top=~clk_Top;

initial begin
    $dumpfile("RX.vcd");
    $dumpvars;

    clk_Top='b1;
    rst_Top='b0;
    RX_IN_Top='b1;
    Prescale_Top='b00111;
    PAR_EN_TOP='b0;
    PAR_TYP_Top='b0;
    #(Clock_Period);
    rst_Top='b1;
    #(Clock_Period);

    zero_in();
    data_in_model1();
    one_in();

    $display("Test Case #1 Normal Senario No parity");
    if ((P_Data_Top=='b01010101)&&(Data_Valid_Top=='b1)) begin
        $display("passed");
    end else begin
        $display("FAILED");
    end
    #(Clock_Period);
    PAR_EN_TOP='b1;
    PAR_TYP_Top='b0;
    #(Clock_Period);
    zero_in();
    data_in_model1();
    zero_in();
    one_in();
    $display("Test Case #2 Normal Senario Even Parity");
    if ((P_Data_Top=='b01010101)&&(Data_Valid_Top=='b1)) begin
        $display("passed");
    end else begin
        $display("FAILED");
    end

    #(Clock_Period);
    PAR_TYP_Top='b1;
    #(Clock_Period);
    zero_in();
    data_in_model2();
    one_in();
    one_in();
    $display("Test Case #3 Normal Senario Odd Parity");
    if ((P_Data_Top=='b11111111)&&(Data_Valid_Top=='b1)) begin
        $display("passed");
    end else begin
        $display("FAILED");
    end

    #(Clock_Period);
    PAR_TYP_Top='b0;
    #(Clock_Period);
    zero_in();
    data_in_model1();
    one_in();
    one_in();
    $display("Test Case #4 Incorrect Parity Senario Even Parity");
    if ((P_Data_Top=='b01010101)&&(Data_Valid_Top=='b0)) begin
        $display("passed");
    end else begin
        $display("FAILED");
    end

    #(Clock_Period);
    PAR_TYP_Top='b1;
    #(Clock_Period);
    zero_in();
    data_in_model1();
    zero_in();
    one_in();
    $display("Test Case #4 Incorrect Parity Senario Odd Parity");
    if ((P_Data_Top=='b01010101)&&(Data_Valid_Top=='b0)) begin
        $display("passed");
    end else begin
        $display("FAILED");
    end
    
    $display("Test Case #5 3 Consecutive Frames Senario Mixed Parity");
    #(Clock_Period);
    PAR_EN_TOP='b1;
    PAR_TYP_Top='b0;
    #(Clock_Period);
    zero_in();
    data_in_model1();
    zero_in();
    one_in();
    $display("Frame #1 Even Parity");
    if ((P_Data_Top=='b01010101)&&(Data_Valid_Top=='b1)) begin
        $display("Passed");
    end else begin
        $display("FAILED");
    end
    PAR_TYP_Top='b1;
    zero_in();
    data_in_model2();
    one_in();
    one_in();
    $display("Frame #2 Odd Parity");
   if ((P_Data_Top=='b11111111)&&(Data_Valid_Top=='b1)) begin
        $display("Passed");
    end else begin
        $display("FAILED");
    end

    PAR_EN_TOP='b0;
    zero_in();
    data_in_model1();
    one_in();
    $display("Frame #3 NO Parity");
   if ((P_Data_Top=='b01010101)&&(Data_Valid_Top=='b1)) begin
        $display("Passed");
    end else begin
        $display("FAILED");
    end

   
   $stop;



end
task zero_in();
begin
    RX_IN_Top='b0;
    repeat(Prescale_Top+'b1)#(Clock_Period);
end
endtask

task one_in();
begin
    RX_IN_Top='b1;
    repeat(Prescale_Top+'b1)#(Clock_Period);
end
endtask
task data_in_model1();
begin
    RX_IN_Top='b1;
    repeat(Prescale_Top+'b1)#(Clock_Period);
    RX_IN_Top='b0;
    repeat(Prescale_Top+'b1)#(Clock_Period);
    RX_IN_Top='b1;
    repeat(Prescale_Top+'b1)#(Clock_Period);
    RX_IN_Top='b0;
    repeat(Prescale_Top+'b1)#(Clock_Period);
    RX_IN_Top='b1;
    repeat(Prescale_Top+'b1)#(Clock_Period);
    RX_IN_Top='b0;
    repeat(Prescale_Top+'b1)#(Clock_Period);
    RX_IN_Top='b1;
    repeat(Prescale_Top+'b1)#(Clock_Period);
    RX_IN_Top='b0;
    repeat(Prescale_Top+'b1)#(Clock_Period);
end
endtask

task data_in_model2();
begin
    RX_IN_Top='b1;
    repeat(Prescale_Top+'b1)#(Clock_Period);
   
    repeat(Prescale_Top+'b1)#(Clock_Period);
   
    repeat(Prescale_Top+'b1)#(Clock_Period);
  
    repeat(Prescale_Top+'b1)#(Clock_Period);
    
    repeat(Prescale_Top+'b1)#(Clock_Period);
    
    repeat(Prescale_Top+'b1)#(Clock_Period);
    
    repeat(Prescale_Top+'b1)#(Clock_Period);
   
    repeat(Prescale_Top+'b1)#(Clock_Period);
end
endtask


RX u_RX(
    .clk_Top        (clk_Top        ),
    .rst_Top        (rst_Top        ),
    .RX_IN_Top      (RX_IN_Top      ),
    .Prescale_Top   (Prescale_Top   ),
    .PAR_EN_TOP     (PAR_EN_TOP     ),
    .PAR_TYP_Top    (PAR_TYP_Top    ),
    .Data_Valid_Top (Data_Valid_Top ),
    .P_Data_Top     (P_Data_Top     )
);

    
endmodule