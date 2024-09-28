module external(
//              input wire [7:0] data_in,
				input wire wr_en,
//				input wire clear,
				input wire clk_50m,
				output wire Tx,
				output wire Tx_busy,
				input wire Rx,
				input wire rst,
				output wire [7: 0] bulbs
//				input wire enable
//				input wire send_byte,
				);		


wire Txclk_en, Rxclk_en;
wire [7:0] data, toTx;
wire ready;
wire need_byte;


baudrate uart_baud(	.clk_50m(clk_50m),
					.Rxclk_en(Rxclk_en),
					.Txclk_en(Txclk_en)
					);
							
receiver uart_Rx (  .Rx(Rx),
			        .ready(ready),
//				    .ready_clr(need_byte),
					.clk_50m(clk_50m),
					.clken(Rxclk_en), 
					.data_out(data)
					);
			
In_Buff In_Buff_u(.data_in(data),
                  .clk(clk_50m),
                  .rst(rst),
                  .en(ready),
//                  .need_byte(need_byte),
                  .toTx(toTx),
                  .bulbs(bulbs),
                  .wr_en(wr_en),
						.Tx_busy(Tx_busy)
                  );

transmitter uart_Tx(.data_in(toTx),
					.wr_en(wr_en),
					.clk_50m(clk_50m),
					.clken(Txclk_en), 
					.Tx(Tx),
					.Tx_busy(Tx_busy)
					);            
                            
endmodule
