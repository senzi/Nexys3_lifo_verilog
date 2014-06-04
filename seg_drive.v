module seg_drive(
  input         i_clk,
  input         i_rst,
  input  [3:0]  i_turn_off,       
  input  [3:0]  i_dp,                 
  input  [15:0] i_data,                 
  output [7:0]  o_seg,                  
  output [3:0]  o_sel                   
);

reg [10:0] cnt;                         

always @ (posedge i_clk or posedge i_rst)
  if (i_rst)  cnt <= 0;
  else cnt <= cnt + 1'b1;

wire seg7_clk = cnt[10];                


reg [2:0]  seg7_addr;                

always @ (posedge seg7_clk or posedge i_rst)
  if (i_rst)        seg7_addr <= 0;
  else seg7_addr <= seg7_addr + 1'b1;      

reg [3:0] o_sel_r;                     
always @ (seg7_addr)
	begin
        o_sel_r = 4'b1111;
  case (seg7_addr)
    0 : o_sel_r = 4'b1110;               
    1 : o_sel_r = 4'b1101;               
    2 : o_sel_r = 4'b1011;               
    3 : o_sel_r = 4'b0111;
  endcase
  end

reg turn_off_r;                      

always @ (seg7_addr or i_turn_off)
begin
        turn_off_r = 1'b0;
  case (seg7_addr)
    0 : turn_off_r = i_turn_off[0];
    1 : turn_off_r = i_turn_off[1];
    2 : turn_off_r = i_turn_off[2];
    3 : turn_off_r = i_turn_off[3];
  endcase
end

reg dp_r;                        
always @ (seg7_addr or i_dp)
  begin
        dp_r = 1'b0;
  case (seg7_addr)
    0 : dp_r = i_dp[0];
    1 : dp_r = i_dp[1];
    2 : dp_r = i_dp[2];
    3 : dp_r = i_dp[3];
  endcase
  end

reg [3:0] seg_data_r;                   

always @ (seg7_addr or i_data)
  begin
        seg_data_r = 4'b0000;
  case (seg7_addr)
    0 : seg_data_r = i_data[3:0];
    1 : seg_data_r = i_data[7:4];
    2 : seg_data_r = i_data[11:8];
    3 : seg_data_r = i_data[15:12];
  endcase
  end

reg [7:0] o_seg_r;                   


always @ (posedge i_clk or posedge i_rst)
  if (i_rst)
    o_seg_r <= 8'hFF;                 
  else
    if(turn_off_r)                   
      o_seg_r <= 8'hFF;
    else
      if(!dp_r)
      begin
        case(seg_data_r)              
          4'h0 : o_seg_r <= 8'hC0;
          4'h1 : o_seg_r <= 8'hF9;
          4'h2 : o_seg_r <= 8'hA4;
          4'h3 : o_seg_r <= 8'hB0;
          4'h4 : o_seg_r <= 8'h99;
          4'h5 : o_seg_r <= 8'h92;
          4'h6 : o_seg_r <= 8'h82;
          4'h7 : o_seg_r <= 8'hF8;
          4'h8 : o_seg_r <= 8'h80;
          4'h9 : o_seg_r <= 8'h90;
          4'hA : o_seg_r <= 8'hFE;
          4'hB : o_seg_r <= 8'hFD;
          4'hC : o_seg_r <= 8'hFB;
          4'hD : o_seg_r <= 8'hF7;
          4'hE : o_seg_r <= 8'hEF;
          4'hF : o_seg_r <= 8'hDF;
        endcase
      end
      else
      begin
        case(seg_data_r)            
          4'h0 : o_seg_r <= 8'hC0 ^ 8'h80;
          4'h1 : o_seg_r <= 8'hF9 ^ 8'h80;
          4'h2 : o_seg_r <= 8'hA4 ^ 8'h80;
          4'h3 : o_seg_r <= 8'hB0 ^ 8'h80;
          4'h4 : o_seg_r <= 8'h99 ^ 8'h80;
          4'h5 : o_seg_r <= 8'h92 ^ 8'h80;
          4'h6 : o_seg_r <= 8'h82 ^ 8'h80;
          4'h7 : o_seg_r <= 8'hF8 ^ 8'h80;
          4'h8 : o_seg_r <= 8'h80 ^ 8'h80;
          4'h9 : o_seg_r <= 8'h90 ^ 8'h80;
          4'hA : o_seg_r <= 8'hFE ^ 8'h80;
          4'hB : o_seg_r <= 8'hFD ^ 8'h80;
          4'hC : o_seg_r <= 8'hFB ^ 8'h80;
          4'hD : o_seg_r <= 8'hF7 ^ 8'h80;
          4'hE : o_seg_r <= 8'hEF ^ 8'h80;
          4'hF : o_seg_r <= 8'hDF ^ 8'h80;
        endcase
      end
assign o_sel = o_sel_r;                 
assign o_seg = o_seg_r;              

endmodule
