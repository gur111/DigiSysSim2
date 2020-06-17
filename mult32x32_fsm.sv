// 32X32 Multiplier FSM
module mult32x32_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

// Put your code here
// ------------------
    typedef enum {IDLE, CLEAR, Q1, Q2, Q3, Q4, Q5, Q6, Q7} State;
    State curr_state = IDLE, next_state = IDLE;

    function void calculate_fsm_out;
        busy = curr_state != IDLE;
        if (reset == 1'b1) begin
            upd_prod = 1'b0;
            return;
        end
        
        // Default values
        clr_prod = 1'b0;
        upd_prod = 1'b1;

        unique case (curr_state)
            IDLE: begin
                if (start == 1'b1) begin
                    upd_prod = 1'b0;
                    clr_prod = 1'b1;
                    next_state = CLEAR;
                end else begin
                    upd_prod = 1'b0;
                    next_state = IDLE;
                end
            end
            CLEAR: begin
                a_sel = 2'b00;
                b_sel = 1'b0;
                shift_sel = 3'b000;
                next_state = Q1;
            end
            Q1: begin
                a_sel = 2'b01;
                b_sel = 1'b0;
                shift_sel = 3'b001;
                next_state = Q2;
            end
            Q2: begin
                a_sel = 2'b10;
                b_sel = 1'b0;
                shift_sel = 3'b010;
                next_state = Q3;
            end
            Q3: begin
                a_sel = 2'b11;
                b_sel = 1'b0;
                shift_sel = 3'b011;
                next_state = Q4;
            end
            Q4: begin
                a_sel = 2'b00;
                b_sel = 1'b1;
                shift_sel = 3'b010;
                next_state = Q5;
            end
            Q5: begin
                a_sel = 2'b01;
                b_sel = 1'b1;
                shift_sel = 3'b011;
                next_state = Q6;
            end
            Q6: begin
                a_sel = 2'b10;
                b_sel = 1'b1;
                shift_sel = 3'b100;
                next_state = Q7;
            end
            Q7: begin
                a_sel = 2'b11;
                b_sel = 1'b1;
                shift_sel = 3'b101;
                next_state = IDLE;
            end
        endcase
    endfunction

    always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin
            curr_state <= IDLE;
        end else begin
            curr_state <= next_state;
        end
    end

    always_comb calculate_fsm_out;
// End of your code

endmodule
