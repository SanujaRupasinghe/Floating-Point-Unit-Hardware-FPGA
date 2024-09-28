module multiply_24 (
    input wire [23:0] A,     
    input wire [23:0] B,      
    output reg [47:0] result, 
	 output reg mult_24_output_ready,
	 input wire mult_24_input_ready
);


reg [47:0] regs [23:0];   
integer i, j;  
	 
always @(*) begin

if (mult_24_input_ready) begin
    for (i = 0; i <= 23; i = i + 1) begin
        regs[i] = 48'b0;
    end
        
        
    for (i = 0; i <= 23; i = i + 1) begin
        if (B[i] == 1) begin
            regs[i] = {24'b0, A} << i; 
        end
    end
        
    result = 48'b0;
    for (i = 0; i <= 23; i = i + 1) begin
        result = result + regs[i];  
    end
	 
	 if (result != 0) begin
		 mult_24_output_ready <= 1;
	 end else begin
		 mult_24_output_ready <= 0;
	 end
end


end



endmodule