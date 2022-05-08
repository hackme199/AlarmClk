module alck_controller (
    input clk, rst, one_second, alarm_button, time_button,
    input[3:0] key,
    output reset_count, load_new_c, show_new_time,
           show_a, load_new_a, shift
);

    reg[2:0] prestate, next_state;
    // reg[7:0] counter256;
    // reg[3:0] counter10;

    //reg[3:0] counter;
    // Define registers for counting 10 secs in KEY_ENTRY and KEY_WAITED state
    reg [3:0] count1,count2;
    wire timeout;

    parameter SHOW_TIME = 3'd0,
              KEY_STORED = 3'd1,
              SHOW_ALARM = 3'd2,
              KEY_WAITED = 3'd3,
              KEY_ENTRY = 3'd4,
              SET_ALARM_TIME = 3'd5,
              SET_CURRENT_TIME = 3'd6,
              NO_KEY = 10;

    // present_state
    always @(posedge clk, posedge rst) begin
        if(rst) prestate <= SHOW_TIME;
        else prestate <= next_state;
    end

    // timer
    // always @(posedge clk, posedge rst) begin
    //     if(rst) begin
    //         //counter256 <= 8'd0;
    //         counter <= 4'd0;
    //         //timeout <= 1'b0;
    //     end 
    //     // else if(prestate == KEY_ENTRY || prestate == KEY_WAITED) begin
    //     //     counter256 <= counter256 + 1'b1;
    //     //     if(counter256 == 8'b00) begin
    //     //         counter10 <= counter10 + 1'b1;
    //     //         if(counter10 == 4'd10) timeout <= 1'b1';
    //     //     end
    //     // end
    //     else if(prestate == KEY_ENTRY || prestate == KEY_WAITED) begin
    //         if(counter == 4'd10) counter <= 4'd0;
    //         else if(one_second) counter <= counter + 1'b1;
    //     end
    // end


    //Counts 10 seconds pulses for KEY_ENTRY state
    always @ (posedge clk or posedge rst)
    begin
    // Upon reset, set the count1 value to 1'b0
    if(rst)
        count1 <= 4'd0;
    // Else check if present state is a state other than KEY_ENTRY, then set the count1 value to 1'b0
    else if(!(prestate == KEY_ENTRY))
        count1 <= 4'd0;
    // Else check if the count1 value reaches 'd9, then set the count1 to 1'b0
    else if (count1==9)
        count1 <= 4'd0;
    // Else increment the count for every one_second pulse
    else if(one_second)
        count1 <= count1 + 1'b1;
    end

    //Counts 10 seconds pulses for KEY_WAITED state
    always @ (posedge clk or posedge rst)
    begin
    // Upon reset, set the count2 value to 1'b0
    if(rst)
        count2 <= 4'd0;
    // Else check if present state is a state other than KEY_WAITED, then set the count2 value to 1'b0
    else if(!(prestate == KEY_WAITED))
        count2 <= 4'd0;
    // Else check if the count2 value reaches 'd9, then set the count2 to 1'b0
    else if (count2==9)
        count2 <= 4'd0;
    // Else increment the count for every one_second pulse
    else if(one_second)
        count2 <= count2 + 1'b1;
    end

    //Time out logic  // Assert time_out signal whenever the count1 or count2 reaches 'd9
    assign timeout=((count1==9) || (count2==9)) ? 1 : 0;



    //next_state
    // always @(posedge clk, posedge rst) begin
    // @ change in inputs
    always @(prestate, alarm_button, time_button, key, timeout) begin
        case(prestate)
            SHOW_TIME : begin
                if(alarm_button) next_state <= SHOW_ALARM;
                else if(key != NO_KEY) next_state <= KEY_STORED;
                else next_state <= prestate;
            end

            KEY_STORED : begin
                next_state <= KEY_WAITED;
            end

            SHOW_ALARM : begin
                if(!alarm_button) next_state <= SHOW_TIME;
                else next_state <= SHOW_ALARM;
            end

            KEY_WAITED : begin
                if(timeout) begin
                    next_state <= SHOW_TIME;
                    // timeout <= 1'b0;
                    // counter10 <= 4'd0;
                    //counter <= 4'd0;
                end
                else if(key == 10) begin
                    next_state <= KEY_ENTRY;
                    // timeout <= 1'b0;
                    // counter10 <= 4'd0;
                    // counter256 <= 8'd0;
                    //counter <= 4'd0;
                end
                else next_state <= KEY_WAITED;
            end

            KEY_ENTRY : begin
                if(timeout) begin
                    next_state <= SHOW_TIME;
                    //timeout <= 1'b0;
                    //counter10 <= 4'd0;
                    //counter <= 4'd0;
                end
                else if(key != 10) next_state <= KEY_STORED;
                else if(alarm_button) next_state <= SET_ALARM_TIME;
                else if(time_button) next_state <= SET_CURRENT_TIME;
                else next_state <= KEY_ENTRY;
            end

            SET_ALARM_TIME : begin
                next_state <= SHOW_TIME;
            end

            SET_CURRENT_TIME : begin
                next_state <= SHOW_TIME;
            end
        endcase
    end

    //output
    assign show_new_time = (prestate == KEY_ENTRY || prestate == KEY_WAITED ||prestate == KEY_STORED) ? 1 : 0;
    assign show_a = prestate == SHOW_ALARM ? 1 : 0;
    assign load_new_a = prestate == SET_ALARM_TIME ? 1 : 0;
    assign load_new_c = prestate == SET_CURRENT_TIME ? 1 : 0;
    assign reset_count = prestate == SET_CURRENT_TIME ? 1 : 0;
    assign shift = prestate == KEY_STORED ? 1 : 0;
    //assign timeout = ((prestate == KEY_ENTRY && timeout) || (prestate == KEY_WAITED) || rst) ? 0 : 1;
    //assign timeout = ((counter == 'd10)) ? 1 : 0;
endmodule