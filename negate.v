module negate (
    input wire [7:0] in_val, 
    output wire [7:0] out_val 
);

assign out_val = {~in_val[7], in_val[6:0]};

endmodule
