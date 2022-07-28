module FSM #(parameter Counter_Size='d5) (
    input  wire clk,
    input  wire rst,
    input  wire RX_IN, // serial data input to the RX
    input  wire PAR_EN, // Parity Enable form the system should follow the TX
    input  wire [1:0] Prescale,
    input  wire bit_cnt, // Which bit is being received now
    input  wire data_finish_flag, 
    input  wire [Counter_Size-1:0] edge_cnt, // which edge the RX is at now 

    input  wire par_err, // parity error 
    input  wire start_err, // start error 
    input  wire stop_err, // stop error

    output reg counter_en, // Counter enable
    output reg bits_counter_en, //Bits Counter Enable

    output reg data_samp_en,
    //output reg comparitor_en, //! check it
    output reg start_check_en,
    output reg deser_en,
    output reg par_check_en,
    output reg stop_check_en,
    output reg data_valid
);

reg [2:0] CurrentState,NextState;
wire start_first,start_sec,start_third;
reg strt_error , par_error , stp_error;

localparam Idle =3'b000, 
           Start=3'b001,
           Data =3'b011,
           Parity=3'b111,
           Stop=3'b110;


always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        CurrentState<=Idle;

    end else begin
        CurrentState<=NextState;
    end 
end           


always @(*) begin
    counter_en='b0;
    start_check_en='b0;
    par_check_en='b0;
    stop_check_en='b0;
    bits_counter_en='b0;
    deser_en='b0;
    //data_valid='b0;

    case (CurrentState)
       Idle : begin
        if (!RX_IN) begin
            NextState=Start;
            counter_en='b1;
        end else begin
            NextState=Idle;
            counter_en='b0;

        end
       end

       Start:begin
        start_check_en=((Prescale[0]==1'b0)&(edge_cnt>=5'b00101))|((Prescale>=2'b01)&(edge_cnt>=5'b00111)) |((Prescale[1]==1'b1)&(edge_cnt>=5'b01011));
       // start_check_en='b1;
        if (start_err) begin
            NextState=Idle;
            counter_en='b0;
        end else begin
            if (!bit_cnt) begin
            NextState=Start;
            counter_en='b1;
        end else begin
            NextState=Data;
            counter_en='b0;
        end
        end
       end

       Data:begin
        deser_en=((Prescale[0]==1'b0)&(edge_cnt>=5'b00101))|((Prescale>=2'b01)&(edge_cnt>=5'b00111)) |((Prescale[1]==1'b1)&(edge_cnt>=5'b01011));
        bits_counter_en='b1;
        if (!data_finish_flag) begin
            NextState=Data;
            counter_en='b1;
            bits_counter_en='b1;
            //deser_en='b1;
        end else if (!PAR_EN) begin
            NextState=Stop;
            counter_en='b0;
        end else begin
            NextState=Parity;
            counter_en='b0;
        end
       end

       Parity:begin
        par_check_en=((Prescale[0]==1'b0)&(edge_cnt>=5'b00101))|((Prescale>=2'b01)&(edge_cnt>=5'b00111)) |((Prescale[1]==1'b1)&(edge_cnt>=5'b01011));
        // par_check_en='b1;
        if (!bit_cnt) begin
            NextState=Parity;
            counter_en='b1;
        end else begin
            NextState=Stop;
            counter_en='b0;
        end
       end

       Stop:begin
        stop_check_en=((Prescale[0]==1'b0)&(edge_cnt>=5'b00101))|((Prescale>=2'b01)&(edge_cnt>=5'b00111)) |((Prescale[1]==1'b1)&(edge_cnt>=5'b01011));
        if (stop_err) begin
            NextState=Idle;
            counter_en='b0;
        end else begin
        if (!bit_cnt) begin
            NextState=Stop;
            counter_en='b1;
        end else begin
            NextState=Idle;
            counter_en='b0;
            //data_valid='b1;
        end
        end
        

       end

        default: begin
            NextState=Idle;
        end
    endcase
end

always @(*) begin
    if (!(strt_error || par_error || stp_error)&&(NextState==Idle))  begin
        data_valid='b1;
    end else begin
        data_valid='b0;
    end
    
end


always @(*) begin
    if (!rst) begin
        strt_error<='b0;
    end else if (start_check_en)  begin   
        strt_error<=start_err;
    end
end

always @(*) begin
    if (!rst) begin
        par_error<='b0;
    end else if (par_check_en)  begin   
        par_error<=par_err;
    end
end

always @(*) begin
    if (!rst) begin
        stp_error<='b0;
    end else if (stop_check_en)  begin   
        stp_error<=stop_err;
    end
end


always @(*) begin
    if (start_first || start_sec || start_third) begin
        data_samp_en='b1;
    end else begin
        data_samp_en='b0;
    end
end

assign start_first=(Prescale[0]==1'b0)&((edge_cnt==5'b00010)|(edge_cnt==5'b00011)|(edge_cnt==5'b00100));
assign start_sec=(Prescale==2'b01)&((edge_cnt==5'b00100)|(edge_cnt==5'b00101)|(edge_cnt==5'b00110));
assign start_third=(Prescale[1]==1'b1)&((edge_cnt==5'b01000)|(edge_cnt==5'b01001)|(edge_cnt==5'b01010));    
endmodule