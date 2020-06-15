// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
// ------------------

    logic mult_result;
    logic shifted_mult_result;
    logic word_part, byte_part;

    function logic [23:0] mult_word_by_byte(input logic [15:0] word_part, input [7:0] byte_part)
        return word_part * byte_part;
    endfunction

    function logic [63:0] shift_mult_out_left(input logic [23:0] num, input [2:0] shift_amount)
        return num << shift_amount*8;
    endfunction

    always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1 || clr_prod) begin
            product <= {64{1'b0}};
        end else if(upd_prod) begin
            product <= shifted_mult_result;
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
    end

// End of your code

endmodule
