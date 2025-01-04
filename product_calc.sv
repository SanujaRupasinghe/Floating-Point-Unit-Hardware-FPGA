module product_calc(
    input  logic clk,               // Clock signal
    input  logic rst_n,             // Reset signal (active low)
    input  logic in_ready,          // Input ready signal
    output logic out_ready,         // Output ready signal
    input  logic [23:0] a_m,        // Input operand a_m
    input  logic [23:0] b_m,        // Input operand b_m
    output logic [47:0] product_out // Output product
);
    logic [23:0] sum, diff;
    logic [47:0] sum_sq, diff_sq;

    // LUTs for square values
    logic [47:0] lut_sum_sq [0:16777215];
    logic [47:0] lut_diff_sq [0:16777215];

    // State machine
    typedef enum logic [1:0] {IDLE, CALC_LUT, CALC_PRODUCT, READY} state_t;
    state_t state;

    // LUT Initialization
    initial begin
        logic [47:0] current_sum, current_diff;
        current_sum = 0;
        current_diff = 0;
        for (int i = 0; i < 16777216; i++) begin
            if (i > 0) begin
                current_sum = current_sum + (2 * i - 1); // Square value for i
                current_diff = current_diff + (2 * i - 1); // Square value for i
            end
            lut_sum_sq[i] = current_sum;
            lut_diff_sq[i] = current_diff;
        end
    end

    // Sequential Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            out_ready <= 0;
            product_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    out_ready <= 0;
                    if (in_ready) begin
                        sum <= a_m + b_m;
                        diff <= a_m - b_m;
                        state <= CALC_LUT;
                    end
                end

                CALC_LUT: begin
                    sum_sq <= lut_sum_sq[sum];
                    diff_sq <= lut_diff_sq[diff];
                    state <= CALC_PRODUCT;
                end

                CALC_PRODUCT: begin
                    product_out <= (sum_sq - diff_sq) >> 2;
                    state <= READY;
                end

                READY: begin
                    out_ready <= 1;
                    if (!in_ready) state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
