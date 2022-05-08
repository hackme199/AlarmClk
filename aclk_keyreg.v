module aclk_keyreg (
    input clk, rst, shift,
    input[3:0] key,
    output reg[3:0] key_buffer_ms_hr,
                key_buffer_ls_hr,
                key_buffer_ms_min,
                key_buffer_ls_min
);

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            key_buffer_ls_min <= 4'b0;
            key_buffer_ms_min <= 4'b0;
            key_buffer_ls_hr <= 4'b0;
            key_buffer_ms_hr <= 4'b0;
        end

        else begin
            if(shift) begin
                key_buffer_ls_min <= key;
                key_buffer_ms_min <= key_buffer_ls_min;
                key_buffer_ls_hr <= key_buffer_ms_min;
                key_buffer_ms_hr <= key_buffer_ls_hr;
            end
        end
           
    end
    
endmodule