// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msb_is_0,     // Indicates MSB of operand A is 0
    output logic b_msw_is_0,     // Indicates MSW of operand B is 0
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
// ------------------
    logic [23:0]mult_result;
    logic [63:0]shifted_mult_result;
    logic [15:0]word_part;
    logic [7:0]byte_part;

    function logic [23:0] mult_word_by_byte(input logic [15:0] word_part, input logic [7:0] byte_part);
        return word_part * byte_part;
    endfunction

    function logic [63:0] shift_mult_out_left(input logic [23:0] num, input logic [2:0] shift_amount);
        return num << (shift_amount * 8);
    endfunction

    always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1 || clr_prod) begin
            product <= 0;
        end else if(upd_prod) begin
            product <= product + shifted_mult_result;
        end
    end

    always_comb begin
        // Get the parts of A and B that we currently want to calculate
        byte_part = a[8*a_sel+:8];
        word_part = b[16*b_sel+:16];
        // Multiply the parts
        mult_result = mult_word_by_byte(word_part, byte_part);
        // Shift the result
        shifted_mult_result = shift_mult_out_left(mult_result, shift_sel);

        // Check MSB/MSW zero
        a_msb_is_0 = a[31:24] == {8{1'b0}};
        b_msw_is_0 = b[31:16] == {16{1'b0}};
    end

// End of your code

endmodule
