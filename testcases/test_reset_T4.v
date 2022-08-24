task run_test();

  reg [7:0] data_in, data_out, address_tcr, address_tdr, address_tsr;
  reg [7:0] data_load, data_en, address;
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
    data_en = 8'b0001_0001;//bit 4: en, bit 0: T*4
    cpu.APB_WRITE(address_tcr,data_en);
    #10000;
    force presetn = 1'b0;
    #200;
    release presetn;
    #100000;

  end
endtask

