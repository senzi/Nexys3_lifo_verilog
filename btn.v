module btn_xd(i_clk, i_btn, o_btn);
parameter [18:0] N = 19'b1111010000100100000;
input            i_clk;
input            i_btn;
output           o_btn;
reg              o_btn;
reg [18:0]       count;
always @(posedge i_clk)
begin
    if (i_btn == 1'b1) begin
        if (count==N)   count<=count;else count<=count+19'b0000000000000000001;
        if (count==N-1) o_btn<=1'b1; else o_btn<=1'b0; end
    else count <= 19'b0000000000000000000;
end
endmodule
