module aclk_areg (
    input clk, rst, load_new_a,
    input[3:0] new_alarm_ms_hr,
               new_alarm_ms_min,
               new_alarm_ls_hr,
               new_alarm_ls_min,
    output reg[3:0] alarm_time_ms_hr,
                alarm_time_ms_min,
                alarm_time_ls_hr,
                alarm_time_ls_min
);

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            {alarm_time_ms_hr,
            alarm_time_ms_min,
            alarm_time_ls_hr,
            alarm_time_ls_min} <= 16'b0;
        end

        else if(load_new_a) begin
            alarm_time_ms_hr <= new_alarm_ms_hr;
            alarm_time_ms_min <= new_alarm_ms_min;
            alarm_time_ls_hr <= new_alarm_ls_hr;
            alarm_time_ls_min <= new_alarm_ls_min;
        end
    end
    
endmodule