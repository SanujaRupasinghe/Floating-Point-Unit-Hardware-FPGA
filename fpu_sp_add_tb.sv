`timescale 1ns/1ps
 
module fpu_sp_add_tb;
    // Testbench signals
    reg clk;
    reg rst_n;
    reg [31:0] din1;
    reg [31:0] din2;
    reg dval;
    wire [31:0] result;
    wire rdy;
 
    // Instantiate the DUT (Device Under Test)

    fpu_sp_add uut (
        .clk(clk),
        .rst_n(rst_n),
        .din1(din1),
        .din2(din2),
        .dval(dval),
        .result(result),
        .rdy(rdy)
    );
 
    // Clock generation
    initial clk = 0;
    always #10 clk = ~clk; // 10ns clock period
 
    // Test tasks
    task reset;
		 begin
			  rst_n = 0;
			  din1 = 0;
			  din2 = 0;
			  dval = 0;
			  #20;
			  rst_n = 1;
		 end
    endtask
 
    task perform_test(input [31:0] a, input [31:0] b, input [31:0] expected);
		 begin
			  din1 = a;
			  din2 = b;
			  dval = 1;
			  #20;
			  dval = 0;
			  wait(rdy);
			  if (result !== expected) begin
					$display("Test failed: din1=%h, din2=%h, result=%h, expected=%h", a, b, result, expected);
			  end else begin
					$display("Test passed: din1=%h, din2=%h, result=%h", a, b, result);
			  end
					reset();
		 end
    endtask
 
    // Floating-point test cases
    localparam NAN        = 32'hFFC00000; // NaN
    localparam POS_INF    = 32'h7F800000; // +Infinity
    localparam NEG_INF    = 32'hFF800000; // -Infinity
    localparam POS_ZERO   = 32'h00000000; // +0.0
    localparam NEG_ZERO   = 32'h80000000; // -0.0
    localparam ONE        = 32'h3F800000; // +1.0
    localparam TWO        = 32'h40000000; // +2.0
    localparam MINUS_ONE  = 32'hBF800000; // -1.0
    localparam MINUS_TWO  = 32'hC0000000; // -2.0
 
    initial begin
        // Reset the DUT

        reset();
 
//        // Test NaN propagation

//        perform_test(NAN, ONE, NAN);

//        perform_test(ONE, NAN, NAN);
 
////        // Test infinity handling

        perform_test(POS_INF, ONE, POS_INF);
        perform_test(NEG_INF, ONE, NEG_INF);
        perform_test(POS_INF, NEG_INF, NAN);
 
////        // Test zero handling

        perform_test(POS_ZERO, ONE, ONE);
        perform_test(NEG_ZERO, ONE, ONE);
        perform_test(POS_ZERO, NEG_ZERO, POS_ZERO);
 
        // Test normal addition

        perform_test(ONE, ONE, TWO);
        perform_test(ONE, MINUS_ONE, POS_ZERO);
        perform_test(TWO, MINUS_ONE, ONE);
 
        // End simulation

        #100;
        $stop;

    end
 
endmodule

 
