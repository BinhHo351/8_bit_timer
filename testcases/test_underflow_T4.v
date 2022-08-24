task run_test();

  reg [7:0] data_in;
  reg [7:0] data_out;
  reg [7:0] address_tcr;
  reg [7:0] address_tsr;
  
  begin
    #200;
    data_in = 8'b0011_0001;
    data_out = 8'h00;
    address_tcr = 8'h00;
    address_tsr = 8'h02;
    //en = 1
    cpu.APB_WRITE(address_tcr,data_in);
    
    //read s_ovf
    while(data_out != 1) begin
      cpu.APB_READ(8'h02,data_out);
      if(data_out == 8'h02)
        data_out = 8'h01;
    end
    #1000;
    //write 0 to clear s_ovf
    cpu.APB_WRITE(address_tsr,8'h00);
    #80000;
  end

endtask
