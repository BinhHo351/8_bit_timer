task run_test();

  reg [7:0] data_in, data_out, address_tcr, address_tdr, address_tsr;
  time t_begin,t_end,t_f;

  begin
    #200;
    //en, cnt_up
    data_in = 8'b0001_0001;
    address_tcr = 8'h00;
    cpu.APB_WRITE(address_tcr,data_in);
    #20000;

    //write 200 to tdr
    data_in = 8'hc8;
    address_tdr = 8'h01;
    cpu.APB_WRITE(address_tdr,data_in);

    //load value
    data_in = 8'h80;
    address_tcr = 8'h00;
    cpu.APB_WRITE(address_tcr,data_in);

    //load = 0, en=1
    data_in = 8'b0001_0001; //bit 4: en, bit 0: T*4
    address_tcr = 8'h00;
    cpu.APB_WRITE(address_tcr,data_in);
    t_begin = $time;

    //polling
    address_tsr = 8'h02;
    data_out = 8'h00;
    while(data_out != 1) begin
      cpu.APB_READ(address_tsr,data_out);
    end
    t_end = $time;

    t_f = t_end - t_begin;
    $display("%d - %d = %d", t_end,t_begin,t_f);
   
    //compare with (256-value)*T*4, deviant 10*T
    if(22400 <= t_f <= 26400)
      cnt_err = cnt_err;
    else
      cnt_err = cnt_err + 1;
 
    #50000;
  end
endtask
