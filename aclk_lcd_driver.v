module aclk_lcd_driver (
    input show_a, show_new_time, input[3:0] alarm_time,
    current_time, key_time,
    output sound_alarm, output reg[7:0] display_time
);

    reg[3:0] disp_time;

    assign sound_alarm = (current_time == alarm_time) ? 1'b1 : 1'b0;

    always @(*) begin
        case({show_a, show_new_time})
            2'b10 : disp_time <= alarm_time;
            2'b00 : disp_time <= current_time;
            2'b01 : disp_time <= key_time;
        endcase
    end

    always @(disp_time) begin
        case(disp_time)
            4'd0 : display_time <= 8'h30;
            4'd1 : display_time <= 8'h31;
            4'd2 : display_time <= 8'h32;
            4'd3 : display_time <= 8'h33;
            4'd4 : display_time <= 8'h34;
            4'd5 : display_time <= 8'h35;
            4'd6 : display_time <= 8'h36;
            4'd7 : display_time <= 8'h37;
            4'd8 : display_time <= 8'h38;
            4'd9 : display_time <= 8'h39;

        endcase
    end

endmodule