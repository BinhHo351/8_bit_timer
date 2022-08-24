module cpu_model(pclk,presetn,pwrite,psel,penable,paddr,pwdata,pready,pslverr,prdata);
  
  input wire pready,pclk,presetn,pslverr;
  input wire [7:0] prdata;
  output reg pwrite,psel,penable;
  output reg [7:0] paddr,pwdata;

  //APB_WITE  
  task APB_WRITE;
    input [7:0] address;
    input [7:0] data;

    begin
      $display("=============================================================");
      $display("At time %d, CPU is writing to address = %h, The value data = %h",$stime,address,data);
      //T1
      @(posedge pclk);
      #1;
      psel=1'b1;
      pwrite=1'b1;
      penable=1'b0;
      pwdata=data;
      paddr=address;
      
      //T2
      @(posedge pclk);
      #1;
      penable=1'b1;

      @(posedge pclk);
      while(pready != 1) @(posedge pclk); //check pready = 1 ? if it is 0, wait until it is 1
      
      //T3
      #1;
      psel=1'b0;
      pwrite=1'b0;
      penable=1'b0;
      pwdata=8'h00;
      paddr=8'h00;
      $display("At time %d, CPU wrote completely", $stime);
      $display("=============================================================");
      $display("\n");
    end
  endtask


  //APB_READ
  task APB_READ;
    input [7:0] address;
    output [7:0] data;
    begin 
      $display("=============================================================");
      $display("At the time %d, CPU is reading to address = %h, The value data = %h",$stime,address,data);
      //T1
      @(posedge pclk);
      #1;
      psel=1'b1;
      pwrite=1'b0;
      penable=1'b0;
      paddr=address;

      //T2
      @(posedge pclk);
      #1;
      penable=1'b1;

      @(posedge pclk);
      while(pready!=1) @(posedge pclk); //check pready = 1?if it is 0, wait until it is 1


      //T3
      #1;
      pwrite=1'b0;
      psel=1'b0;
      penable=1'b0;
      paddr=8'h00;
      data=prdata;
      $display("At time %d, CPU read completely", $stime);
      $display("=============================================================");
      $display("\n");
    end
  endtask
endmodule

