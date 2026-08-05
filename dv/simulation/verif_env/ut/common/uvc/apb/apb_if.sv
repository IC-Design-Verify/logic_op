`ifndef APB_IF__SV
`define APB_IF__SV
interface apb_if(input PCLK,
                 input PRESETn);

  logic[31:0] PADDR;
  logic[31:0] PRDATA;
  logic[31:0] PWDATA;
  logic[15:0] PSEL; // Only connect the ones that are needed
  logic PENABLE;
  logic PWRITE;
  logic PREADY;

  parameter setup_time = 0.1ns;
  parameter hold_time = 0.1ns;

  clocking drv_cb @(posedge PCLK);
    default input #setup_time output #hold_time;
    output PSEL;
    output PENABLE;
    output PADDR;
    output PWRITE;
    output PWDATA;
    input  PRDATA;
    input  PREADY;
  endclocking: drv_cb

//  clocking mon_cb @(posedge PCLK);
//    default input #setup_time output #hold_time;
//    input  PSEL;
//    input  PENABLE;
//    input  PADDR;
//    input  PWRITE;
//    input  PWDATA;
//    input  PRDATA;
//    input  PREADY;
//  endclocking: mon_cb

  modport drv(clocking drv_cb);
//  modport mon(clocking mon_cb);
    
  property psel_valid;
    @(posedge PCLK)
    !$isunknown(PSEL);
  endproperty: psel_valid

  CHK_PSEL: assert property(psel_valid);

  COVER_PSEL: cover property(psel_valid);

endinterface: apb_if
`endif
