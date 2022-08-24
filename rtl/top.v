module top(clk,pclk,presetn,psel,pwrite,penable,paddr,pwdata,prdata,pready,pslverr);
  
  input wire [3:0] clk;
  input wire pclk, presetn,psel,pwrite,penable;
  input wire [7:0] paddr, pwdata;
  output wire [7:0] prdata;
  output wire pready, pslverr;

  wire load, en, up_down, ovf, udf;
  wire [7:0] reg_tdr;
  wire [1:0] cks;

  read_write_control rw_ctrl (
                              .pclk(pclk),
			      .presetn(presetn),
			      .psel(psel),
			      .pwrite(pwrite),
			      .penable(penable),
			      .paddr(paddr),
			      .pwdata(pwdata),
			      .prdata(prdata),
			      .pready(pready),
			      .pslverr(pslverr),
			      .load(load),
			      .en(en),
			      .up_down(up_down),
			      .cks(cks),
			      .reg_tdr(reg_tdr),
			      .ovf(ovf),
			      .udf(udf)
			     );

  timer tmr (.clk(clk),
             .pclk(pclk), 
             .presetn(presetn),
             .load(load),
             .en(en),
	     .up_down(up_down),
	     .cks(cks),
	     .reg_tdr(reg_tdr),
	     .ovf(ovf),
	     .udf(udf)
	   );

endmodule
