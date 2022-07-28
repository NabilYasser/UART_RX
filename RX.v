module RX #(
    parameter Counter_Size='d5, Start_Point='d1
) (
    input  wire                    clk_Top     ,
    input  wire                    rst_Top     ,
    input  wire                    RX_IN_Top   ,
    input  wire [Counter_Size-1:0] Prescale_Top,
    input  wire                    PAR_EN_TOP  ,
    input  wire                    PAR_TYP_Top ,
    output wire                    Data_Valid_Top,
    output wire [7:0]              P_Data_Top


);
wire bit_cnt_Top; //Counter Finish Flag
wire [Counter_Size-1:0] edge_cnt_Top; // Counter Output
wire enable_Top; //Counter Enable
wire par_err_Top,start_err_Top,stop_err_Top; // Checks Error output 
wire par_check_en_Top,start_check_en_Top,stop_check_en_Top; //Checks Error Enable
wire data_samp_en_Top; //Data Sampling Enable
wire deser_en_Top,deser_en_FSM_Top; //Deserializer Enable
//*wire bit_valid_Top;
//!assign deser_en_Top=deser_en_FSM_Top & bit_valid_Top;
wire sampled_bit_Top;
wire data_finish_flag_Top,bits_counter_en_Top;
wire [2:0] bits_counter_Top;

    FSM u_FSM(
    	.clk            (clk_Top            ),
        .rst            (rst_Top            ),
        .RX_IN          (RX_IN_Top          ),
        .PAR_EN         (PAR_EN_TOP         ),
        .Prescale       (Prescale_Top[4:3]  ),
        .bit_cnt        (bit_cnt_Top        ),
        .data_finish_flag (data_finish_flag_Top ),
        .edge_cnt       (edge_cnt_Top       ),
        .par_err        (par_err_Top        ),
        .start_err      (start_err_Top      ),
        .stop_err       (stop_err_Top       ),
        .counter_en     (enable_Top         ),
        .bits_counter_en(bits_counter_en_Top),
        .data_samp_en   (data_samp_en_Top   ),
        .start_check_en (start_check_en_Top ),
        .deser_en       (deser_en_FSM_Top   ),
        .par_check_en   (par_check_en_Top   ),
        .stop_check_en  (stop_check_en_Top  ),
        .data_valid     (Data_Valid_Top     )
    );

    Start_Check u_Start_Check(
    	.clk            (clk_Top            ),
        .rst            (rst_Top            ),
        .sampled_bit    (sampled_bit_Top    ),
        .start_check_en (start_check_en_Top ),
        .start_err      (start_err_Top      )
    );

    Parity_Check  u_Parity_Check(
    	.clk          (clk_Top          ),
        .rst          (rst_Top          ),
        .par_check_en (par_check_en_Top ),
        .PAR_TYP      (PAR_TYP_Top      ),
        .sampled_bit  (sampled_bit_Top  ),
        .P_DATA       (P_Data_Top       ),
        .par_err      (par_err_Top      )
    );
    
    Stop_Check u_Stop_Check(
    	.clk           (clk_Top           ),
        .rst           (rst_Top           ),
        .sampled_bit   (sampled_bit_Top   ),
        .stop_check_en (stop_check_en_Top ),
        .stop_err      (stop_err_Top      )
    );
    
    
Counter_Unit u_Counter_Unit(
    .clk         (clk_Top         ),
    .rst         (rst_Top         ),
    .enable      (enable_Top       ),
    .Data_enable (bits_counter_en_Top ),
    .Prescale    (Prescale_Top    ),
    .Finish_edge (bit_cnt_Top ),
    .Finish_data (data_finish_flag_Top ),
    .bits_counter(bits_counter_Top),
    .edge_cnt    (edge_cnt_Top    )
);

    Data_Sampling #(
        .Counter_Size (Counter_Size )
    )
    u_Data_Sampling(
    	.RX_in        (RX_IN_Top        ),
        .clk          (clk_Top          ),
        .rst          (rst_Top          ),
        .data_samp_en (data_samp_en_Top ),
        //*.bit_valid    (bit_valid_Top    ),
        .sampled_bit  (sampled_bit_Top  )
    );
    
Deserializer u_Deserializer(
    .sampled_bit  (sampled_bit_Top  ),
    .clk          (clk_Top          ),
    .rst          (rst_Top          ),
    .deser_en     (deser_en_FSM_Top), //!
    .bits_counter (bits_counter_Top ),
    .Data         (P_Data_Top         )
);



endmodule