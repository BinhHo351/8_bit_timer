task run_test();
  
  reg [7:0] data_in;
  reg [7:0] data_out;
  reg [7:0] address;
  
  begin
    #200;
    //write_read_TCR_reg
    repeat(50) begin
      data_in = $random();
      address = 8'h00;
      cpu.APB_WRITE(address,data_in);
      cpu.APB_READ(address,data_out);
    end

    //write_read_TDR_reg
    repeat(50) begin
      data_in = $random();
      address = 8'h01;
      cpu.APB_WRITE(address,data_in);
      cpu.APB_READ(address,data_out);
      #1;
      if(data_out == data_in)
        cnt_err = cnt_err;
      else 
        cnt_err = cnt_err + 1;
    end

    //write_read_TSR_reg
    repeat(50) begin
      data_in = $random();
      address = 8'h02;
      cpu.APB_WRITE(address,data_in);
      cpu.APB_READ(address,data_out);
    end

  end
endtask
