typedef enum bit [1:0] {ADD, SUB, INV, RED} opcode_u;

module slave(
  input logic mosi,
  output logic miso,
  input logic sclk,
  input logic cs
);


  bit [3:0] sum;
  logic [7:0] data = 0;
  opcode_u op;
  bit [2:0] a, b;


  task add(input bit [2:0] a, input bit [2:0] b, input opcode_u op);
    case (op)
      ADD: sum = a + b;
      SUB: sum = a - b;
      INV: sum = ~a & 4'b0111;
      RED: sum = |b;
      default: sum = '0;
    endcase
  endtask

  
  always @(cs) begin
    sum = 0;
    op = opcode_u'(0);
    a = 0;
    b = 0;
  end

 
  always @(!cs) begin
   
    for (int k = 0; k < 8; k++) begin
      @(negedge sclk);
      data[k] = mosi;
      $display("Slave: %b", data);
    end


    op = opcode_u'(data[7:6]);
    a = data[5:3];
    b = data[2:0];

    $display("op: %b", op);
    $display("a: %b", a);
    $display("b: %b", b);

  
    add(a, b, op);
    $display("sum: %b", sum);

  
    for (int i = 0; i < 4; i++) begin
      @(posedge sclk);
      miso = sum[i];
      $display("Slave transfer: %b", miso);
    end
  end

endmodule
