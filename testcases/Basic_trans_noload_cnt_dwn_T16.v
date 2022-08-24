task run_test();

  reg [7:0] data_in;
  reg [7:0] data_out;
  reg [7:0] address_tcr;
  reg [7:0] address_tsr;
  time t_begin,t_end,t_f;

  begin
    #200;
    data_in = 8'b0011_0011;
    address_tcr = 8'h00;
    address_tsr = 8'h02;
    data_out = 8'h00;
    cpu.APB_WRITE(address_tcr,data_in);
    t_begin = $time;
    
   //polling
    while(data_out != 1) begin
      cpu.APB_READ(8'h02,data_out);
      if(data_out == 8'h02)
        data_out = 8'h01;
    end

    t_end = $time;
    t_f = t_end - t_begin;
    $display("%d - %d = %d", t_end,t_begin,t_f);
   
    //compare with 256*16*T, deviant 10*T
    if(409600 <= t_f <= 425600)
      cnt_err = cnt_err;
    else
      cnt_err = cnt_err + 1;
    #80000;
  end

endtask
