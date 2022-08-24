task run_test();

  reg [7:0] data_in;
  reg [7:0] data_out;
  reg [7:0] address;

  begin
    #200;
     data_in = 8'h01;
     address = 8'h04;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     data_in = 8'h02;
     address = 8'h05;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     data_in = 8'h03;
     address = 8'h06;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     data_in = 8'h04;
     address = 8'h07;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     data_in = 8'h05;
     address = 8'h08;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     data_in = 8'h06;
     address = 8'h09;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);
     
     data_in = 8'h07;
     address = 8'h0a;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     data_in = 8'h08;
     address = 8'h0b;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     data_in = 8'h09;
     address = 8'h0c;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);
     
     data_in = 8'h0a;
     address = 8'h0d;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     //pready=0, apb_wr_en=1
     force pready = 1'b0;
     force penable = 1'b1;
     force pwrite = 1'b1;
     #500;
     release pready;
     release penable;
     release pwrite;

     data_in = 8'h0b;
     address = 8'h0e;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);
     
     data_in = 8'hfa;
     address = 8'hfa;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     //pready=0, apb_rd_en=1;
     force pready = 1'b0;
     force penable = 1'b1;
     force pwrite = 1'b0;
     #500;
     release pready;
     release penable;
     release pwrite;

     data_in = 8'h0c;
     address = 8'h0f;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     
     data_in = 8'h0d;
     address = 8'hca;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     //psel=0, apb_rd_en=1
     force psel = 1'b0;
     force penable = 1'b1;
     #500;
     release psel;
     release penable;

     data_in = 8'hcb;
     address = 8'h0f;
     cpu.APB_WRITE(address,data_in);
     cpu.APB_READ(address,data_out);

     #1;
     if(data_out == 8'h00)
       cnt_err = cnt_err;
     else
       cnt_err = cnt_err + 1;
  end

endtask
