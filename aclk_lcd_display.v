// module cmp (
//     input[3:0] a, b,
//     output c
// );

//     assign c = (a == b) ? 1 : 0;

// endmodule

// This module is a wrapper..
module aclk_lcd_display (
    input[3:0] current_time_ms_hr,
               current_time_ms_min,
               current_time_ls_hr,
               current_time_ls_min,

               alarm_time_ms_hr,
               alarm_time_ms_min,
               alarm_time_ls_hr,
               alarm_time_ls_min,

               key_ms_hr,
               key_ms_min,
               key_ls_hr,
               key_ls_min,
    input show_new_time, show_a,

    output sound_alarm,
    output[7:0] display_ms_hr,
                display_ms_min,
                display_ls_hr,
                display_ls_min
);

    wire ms_hr, ms_min, ls_hr, ls_min;

    // cmp c1(current_time_ms_hr, alarm_time_ms_hr, ms_hr);
    // cmp c2(current_time_ms_min, alarm_time_ms_min, ms_min);
    // cmp c3(current_time_ls_hr, alarm_time_ls_hr, ls_hr);
    // cmp c4(current_time_ls_min, alarm_time_ls_min, ls_min);

    assign sound_alarm = (ms_hr & ms_min & ls_hr & ls_min);

    // always @(*) begin
    //     if(show_new_time) begin
    //         display_ms_hr <= key_ms_hr;
    //         display_ms_min <= key_ms_min;
    //         display_ls_hr <= key_ls_hr;
    //         display_ls_min <= key_ls_min;
    //     end

    //     else if(show_a) begin
    //         display_ms_hr <= alarm_time_ms_hr;
    //         display_ms_min <= alarm_time_ms_min;
    //         display_ls_hr <= alarm_time_ls_hr;
    //         display_ls_min <= alarm_time_ls_min;
    //     end
    // end

    aclk_lcd_driver d_ms_hr1(show_a, show_new_time, alarm_time_ms_hr, current_time_ms_hr, key_ms_hr, ms_hr, display_ms_hr);
    aclk_lcd_driver d_ms_hr2(show_a, show_new_time, alarm_time_ms_min, current_time_ms_min, key_ms_min, ms_min, display_ms_min);
    aclk_lcd_driver d_ms_hr3(show_a, show_new_time, alarm_time_ls_hr, current_time_ls_hr, key_ls_hr, ls_hr, display_ls_hr);
    aclk_lcd_driver d_ms_hr4(show_a, show_new_time, alarm_time_ls_min, current_time_ls_min, key_ls_min, ls_min, display_ls_min);
    
endmodule