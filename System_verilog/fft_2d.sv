module FFT_2D(clk,valid,inp_2d,out_2d,data_tlast);
//module FFT_2D(clk,inp_2d,out_2d,data_tlast,temp_out,temp_in,clk_idx,m_axis_data_tlast,flag);

parameter n_point = 8;

input [63:0]inp_2d[0:n_point-1][0:n_point-1];
input clk,valid;

output reg  [63:0]out_2d[0:n_point-1][0:n_point-1];
output reg data_tlast;

reg [63:0]out_temp[0:n_point-1][0:n_point-1];
//output reg [63:0]temp_in[0:n_point-1];
reg [63:0]temp_in[0:n_point-1];
//output [63:0]temp_out[0:n_point-1]; // change to wire
wire [63:0]temp_out[0:n_point-1];
//output m_axis_data_tlast;
wire  m_axis_data_tlast;

//output reg clk_idx=0;
reg clk_idx = 0;
integer j=0,k=0,last=10,iter;
//output reg [5:0] flag = 0;
reg [5:0] flag = 0;

FFT_1D itterator(.clk(clk),.clk_idx(clk_idx),.inp(temp_in),.out(temp_out),.m_axis_data_tlast(m_axis_data_tlast));


always @(posedge clk)
begin

    if(flag==1 && valid == 0)
    begin
        for(iter = 0 ; iter < n_point ; iter=iter + 1)
        begin
            temp_in[iter]=out_temp[iter][k];
        end
        if(clk_idx==0)
        begin
            clk_idx = 1;
        end
        if(m_axis_data_tlast==1)
        begin
            last=1;
        end
        if(m_axis_data_tlast==0 && last==1)
        begin
            for(iter=0 ; iter < n_point ; iter=iter + 1)
            begin
                out_2d[iter][k]=temp_out[iter];
            end
            k = k + 1;
            clk_idx = 0;
            last=0;
        end
        if(k==9)
        begin
            flag = 2;
            clk_idx = 0;
            data_tlast=1;
        end        
    end
    
    if(flag==0 && valid == 0)
    begin
        for(iter=0; iter < n_point ; iter=iter + 1)
        begin
            temp_in[iter]=inp_2d[j-2][iter];
        end
        if(clk_idx==0)
        begin
            clk_idx=1;
        end
        if(m_axis_data_tlast==1)
        begin
            last=1;
        end
        if(m_axis_data_tlast==0 && last==1)
        begin
            for(iter=0;iter<n_point;iter=iter + 1)
            begin
                out_temp[j-2][iter]=temp_out[iter];
            end
            j=j+1;
            clk_idx = 0;
            last=0;
        end
        if(j==10)
        begin
            clk_idx = 0;
            flag=1;
        end        
    end

   
end


endmodule