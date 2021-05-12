module ibex_simple_system_ctrl (
  input               clk_i,
  input               rst_ni,

  input               req_i,
  input               we_i,
  input        [ 3:0] be_i,
  input        [31:0] addr_i,
  input        [31:0] wdata_i,
  output logic        rvalid_o,
  output logic [31:0] rdata_o,
  output logic        err_o,

  output logic        debug_req_o
);

  localparam logic [7:0] CTRL_ADDR = 8'h0;
  localparam logic [7:0] ERR_ADDR  = 8'h1;

  logic [7:0] ctrl_addr;
  logic debug_req_d, debug_req_q;
  logic err_suppress_d, err_suppress_q;
  logic err_d;

  assign ctrl_addr = addr_i[9:2];

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      rvalid_o    <= 1'b0;
      debug_req_q <= 1'b0;
    end else begin
      rvalid_o       <= req_i;
      debug_req_q    <= debug_req_d;
      err_suppress_q <= err_suppress_d;
      err_o          <= err_d;
    end
  end

  always_comb begin
    debug_req_d = debug_req_q;
    err_suppress_d = err_suppress_q;
    err_d = 1'b0;

    if (req_i) begin
      case (ctrl_addr)
        CTRL_ADDR: begin
          if (we_i) begin
            debug_req_d    = wdata_i[0];
            err_suppress_d = wdata_i[1];
          end
        end
        ERR_ADDR: begin
          err_d = ~err_suppress_q;
        end
        default: ;
      endcase
    end
  end

  assign debug_req_o = debug_req_q;
  assign rdata_o = '0;

  logic [3:0] unused_be;
  logic [31:0] unused_wdata;
  logic [31:0] unused_addr;

  assign unused_be = be_i;
  assign unused_wdata = wdata_i;
  assign unused_addr = addr_i;
endmodule
