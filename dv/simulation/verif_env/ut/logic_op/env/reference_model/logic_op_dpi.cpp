// logic_op_dpi.cpp -- Verilator-compatible C++ build of the DPI-C reference model.
//
// The original logic_op_dpi.c uses `extern "C"` (a C++ construct) so it only
// compiles as C++. Verilator dispatches on file extension, therefore a .cpp
// copy is provided here so the same implementation links under Verilator.
//
// SV side (logic_op_reference_model.svh):
//   import "DPI-C" function void logic_op_dpi(input int data1,
//                                             input int data2,
//                                             input int sel,
//                                             output int data);
#include <svdpi.h>

extern "C" void logic_op_dpi(int data1, int data2, int sel, int *data) {

  if(sel==0)
    *data = data1 & data2;
  else if(sel==1)
    *data = data1 | data2;
  else if(sel==2)
    *data = data1 ^~ data2;
  else if(sel==3)
    *data = data1 ^ data2;
}
