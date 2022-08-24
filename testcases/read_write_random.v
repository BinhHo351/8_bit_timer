task run_test();

  reg [7:0] data_in;
  reg [7:0] data_out;
  reg [7:0] address_tcr, address_tdr, address_tsr, address_df;

  begin
    #200;
    repeat(100) begin
      //write tcr_reg
      data_in = $random();
      address_tcr = 8'h00;
      cpu.APB_WRITE(address_tcr,data_in); 

      //write tdr_reg, read tcr_reg
      data_in = $random();
      address_tdr = 8'h01;
      cpu.APB_WRITE(address_tdr,data_in);
      cpu.APB_READ(address_tcr,data_out);

      //write tsr_reg, read tdr_reg
      data_in = $random();
      address_tsr = 8'h02;
      cpu.APB_WRITE(address_tsr,data_in);
      cpu.APB_READ(address_tdr,data_out);

      //write tcr_reg, read tsr_reg
      data_in = $random();
      address_tcr = 8'h01;
      cpu.APB_WRITE(address_tcr,data_in);
      cpu.APB_READ(address_tsr,data_out);
      
      //write tdr_reg. read_tcr_reg
      data_in = $random();
      address_tdr = 8'h01;
      cpu.APB_WRITE(address_tdr,data_in);
      cpu.APB_READ(address_tcr,data_out);

      #1;
      if(data_out == data_in)
        cnt_err = cnt_err;
      else
        cnt_err = cnt_err + 1;
    end
  end
 endtask
