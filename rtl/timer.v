module timer (clk,pclk,presetn,load,en,up_down,cks,reg_tdr,ovf,udf);

  input wire [3:0] clk;
  input wire pclk, presetn, en, load, up_down;
  input wire [7:0] reg_tdr;
  input wire [1:0] cks;

  //output wire ovf, udf;
  output wire ovf;
  output wire udf;

  //internal signals
  reg clk_in;
  reg clk_dly;  //rising edge detection
  wire clk_out;  //rising edge detection
  reg [7:0] cnt; //counter
  reg udf_t = 1'b0;  

  //select clock
  always @(clk or cks) begin
    case(cks)
      2'b00: clk_in = clk[0];
      2'b01: clk_in = clk[1];
      2'b10: clk_in = clk[2];
      2'b11: clk_in = clk[3];
    endcase
  end

  //rising edge detection
  always @(posedge pclk) begin
    clk_dly <= clk_in;
  end
  assign clk_out = (~clk_dly) & clk_in;
  
  //counter
  always @(posedge pclk) begin
    if(!presetn) cnt <= 8'h00;
    else begin //preset_n = 1'b1;
      if(load) begin 
        cnt <= reg_tdr;
	udf_t <= 1'b1;
      end
      else if(!en) //en=1'b0, load = 1'b0;
           cnt <= cnt;
      else if(!clk_out) //en=1'b1, clk_out=1'b0;
	   cnt <= cnt;
	   else if(up_down) //clk_out = 1'b1, up_dw=1'b1;
		  cnt <= cnt - 1'b1; //cnt_dw
		else
		  cnt <= cnt + 1'b1;  //cnt_up
    end
  end

  //overflow
  assign ovf = (clk_out == 1'b1) & (cnt == 8'hff) & (!up_down);

  //underflow
  always @(posedge up_down) begin
    if(!udf_t)
      cnt <= 8'hff;
    else begin
      cnt <= cnt;
      udf_t <= 1'b0;
    end
  end

  assign udf = (clk_out == 1'b1) & (cnt == 8'h00) & (up_down);


endmodule
