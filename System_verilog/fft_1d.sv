
//module FFT_1D(clk,clk_idx,inp,out,m_axis_data_tvalid,m_axis_data_tdata,m_axis_data_tlast,s_axis_data_tdata,m_axis_data_tready,s_axis_data_tvalid,
//            s_axis_data_tready);

module FFT_1D(clk,clk_idx,inp,out,m_axis_data_tlast);

parameter n_point = 8;

input clk;
input clk_idx;


input [63:0]inp[0:n_point-1]; // Sending the entire fft related data as input. FFT module needs to handle the control signals of FFT ip.
output reg [63:0]out[0:n_point-1];  

reg aresetn;
    
reg [7:0] s_axis_config_tdata;
reg s_axis_config_tvalid;
wire s_axis_config_tready;


//output reg [63:0]s_axis_data_tdata;
reg [63:0]s_axis_data_tdata;
//output reg s_axis_data_tvalid;
reg s_axis_data_tvalid;
//output s_axis_data_tready;
wire s_axis_data_tready;
reg s_axis_data_tlast;

  

//output [63:0]m_axis_data_tdata;
wire [63:0]m_axis_data_tdata;
//output m_axis_data_tvalid;
wire m_axis_data_tvalid;
//output reg  m_axis_data_tready;
reg  m_axis_data_tready;
output  m_axis_data_tlast;

integer i ,data_idx,out_idx;



wire event_frame_started;
wire event_tlast_unexpected;
wire event_tlast_missing;
wire event_status_channel_halt;
wire event_data_in_channel_halt;
wire event_data_out_channel_halt;



xfft_0 your_instance_name (
  .aclk(clk),                                                // input wire aclk
  .aresetn(aresetn),                                          // input wire aresetn
  
  .s_axis_config_tdata(s_axis_config_tdata),                  // input wire [7 : 0] s_axis_config_tdata
  .s_axis_config_tvalid(s_axis_config_tvalid),                // input wire s_axis_config_tvalid
  .s_axis_config_tready(s_axis_config_tready),                // output wire s_axis_config_tready
  
  .s_axis_data_tdata(s_axis_data_tdata),                      // input wire [63 : 0] s_axis_data_tdata
  .s_axis_data_tvalid(s_axis_data_tvalid),                    // input wire s_axis_data_tvalid
  .s_axis_data_tready(s_axis_data_tready),                    // output wire s_axis_data_tready
  .s_axis_data_tlast(s_axis_data_tlast),                      // input wire s_axis_data_tlast
  
  .m_axis_data_tdata(m_axis_data_tdata),                      // output wire [63 : 0] m_axis_data_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid),                    // output wire m_axis_data_tvalid
  .m_axis_data_tready(m_axis_data_tready),                    // input wire m_axis_data_tready
  .m_axis_data_tlast(m_axis_data_tlast),                      // output wire m_axis_data_tlast
  
  .event_frame_started(event_frame_started),                  // output wire event_frame_started
  .event_tlast_unexpected(event_tlast_unexpected),            // output wire event_tlast_unexpected
  .event_tlast_missing(event_tlast_missing),                  // output wire event_tlast_missing
  .event_status_channel_halt(event_status_channel_halt),      // output wire event_status_channel_halt
  .event_data_in_channel_halt(event_data_in_channel_halt),    // output wire event_data_in_channel_halt
  .event_data_out_channel_halt(event_data_out_channel_halt)  // output wire event_data_out_channel_halt
);

always @(posedge clk) begin
    if(clk_idx == 0) begin
        i = 0;
    end
    else begin
    if(i >= 0 && i <= 4) begin
        aresetn = 0;
        i = i + 1;
        
        s_axis_data_tvalid = 0;
        s_axis_data_tdata = 0;
        s_axis_data_tlast = 0;
        
        
        m_axis_data_tready = 1; // Because of the Back Pressure concept. i.e, Master cannot accept inputs if slave is not not to take the outputs.
        
        s_axis_config_tdata = 1; // Actually config data is to enable fft ot ifft. if config_tdata == 1 => fft else = ifft.
        s_axis_data_tvalid = 0;  
        s_axis_config_tvalid = 1;
        data_idx = 0;
        out_idx = 0;
        s_axis_data_tdata = inp[data_idx];
        data_idx = 1;
    end
    else begin
        aresetn = 1;
        i = i + 1;
    end
    end
    
    
    
    if(m_axis_data_tvalid == 1) begin
       out[out_idx] = m_axis_data_tdata;
       out_idx = out_idx + 1;
    end
    if(m_axis_data_tlast == 1) begin
        m_axis_data_tready = 0;
    end
    
//    if(aresetn == 1) begin
//        s_axis_data_tvalid = 1;
        
//        while(s_axis_config_tready == 0) begin
//            s_axis_data_tvalid = 1;
//        end
//        if(s_axis_config_tready == 0) begin
//            s_axis_data_tvalid = 1;
//        end
//        else begin
//            s_axis_data_tvalid = 0;
//        end
//         s_axis_data_tvalid = 0;
//    end
    if(s_axis_data_tready == 1) begin
        s_axis_data_tvalid = 1;
    end
    if(s_axis_data_tvalid == 1) begin
        
        s_axis_data_tdata = inp[data_idx];
        if(data_idx == n_point - 1) begin
            s_axis_data_tlast = 1;
        end
        else begin
            s_axis_data_tlast = 0;
        end
        
        s_axis_data_tvalid = 1;
        
        data_idx = data_idx + 1;        
    end
    

end

endmodule
