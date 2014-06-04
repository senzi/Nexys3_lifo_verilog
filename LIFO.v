module LIFO (
            input  wire       clk,        
            input  wire       rst_n,      
            input  wire [5:0] data_in,    
            input  wire       write,      
            input  wire       read,       
            output reg  [5:0] data_out,   
            output wire       empty_flag, 
            output wire       full_flag,   
            output wire       loading_flag       
            );
parameter do_nothing = 2'b00,                                   
          only_read  = 2'b10,                                   
          only_write = 2'b01,                                
          both_r_w   = 2'b11;                                   

reg [5:0] LIFO_MEM [3:0];      
reg [2:0] stack_point;                
reg [2:0] i;                           
reg [1:0] CS;                                            
reg [1:0] NS;                                           

always @ (*) begin                                       
  if (rst_n) CS=do_nothing; else
  begin
    CS = {read,write};                                   
    case (CS)                                            
    	only_read : 
      	begin                                    
      		if (empty_flag) NS=do_nothing;
      		else            NS=only_read ; 
      	end
      	only_write :
      	begin                                    
           	if (full_flag)  NS=do_nothing;
            else            NS=only_write;
        end
      	both_r_w : 
      	begin                                    
            if (empty_flag) NS=only_write;
            else if (full_flag) NS=only_read ;
            else NS=do_nothing;
        end
      	default : 
      	begin NS=do_nothing;
        end
    endcase
  end
end

always @ (posedge clk) begin                             
  if (rst_n)                                            
  begin
    stack_point <= 3'b0;
    data_out    <= 6'b0;
    for (i=0;i<4;i=i+1'b1)
      LIFO_MEM[i]<=6'b0;
  end
  else
    case (NS)                                            
      	only_read : 
      	begin
            stack_point<=stack_point-1'b1;
            data_out<=LIFO_MEM[stack_point-1'b1];      
        end
      	only_write : 
      	begin
            stack_point<=stack_point+1'b1;
            LIFO_MEM[stack_point]<=data_in;
        end
      	default : 
      	begin
            stack_point<=stack_point;
            data_out<=data_out;
            LIFO_MEM[stack_point]<=LIFO_MEM[stack_point];
        end
    endcase
end
assign empty_flag   = (|stack_point)?1'b0:1'b1;        
assign full_flag    = ((!stack_point[2])|(|stack_point[1:0]))?1'b0:1'b1;
assign loading_flag = (empty_flag==1'b1)?(1'b0):((full_flag==1'b1)?(1'b0):(1'b1));  
endmodule
