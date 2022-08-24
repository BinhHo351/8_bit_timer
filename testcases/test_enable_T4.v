task run_test();

  reg [7:0] data_in;
  reg [7:0] data_out;
  reg [7:0] address_tcr;
  reg [7:0] address_tsr;
  
  begin
    #200;
    //en = 1
    data_in = 8'b0001_0001; //bit 4: en, bit 0: T*4
    address_tcr = 8'h00;
    address_tsr = 8'h02;
    cpu.APB_WRITE(address_tcr,data_in);
    #40000;

    //en = 0
    cpu.APB_WRITE(address_tcr,8'b0000_0000);
    cpu.APB_READ(address_tcr,data_out);
    #2000;

    //en = 1;
    cpu.APB_WRITE(address_tcr,data_in);
    #30000;

  end

endtask
