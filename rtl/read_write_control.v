module read_write_control (pclk,
                           presetn,
			   pwrite,
			   psel,
			   penable,
			   paddr,
			   pwdata,
			   prdata,
			   pready,
			   pslverr,
			   load,
			   en,
			   up_down,
			   cks,
			   reg_tdr,
			   ovf,
			   udf
			  );

  //Inputs, Outputs
  input wire pclk,presetn,pwrite,psel,penable;
  input wire [7:0] paddr,pwdata;
  output wire pready,pslverr;
  output reg [7:0] prdata;
  
  //signals connect
  input wire ovf, udf;
  output wire load, en, up_down;
  output reg [7:0] reg_tdr;
  output wire [1:0] cks;

  //Internal Signals
  reg [7:0] reg_tcr;
  reg [2:0] psel_reg;
  wire apb_wr_en;
  wire apb_rd_en;
  reg s_ovf, s_udf;

  //connect registers to pins
  //TCR_REGISTER
  assign load = reg_tcr[7];
  assign up_down = reg_tcr[5];
  assign en = reg_tcr[4];
  assign cks = reg_tcr[1:0];
 
  //pready & pslverr
  assign pready = 1'b1;
  assign pslverr = 1'b0;

  //Control Logic Block
  assign apb_wr_en = pwrite & penable & pready;  //decoder
  assign apb_rd_en = (~pwrite) & penable & pready;  //encoder

  //Decode Block 
  always @(paddr or psel or psel_reg)
  begin
  if(psel==0)
    psel_reg = 3'b000;
  else
    case(paddr[1:0])
      2'b00: psel_reg = 3'b001;
      2'b01: psel_reg = 3'b010;
      2'b10: psel_reg = 3'b100;
      default: psel_reg = 3'b000;
    endcase
  end

  //Encode Block
  always @(paddr or psel or apb_rd_en)
  begin
  if(!(psel && apb_rd_en))
    prdata = 8'b0000_0000;
  else
    case(paddr[1:0])
      2'b00: prdata = reg_tcr;
      2'b01: prdata = reg_tdr;
      2'b10: prdata = {6'h0,s_udf,s_ovf};
      default: prdata = 8'b0000_0000;
    endcase
  end


  //Register
  //TCR_REGISTER
  always @(posedge pclk or negedge presetn)
  begin
    if(presetn==0)
      reg_tcr <= 8'h00;
    else if(psel_reg[0] && apb_wr_en)
      reg_tcr <= {pwdata[7],1'b0,pwdata[5:4],2'b00,pwdata[1:0]};
    else
      reg_tcr <= reg_tcr;
  end

  //TDR_REGISTER
  always @(posedge pclk or negedge presetn)
  begin
    if(presetn==0)
      reg_tdr <= 8'h00;
    else if(psel_reg[1] && apb_wr_en)
      reg_tdr <= pwdata;
    else
      reg_tdr <= reg_tdr;
  end

  //TSR_REGISTER
  //tsr_reg[0] == s_ovf 
  always @(posedge pclk or negedge presetn)
  begin
    if(presetn==0)
      s_ovf <= 1'b0;
    else if(ovf)
           s_ovf <= 1'b1;
    else if(psel_reg[2] && apb_wr_en) begin
      if(pwdata[0] == 0)
        s_ovf <= 1'b0;
      else
        s_ovf <= s_ovf;
    end
  end

  //tsr_reg[1] == s_udf 
  always @(posedge pclk or negedge presetn)
  begin
    if(presetn==0)
      s_udf <= 1'b0;
    else if(udf)
           s_udf <= 1'b1;
    else if(psel_reg[2] && apb_wr_en) begin
      if(pwdata[0] == 0)
        s_udf <= 1'b0;
      else
        s_udf <= s_udf;
    end
  end


endmodule  
