module master(spi_if spi);

  
  slave dut (
    .mosi(spi.mosi),
    .miso(spi.miso),
    .sclk(spi.sclk),
    .cs(spi.cs)
  );

  
  initial begin
    spi.sclk = 0;
    spi.cs = 1;
  end

  
  initial begin
    forever begin
      wait (spi.cs == 0);
      #5;
      while (spi.cs == 0) begin
        spi.sclk = ~spi.sclk;
        #10;
      end
      spi.sclk = 0;
    end
  end

  
  bit [3:0] received_sum = 0;
  bit [7:0] data_to_send = 0;

  
  task spi_master(input bit [2:0] a, input bit [2:0] b, input opcode_u op);
    data_to_send = {op, a, b};
    $display("Data to send: %b", data_to_send);

    spi.cs = 0;

    
    for (int i = 0; i < 8; i++) begin
      @(posedge spi.sclk);
      spi.mosi = data_to_send[i];
      $display("Master: %b", spi.mosi);
    end

   
    @(posedge spi.sclk);
    for (int j = 0; j < 4; j++) begin
      @(negedge spi.sclk);
      received_sum[j] = spi.miso;
      $display("Received sum: %b", received_sum);
    end

    #5;
    spi.cs = 1;
  endtask

endmodule