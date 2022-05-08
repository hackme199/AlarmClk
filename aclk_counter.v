module aclk_counter (
    input clk, rst, one_minute, load_new_c,
    input[3:0] new_current_time_ms_hr,
               new_current_time_ms_min,
               new_current_time_ls_hr,
               new_current_time_ls_min,
    output reg[3:0] current_time_ms_hr,
                    current_time_ms_min,
                    current_time_ls_hr,
                    current_time_ls_min
);

    // defining additional regs was redundant!

    // reg[3:0] ls_min, ms_min, ls_hr, ms_hr;

    // always @(posedge clk) begin
    //     if(one_minute) begin
    //         if(ms_hr == 4'd2 && ls_hr == 4'd3 && ms_min == 4'd5 && ls_min == 4'd9) begin
    //             ls_min <= 4'b0;
    //             ms_min <= 4'b0;
    //             ls_hr <= 4'b0;
    //             ms_hr <= 4'd0;
    //         end

    //         if(ls_hr == 4'd9 && ms_min == 4'd5 && ls_min == 4'd9) begin
    //             ls_min <= 4'b0;
    //             ms_min <= 4'b0;
    //             ls_hr <= 4'b0;
    //             ms_hr <= ms_hr + 1'b1;
    //         end

    //         else if(ms_min == 4'd5 && ls_min == 4'd9) begin
    //             ls_min <= 4'b0;
    //             ms_min <= 4'b0;
    //             ls_hr <= ls_hr + 1'b1;
    //         end

    //         else if(ls_min == 4'd9) begin
    //             ls_min <= 4'b0;
    //             ms_min <= ms_min + 1'b1;
    //         end

    //         else ls_min <= ls_min + 1'b1;
    //     end
    // end

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            {current_time_ms_hr,
            current_time_ms_min,
            current_time_ls_hr,
            current_time_ls_min} <= 16'b0;
        end

        else if(load_new_c & !rst) begin
            current_time_ms_hr <= new_current_time_ms_hr;
            current_time_ms_min <= new_current_time_ms_min;
            current_time_ls_hr <= new_current_time_ls_hr;
            current_time_ls_min <= new_current_time_ls_min;

            // ms_hr <= new_current_time_ms_hr;
            // ms_min <= new_current_time_ms_min;
            // ls_hr <= new_current_time_ls_hr;
            // ls_min <= new_current_time_ls_min;
        end

        else if(!load_new_c & one_minute) begin
            // current_time_ms_hr <= ms_hr;
            // current_time_ms_min <= ms_min;
            // current_time_ls_hr <= ls_hr;
            // current_time_ls_min <= ls_min;

            if(current_time_ms_hr == 4'd2 && current_time_ls_hr == 4'd3 && current_time_ms_min == 4'd5 && current_time_ls_min == 4'd9) begin
                current_time_ls_min <= 4'b0;
                current_time_ms_min <= 4'b0;
                current_time_ls_hr <= 4'b0;
                current_time_ms_hr <= 4'd0;
            end

            if(current_time_ls_hr == 4'd9 && current_time_ms_min == 4'd5 && current_time_ls_min == 4'd9) begin
                current_time_ls_min <= 4'b0;
                current_time_ms_min <= 4'b0;
                current_time_ls_hr <= 4'b0;
                current_time_ms_hr <= current_time_ms_hr + 1'b1;
            end

            else if(current_time_ms_min == 4'd5 && current_time_ls_min == 4'd9) begin
                current_time_ls_min <= 4'b0;
                current_time_ms_min <= 4'b0;
                current_time_ls_hr <= current_time_ls_hr + 1'b1;
            end

            else if(current_time_ls_min == 4'd9) begin
                current_time_ls_min <= 4'b0;
                current_time_ms_min <= current_time_ms_min + 1'b1;
            end

            else current_time_ls_min <= current_time_ls_min + 1'b1;

            end
        end
    
    
endmodule