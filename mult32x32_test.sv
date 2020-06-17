// 32X32 Multiplier test template
module mult32x32_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

// Put your code here
// ------------------
    parameter clk_interval = 5;
    const int clk_cycle = clk_interval*2;
    int last = 0;
   
    initial begin
        clk = 1;

        forever begin
            // Inverse clock value every half an interval
            #clk_interval;
            clk = ~clk;
        end
    end

    initial begin
        reset = 1'b1;
        #clk_cycle;
        #clk_cycle;
        #clk_cycle;
        #clk_cycle;

        start = 1'b0;
        reset = 1'b0;
        a = 206631848;
        b = 316086461;

        #clk_cycle;
        start = 1'b1;
        last = $time;
        @(busy);
        start = 1'b0;
        $display("Busy changed to %0d after %0t", busy, ($time)-last);
        last = $time;
        @(!busy);
        $display("Busy changed to %0d after %0t", busy, ($time)-last);
        $display("Result is %0d", product);

        #clk_cycle;
        #clk_cycle;
    end


     mult32x32 multiplier (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .busy(busy),
        .product(product)
    );
    
// End of your code

endmodule