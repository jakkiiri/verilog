module vending_machine_18105070(
    input clk,
    input rst,
    input [1:0] in, // 01 = 5 rs, 10 = 10 rs
    output reg out,
    output reg [1:0] change
);

    // Parameters for states
    parameter s0 = 2'b00; // $0
    parameter s1 = 2'b01; // $5
    parameter s2 = 2'b10; // $10

    reg [1:0] c_state, n_state;

    // State transition logic
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            c_state <= s0;
            out <= 0;
            change <= 2'b00;
        end else begin
            c_state <= n_state;
        end
    end

    // Next state and output logic
    always @ (*) begin
        // Default values
        n_state = c_state;
        out = 0;
        change = 2'b00;

        case (c_state)
            s0: begin // State $0
                if (in == 2'b01) begin
                    n_state = s1;
                end else if (in == 2'b10) begin
                    n_state = s2;
                end
            end

            s1: begin // State $5
                if (in == 2'b01) begin
                    n_state = s2;
                end else if (in == 2'b10) begin
                    n_state = s0;
                    out = 1; // Transaction complete
                end else if (in == 2'b00) begin
                    n_state = s0;
                    change = 2'b01; // Return $5
                end
            end

            s2: begin // State $10
                if (in == 2'b01) begin
                    n_state = s0;
                    out = 1; // Transaction complete
                end else if (in == 2'b10) begin
                    n_state = s0;
                    out = 1; // Transaction complete
                    change = 2'b01; // Return $5
                end else if (in == 2'b00) begin
                    n_state = s0;
                    change = 2'b10; // Return $10
                end
            end

            default: begin
                n_state = s0; // Default to initial state
            end
        endcase
    end
endmodule
