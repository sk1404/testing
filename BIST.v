module LFSR ( input logic clk, rst, output logic [2:0] q);
 always_ff @(posedge clk or posedge rst)
 begin
 if (rst) q <= 3'b111; // Load seed value on reset
 else q <= {q[1], q[0], q[1] ^ q[2]}; // Shift register and apply feedback
 end
endmodule

module FullAdd (input logic a,b,c, output logic s,co);
 assign {co, s} = a + b + c;
endmodule

module SignatureAnalyser (input logic clk, rst, in, output logic [3:0] sign);
logic [3:0]q;
 always_ff @(posedge clk or posedge rst)
 begin
 if (rst) q <= 4'b0001; // Load seed value on reset
 else q <= {q[2], q[1], q[0], q[2] ^ in}; // Shift register and apply

 end
 assign sign=q;
endmodule


module BIST (input logic clk, input logic rst, output logic [3:0] signature);
logic [2:0] in;
logic sum,cout;
 LFSR lfsr1 ( clk,rst,in );
 FullAdd fa1 ( in[0],in[1],in[2],sum,cout);
 SignatureAnalyser sa1 ( clk,rst,sum,signature );
endmodule


module tb_BIST;
 // Testbench signals
 logic clk;
 logic rst;
 logic signature;
 // Instantiate the BIST module
 BIST uut (.clk(clk),.rst(rst),.signature(signature));
 // Clock generation
 always begin
 #5 clk = ~clk; // Toggle clock every 5 time units
 end
 // Test sequence
 initial begin

// Initialize signals

 clk = 0;
 rst = 0;
 // Apply reset
 rst = 1;
 #10;
 rst = 0;
 // Wait and observe the system
 #100;
 // Apply another reset
 rst = 1;
 #10;
 rst = 0;
 // Run for additional time to observe behavior
 #100;
 // Finish simulation
 $finish;
 end
 // Monitor signals
 initial begin
 $monitor("Time = %0t | rst = %b | sign = %b", $time, rst, signature);
 end
endmodule
