module au_top(
    input clk,
    input rst_n,
    output reg [7:0] led,
    input usb_rx,
    output usb_tx
);

    wire rst;
    reg [31:0] counter = 0;
    reg [2:0] led_index = 0;
    reg [15:0] lfsr = 16'hACE1;
    reg random_mode = 1'b1; // Add this variable to keep track of the mode
    
    reset_conditioner reset_conditioner(.clk(clk), .in(!rst_n), .out(rst));

    // One-second interval counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 32'h0;
        else if (counter < 32'h5F5E100)
            counter <= counter + 1;
        else
            counter <= 32'h0;
    end

    // LFSR for pseudo-random number generation
    always @(posedge clk) begin
        if (counter == 32'h5F5E100) begin
            lfsr <= {lfsr[14:0], lfsr[0] ^ lfsr[2] ^ lfsr[3] ^ lfsr[5]};
        end
    end

    // Mode switching logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            random_mode <= ~random_mode;  // Toggle the mode when reset button is pressed
        end
    end

    // LED logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led <= 8'h00;
            led_index <= 0;
        end else if (counter == 32'h5F5E100) begin
            led <= 8'h00;
            if (random_mode) begin  // Random mode
                led_index = lfsr[2:0];
            end else begin  // Sequential mode
                led_index <= led_index + 1;
                if (led_index >= 8)
                    led_index <= 0;
            end
            led[led_index] <= 1;
        end
    end

    assign usb_tx = usb_rx;

endmodule