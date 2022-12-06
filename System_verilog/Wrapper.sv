module Wrapper(clk);

parameter n_point = 8;
integer i,j;

input clk; 
reg [63:0]inp1[0:n_point-1][0:n_point-1];
wire [63:0]out1[0:n_point-1][0:n_point-1];
wire data_tlast;
reg valid = 0;
reg [1:0] tmp = 0;
integer i=0,j=0;
reg [5:0] addr=0;
reg [63:0] dina = 0;
wire [63:0] dout;


FFT_2D dut( .clk(clk),
            .valid(valid),
            .inp_2d(inp1),
            .out_2d(out1),
            .data_tlast(data_tlast)
          );

reg [63:0] out[0:n_point-1];


ila_0 instance_name (
	.clk(clk), // input wire clk


	.probe0(out[0]), // input wire [63:0]  probe0  
	.probe1(out[1]), // input wire [63:0]  probe1 
	.probe2(out[2]), // input wire [63:0]  probe2 
	.probe3(out[3]), // input wire [63:0]  probe3 
	.probe4(out[4]), // input wire [63:0]  probe4 
	.probe5(out[5]), // input wire [63:0]  probe5 
	.probe6(out[6]), // input wire [63:0]  probe6 
	.probe7(out[7])
);

integer p = 0;
integer q;


initial begin

for(i=0;i<n_point;i=i+1)
begin
    for(j=0;j<n_point;j=j+1)
    begin
      inp1[i][j]=64'b0000000000000000000000000000000001000000000000000000000000000000;
    end
end

end



always @(posedge clk) begin
    if(data_tlast == 1) begin
        for(q = 0; q < n_point; q = q + 1) begin
            out[q] = out1[q][p];
        end
        p = p + 1;
    end
end

endmodule




