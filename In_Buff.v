module In_Buff(
    input [7: 0] data_in,
    input clk,
    input en,
    input rst,
//    output reg need_byte,
    output reg [7: 0] bulbs,
    output reg [7: 0] toTx,
    input wire wr_en,
	 input wire Tx_busy
    );

wire add_ready, sub_ready, mul_ready, div_ready;
reg op_ready;
reg [7: 0] regFile [15: 0];
reg [7: 0] outputRegFile [3: 0];
reg [3: 0] i = 0;
reg [1: 0] m = 0;
wire input_ready;
wire [7: 0] negated;
wire [31: 0] reciproacled;
integer j;
wire [31:0] add_result, sub_result, mul_result, div_result;
reg [31:0] result;

parameter ADD_OP = 8'b11110000;
parameter SUB_OP = 8'b00001111;
parameter MUL_OP = 8'b00110011;
parameter DIV_OP = 8'b11001100;

always @(posedge en) begin
 	 regFile[i] <= data_in;
	 i = i == 8 ? 0 : i + 1;
end

initial begin
	outputRegFile[0] = 8'b11111111;
	outputRegFile[1] = 8'b11111111;
	outputRegFile[2] = 8'b11111111;
	outputRegFile[3] = 8'b11111111;
	regFile[0] = 8'b01010101;
	regFile[1] = 8'b10101010;
	regFile[2] = 8'b01010101;
	regFile[3] = 8'b10101010;
	regFile[4] = 8'b01010101;
	regFile[5] = 8'b10101010;
	regFile[6] = 8'b01010101;
	regFile[7] = 8'b10101010;
	regFile[8] = 8'b01010101;
	regFile[8] = 8'b10101010;
	regFile[9] = 8'b01010101;
	regFile[10] = 8'b10101010;
	regFile[11] = 8'b01010101;
	regFile[12] = 8'b10101010;
	regFile[13] = 8'b01010101;
	regFile[14] = 8'b10101010;
	regFile[15] = 8'b01010101;
end





//always @(posedge clk) begin
//   if (wr_en) begin
//		  if (~Tx_busy) begin
//				m <= m + 1;
//				bulbs <= outputRegFile[m];
//				toTx <= outputRegFile[m];
//		  end
//	  end
//end

always @(posedge wr_en) begin
   m <= m + 1;
//	bulbs <= outputRegFile[m];
	bulbs <= {6'b0, m};
	toTx <= outputRegFile[m];
end




assign input_ready = (i == 8);

fpu_sp_add fpu_sp_add_u(
        .clk(clk),
        .rst_n(rst),
        .din1({regFile[0], regFile[1], regFile[2], regFile[3]}),
        .din2({regFile[4], regFile[5], regFile[7], regFile[7]}),
        .dval(input_ready),
        .result(add_result),
        .rdy(add_ready)
      );

negate negate_u(
		  .in_val(regFile[4]),
		  .out_val(negated)
);


fpu_sp_add fpu_sp_sub(
    .clk(clk),
    .rst_n(rst),
    .din1({regFile[0], regFile[1], regFile[2], regFile[3]}),
    .din2({negated, regFile[5], regFile[6], regFile[7]}),
    .dval(input_ready),
    .result(sub_result),
    .rdy(sub_ready)
);



fpu_sp_mul fpu_mul_u(
    .clk(clk),
    .rst_n(rst),
    .din1({regFile[0], regFile[1], regFile[2], regFile[3]}),
    .din2({regFile[4], regFile[5], regFile[6], regFile[7]}),
    .dval(input_ready),
    .result(mul_result),
    .rdy(mul_ready)
);

reciprocal reciprocal_u(
	.fp_in({regFile[4], regFile[5], regFile[6], regFile[7]}),
	.fp_out(reciproacled)
);


fpu_sp_mul fpu_div(
    .clk(clk),
    .rst_n(rst),
    .din1({regFile[0], regFile[1], regFile[2], regFile[3]}),
    .din2(reciproacled),
    .dval(input_ready),
    .result(div_result),
    .rdy(div_ready)
);
		
		
always @(*) begin
    case (regFile[8])
        ADD_OP: begin
            result = add_result;
            op_ready = add_ready;
        end
        SUB_OP: begin
            result = sub_result;
            op_ready = sub_ready;
        end
        MUL_OP: begin
            result = mul_result;
            op_ready = mul_ready;
        end
        DIV_OP: begin
            result = div_result;
            op_ready = div_ready;
        end
        default: begin
            result = 32'b0; 
            op_ready = 1'b0;
        end
    endcase
end


always @(posedge clk) begin
    if (op_ready) begin
        outputRegFile[0] <= result[31:24];
        outputRegFile[1] <= result[23:16];
        outputRegFile[2] <= result[15:8];
        outputRegFile[3] <= result[7:0];
    end
end




endmodule
