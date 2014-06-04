module top(
    input clk,
    input rst_n,
    input [5 : 0] data_in,
    input write,
    input read,
    output empty_flag,
    output full_flag,
    output loading_flag,
    output [7:0] o_seg,
    output [3:0] o_sel
    );
wire xded_write;
btn_xd xd_write(
    .i_clk(clk),
    .i_btn(write),
    .o_btn(xded_write)
);
wire xded_read;
btn_xd xd_read(
    .i_clk(clk),
    .i_btn(read),
    .o_btn(xded_read)
);
wire [15:0] seg_data;
wire [5 :0] lifo_out;
LIFO LIFO_U0(
    .clk            (clk),
    .rst_n          (rst_n),
    .data_in        (data_in),
    .write          (xded_write),
    .read           (xded_read),
    .data_out       (lifo_out),
    .empty_flag     (empty_flag),
    .full_flag      (full_flag),
    .loading_flag   (loading_flag)
);
assign seg_data = {1'b0,data_in[5:3],1'b0,data_in[2:0],1'b0,lifo_out[5:3],1'b0,lifo_out[2:0]};
seg_drive seg_drive_u0(
  .i_clk            (clk),
  .i_rst            (rst_n),
  .i_turn_off       (4'b0000),
  .i_dp             (4'b0000),
  .i_data           (seg_data),
  .o_seg            (o_seg),
  .o_sel            (o_sel)
);
endmodule
