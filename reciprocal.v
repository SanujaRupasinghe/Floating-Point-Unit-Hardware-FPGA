module reciprocal(
    input [31:0] fp_in,      
    output reg [31:0] fp_out 
    );
    
    wire sign_in;
    wire [7:0] exponent_in;
    wire [22:0] mantissa_in;

    assign sign_in = fp_in[31];           
    assign exponent_in = fp_in[30:23];   
    assign mantissa_in = fp_in[22:0];     

    reg sign_out;
    reg [7:0] exponent_out;
    reg [22:0] mantissa_out;
    
    always @(*) begin
        // Handle special cases (zero, infinity, NaN)
        if (exponent_in == 8'b11111111) begin
            // If input is infinity or NaN, reciprocal is NaN
            fp_out = fp_in;
				
        end else if (exponent_in == 8'b00000000 && mantissa_in == 23'b0) begin
            // If input is zero, reciprocal is infinity (with sign)
            fp_out = {sign_in, 8'b11111111, 23'b0};
				
        end else begin
            // The sign bit remains the same for the reciprocal
            sign_out = sign_in;
            
            // Calculate the new exponent: 254 - input exponent
            exponent_out = 8'd254 - exponent_in;
            
            // Mantissa remains the same for a normalized number (assuming precision is enough)
            mantissa_out = mantissa_in;

            fp_out = {sign_out, exponent_out, mantissa_out};
        end
    end

endmodule
