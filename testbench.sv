`include "master.sv"
`include "interface.sv"

module tb;
  spi_if spi();  

  master master(.spi(spi));   

  initial begin
    #20;
    master.spi_master(3'b111, 3'b010, ADD);

    #20;
    master.spi_master(3'b111, 3'b110, SUB);

    #20;
    master.spi_master(3'b111, 3'b110, INV);
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1000;
    $finish;
  end
endmodule



































