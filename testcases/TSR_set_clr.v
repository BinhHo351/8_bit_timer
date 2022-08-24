task run_test();
  
  reg[7:0] data_out;
  reg[7:0] data_in;
  reg[7:0] address;

  begin
    #100;
    repeat(50) begin
      data_in = 8'h01;
      address = 8'h02;
      cpu.APB_WRITE(address,data_in);
      cpu.APB_READ(address,data_out);
      #1;
      if(data_out == 8'h01)
        cnt_err = cnt_err + 1;
      else
        cnt_err = cnt_err;
    end
  end
endtask
