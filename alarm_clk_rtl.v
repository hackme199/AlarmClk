module alarm_clk_rtl (
    input clk, rst, alarm_button, time_button, fast_watch,
    input[3:0] key,

    output sound_alarm,
    output[7:0] ms_hr, ls_hr, ms_min, ls_min
);

    wire rst_cnt, one_minute, one_second,
         load_new_c, show_new_time,
         show_a, load_new_a, shift;

    wire[3:0] key_buffer_ms_hr,
         key_buffer_ls_hr,
         key_buffer_ms_min,
         key_buffer_ls_min,

         alarm_time_ms_hr,
         alarm_time_ms_min,
         alarm_time_ls_hr,
         alarm_time_ls_min,

         current_time_ms_hr,
         current_time_ms_min,
         current_time_ls_hr,
         current_time_ls_min;

    alck_controller controller(
        clk, rst, one_second, alarm_button, time_button,
        key, rst_cnt, load_new_c, show_new_time,
        show_a, load_new_a, shift
    );

    timegen timegen(
        clk, rst, rst_cnt, fast_watch, one_minute,
        one_second
    );

    aclk_areg a_reg(
        clk, rst, load_new_a,
        key_buffer_ms_hr,
        key_buffer_ms_min,
        key_buffer_ls_hr,
        key_buffer_ls_min,

        alarm_time_ms_hr,
        alarm_time_ms_min,
        alarm_time_ls_hr,
        alarm_time_ls_min
    );

    aclk_counter counter(
        clk, rst, one_minute, load_new_c,
        key_buffer_ms_hr,
        key_buffer_ms_min,
        key_buffer_ls_hr,
        key_buffer_ls_min,

        current_time_ms_hr,
        current_time_ms_min,
        current_time_ls_hr,
        current_time_ls_min
    );
    
    aclk_keyreg keyreg(
        clk, rst, shift, key,
        key_buffer_ms_hr,
        key_buffer_ls_hr,
        key_buffer_ms_min,
        key_buffer_ls_min
    );

    aclk_lcd_display lcd_disp(
        current_time_ms_hr,
        current_time_ms_min,
        current_time_ls_hr,
        current_time_ls_min,

        alarm_time_ms_hr,
        alarm_time_ms_min,
        alarm_time_ls_hr,
        alarm_time_ls_min,

        key_buffer_ms_hr,
        key_buffer_ms_min,
        key_buffer_ls_hr,
        key_buffer_ls_min,

        show_new_time, show_a,

        sound_alarm, ms_hr, ms_min, ls_hr, ls_min
    );

    //aclk_lcd_driver lcd_driver();

endmodule