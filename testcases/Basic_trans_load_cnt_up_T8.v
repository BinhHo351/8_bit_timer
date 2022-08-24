task run_test();

  reg [7:0] data_in;
  reg [7:0] data_load;
  reg [7:0] data_en;
  reg [7:0] data_out;
  reg [7:0] address_tdr;
  reg [7:0] address_tcr;
  reg [7:0] address_tsr;
  time t_begin,t_end,t_f;

  begin
    #200;
    //write value to TDR_REG
    data_in = 8'h0a;
    address_tdr = 8'h01;
    cpu.APB_WRITE(address_tdr,data_in);

    //Load value
    address_tcr = 8'h00;
    data_load = 8'h80;//bit 7
    cpu.APB_WRITE(address_tcr,data_load);

    //en,cnt_up
    address_tcr = 8'h00;
    data_en = 8'b0001_0010;//bit 4: en, bit 1: T*8
    cpu.APB_WRITE(address_tcr,data_en);
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
   
    //compare with (256-value)*T*8, deviant 10*T
    if(196800 <= t_f <= 204800)
      cnt_err = cnt_err;
    else
      cnt_err = cnt_err + 1;
    #80000;
end

endtask
