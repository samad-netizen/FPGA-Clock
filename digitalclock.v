module digitalclock(

    input rst, clk,

    output reg [3:0] sec_ones, min_ones, hr_ones,

    output reg[2:0]sec_tens,min_tens,

    output reg[1:0] hr_tens,

    output reg [6:0] sevseg,

    output reg [7:0] an

);

 

reg [26:0] clkdiv;

reg clkd;

reg [2:0] display_count;

reg [16:0] refresh_counter;

 

// Clock divider for 1hz

always @(posedge clk, negedge rst) begin

    if(!rst)

        clkdiv <= 0;

    else begin

        clkdiv <= clkdiv + 1;

        clkd = clkdiv[26];

    end

end

 

// Counter for seconds ones place

always @(posedge clkd, negedge rst) begin

    if(!rst)

        sec_ones <= 0;

    else if(sec_ones == 9)

        sec_ones <= 0;

    else

        sec_ones <= sec_ones + 1;

end

 

// Counter for seconds tens place

always @(posedge clkd, negedge rst) begin

    if(!rst)

        sec_tens <= 0;

    else if(sec_ones == 9) begin

        if(sec_tens == 5)

            sec_tens <= 0;

        else

            sec_tens <= sec_tens + 1;

    end

end

 

// Counter for minutes ones place

always @(posedge clkd, negedge rst) begin

    if(!rst)

        min_ones <= 0;

    else if(sec_ones == 9 && sec_tens == 5) begin

        if(min_ones == 9)

            min_ones <= 0;

        else

            min_ones <= min_ones + 1;

    end

end

 

// Counter for minutes tens place

always @(posedge clkd, negedge rst) begin

    if(!rst)

        min_tens <= 0;

    else if(sec_ones == 9 && sec_tens == 5 && min_ones == 9) begin

        if(min_tens == 5)

            min_tens <= 0;

        else

            min_tens <= min_tens + 1;

    end

end

 

// Counter for hours ones place

always @(posedge clkd, negedge rst) begin

    if(!rst)

        hr_ones <= 0;

    else if(sec_ones == 9 && sec_tens == 5 && min_ones == 9 && min_tens == 5) begin

        if(hr_ones == 9 || (hr_tens == 2 && hr_ones == 3))

            hr_ones <= 0;

        else

            hr_ones <= hr_ones + 1;

    end

end

 

// Counter for hours tens place

always @(posedge clkd, negedge rst) begin

    if(!rst)

        hr_tens <= 0;

    else if(sec_ones == 9 && sec_tens == 5 && min_ones == 9 && min_tens == 5) begin

        if(hr_ones == 9) begin

            if(hr_tens == 2)

                hr_tens <= 0;

            else

                hr_tens <= hr_tens + 1;

        end

    end

end

 

// Display multiplexing counter

always @(posedge clk) begin

    refresh_counter <= refresh_counter + 1;

end

 

// BCD to 7-segment decoder

always @* begin

    case(display_count)

        3'b000: begin  // Hours tens

            an = 8'b11011111;

            case(hr_tens)

                0: sevseg = 7'b0000001;

                1: sevseg = 7'b1001111;

                2: sevseg = 7'b0010010;

                default: sevseg = 7'b1111111;

            endcase

        end

        3'b001: begin  // Hours ones

            an = 8'b11101111;

            case(hr_ones)

                0: sevseg = 7'b0000001;

                1: sevseg = 7'b1001111;

                2: sevseg = 7'b0010010;

                3: sevseg = 7'b0000110;

                4: sevseg = 7'b1001100;

                5: sevseg = 7'b0100100;

                6: sevseg = 7'b0100000;

                7: sevseg = 7'b0001111;

                8: sevseg = 7'b0000000;

                9: sevseg = 7'b0000100;

                default: sevseg = 7'b1111111;

            endcase

        end

        3'b010: begin  // Minutes tens

            an = 8'b11110111;

            case(min_tens)

                0: sevseg = 7'b0000001;

                1: sevseg = 7'b1001111;

                2: sevseg = 7'b0010010;

                3: sevseg = 7'b0000110;

                4: sevseg = 7'b1001100;

                5: sevseg = 7'b0100100;

                default: sevseg = 7'b1111111;

            endcase

        end

        3'b011: begin  // Minutes ones

            an = 8'b11111011;

            case(min_ones)

                0: sevseg = 7'b0000001;

                1: sevseg = 7'b1001111;

                2: sevseg = 7'b0010010;

                3: sevseg = 7'b0000110;

                4: sevseg = 7'b1001100;

                5: sevseg = 7'b0100100;

                6: sevseg = 7'b0100000;

                7: sevseg = 7'b0001111;

                8: sevseg = 7'b0000000;

                9: sevseg = 7'b0000100;

                default: sevseg = 7'b1111111;

            endcase

        end

        3'b100: begin  // Seconds tens

            an = 8'b11111101;

            case(sec_tens)

                0: sevseg = 7'b0000001;

                1: sevseg = 7'b1001111;

                2: sevseg = 7'b0010010;

                3: sevseg = 7'b0000110;

                4: sevseg = 7'b1001100;

                5: sevseg = 7'b0100100;

                default: sevseg = 7'b1111111;

            endcase

        end

        3'b101: begin  // Seconds ones

            an = 8'b11111110;

            case(sec_ones)

                0: sevseg = 7'b0000001;

                1: sevseg = 7'b1001111;

                2: sevseg = 7'b0010010;

                3: sevseg = 7'b0000110;

                4: sevseg = 7'b1001100;

                5: sevseg = 7'b0100100;

                6: sevseg = 7'b0100000;

                7: sevseg = 7'b0001111;

                8: sevseg = 7'b0000000;

                9: sevseg = 7'b0000100;

                default: sevseg = 7'b1111111;

            endcase

        end

        default: begin

            an = 8'b11111111;

            sevseg = 7'b1111111;

        end

    endcase

end

 

// Display multiplexing control

always @(posedge clk) begin

    if(!rst)

        display_count <= 0;

    else

        display_count <= refresh_counter[16:14];  // Cycles through displays

end

 

endmodule
