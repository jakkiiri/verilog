module vending_machine_tb;

    // Inputs
    reg clk;
    reg [1:0] in;
    reg rst;

    // Outputs
    wire out;
    wire [1:0] change;

    // Instantiate the Unit Under Test (UUT)
    vending_machine_18105070 uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out),
        .change(change)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        $dumpfile("vending_machine_18105070.vcd");
        $dumpvars(0, vending_machine_tb);
        
        clk = 0;
        rst = 1;
        in = 0;

        // Apply Reset
        #10 rst = 0;

        // Test Input Scenarios
        #10 in = 2'b01; // Add $5
        #10 in = 2'b10; // Add $10
        #10 in = 2'b00; // No input, check outputs

        // Reset and Test Overpayment
        #20 rst = 1;    // Reset
        #10 rst = 0;
        #10 in = 2'b10; // Add $10
        #10 in = 2'b10; // Add $10 (overpayment)
        #10 in = 2'b00; // No input, check outputs

        // End Simulation
        #50 $finish;
    end

endmodule
