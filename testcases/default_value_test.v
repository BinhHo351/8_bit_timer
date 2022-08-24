task run_test();
  
  reg [7:0] data_out;
  reg [7:0] address;
  
  begin
    //read default value of register
    #200;
    repeat(200) begin
      address= $random();
      cpu.APB_READ(address,data_out);
      #1;
      if(data_out == 8'h00)
        cnt_err = cnt_err;
      else
        cnt_err = cnt_err + 1;
    end
  end
endtask
