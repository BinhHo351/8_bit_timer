module system_signals(pclk,presetn,clk);
  output reg pclk,presetn;
  output reg [3:0] clk;
  //creat clock
  initial begin
    pclk = 0;
    forever #50 pclk=~pclk;
  end


  //select clock
  //T*2
  initial begin
    clk = 0;
    forever #100 clk[0] = ~clk[0];
  end

  //T*4
  initial begin
    clk = 0;
    forever #200 clk[1] = ~clk[1];
  end

  //T*8
  initial begin
    clk = 0;
    forever #400 clk[2] = ~clk[2];
  end

  //T*16
  initial begin
    clk = 0;
    forever #800 clk[3] = ~clk[3];
  end

  //creat reset
  initial begin
    presetn = 1'b1;
    #50;
    presetn = 1'b0;
    #50;
    presetn = 1'b1;
  end

endmodule
    
