import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uart_inch.sv"
`include "UART_TX.v"

module UART_TB ();
  
`include "my_pkg.sv"

  UART_IF vif();

  bit i_Clock;
  wire y;


  UART_RX #(c_CLKS_PER_BIT) UART_RX_Inst
  (.i_Clock(vif.i_Clock),
   .i_RX_Serial(y),
     .o_RX_DV(vif.o_RX_DV),
     .o_RX_Byte(vif.o_RX_Byte)
     );
  
  UART_TX #(c_CLKS_PER_BIT) UART_TX_Inst
     (.i_Clock(vif.i_Clock),
     .i_TX_DV(vif.i_TX_DV),
    .i_TX_Byte(vif.i_TX_Byte),
     .o_TX_Active(vif.o_TX_Active),
      .o_TX_Serial(y),
     .o_TX_Done()
     );
  
  
   always begin
     #(c_CLOCK_PERIOD_NS/2) i_Clock = !i_Clock;
     
   end
  initial begin 
      
    uvm_config_db#(virtual UART_IF)::set(null,"*", "vif", vif);
    
    `uvm_info("top","uvm_config_db set for uvm_test_top",UVM_LOW);
 
    run_test("uart_base_test");
  end
 
   assign vif.i_Clock=i_Clock;
  
  
  initial  begin 
    $dumpfile("dump.vcd");
    $dumpvars(0, UART_TB);
  #2000ns;
  end
  
endmodule