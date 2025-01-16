`timescale 1ns / 1ps
// traffic light controller for a T intersection
// M1: Main Road dominant direction (away from the small road)
// MT: Main road dominant direction turning left into the smaller road
// M2: Main Road opposite direction (adjacent to the small road)
// M2: Includes turning right into the smaller road (right turn not controlled)
// S: Small road turning left into the main road (right turn not controlled)

////////////////////////////////////////////////


module traffic_light_controller(
    input clk, rst,
    output reg [2:0] light_M1,
    output reg [2:0] light_S,
    output reg [2:0] light_MT,
    output reg [2:0] light_M2
);

    // State parameters
    parameter S1 = 0, S2 = 1, S3 = 2, S4 = 3, S5 = 4, S6 = 5;
    reg [3:0] count; // Counter
    reg [2:0] ps;    // Present state
    parameter sec7 = 7, sec5 = 5, sec2 = 2, sec3 = 3;

    // Sequential block for state transitions and counter
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ps <= S1;
            count <= 0;
            // Initialize outputs to avoid undefined behavior
            light_M1 <= 3'b100; // Red
            light_M2 <= 3'b100; // Red
            light_MT <= 3'b100; // Red
            light_S <= 3'b100;  // Red
        end else begin
            case (ps)
                S1: if (count < sec7) begin
                        ps <= S1;
                        count <= count + 1;
                    end else begin
                        ps <= S2;
                        count <= 0;
                    end
                S2: if (count < sec2) begin
                        ps <= S2;
                        count <= count + 1;
                    end else begin
                        ps <= S3;
                        count <= 0;
                    end
                S3: if (count < sec5) begin
                        ps <= S3;
                        count <= count + 1;
                    end else begin
                        ps <= S4;
                        count <= 0;
                    end
                S4: if (count < sec2) begin
                        ps <= S4;
                        count <= count + 1;
                    end else begin
                        ps <= S5;
                        count <= 0;
                    end
                S5: if (count < sec3) begin
                        ps <= S5;
                        count <= count + 1;
                    end else begin
                        ps <= S6;
                        count <= 0;
                    end
                S6: if (count < sec2) begin
                        ps <= S6;
                        count <= count + 1;
                    end else begin
                        ps <= S1;
                        count <= 0;
                    end
                default: ps <= S1;
            endcase
        end
    end

    // Combinational block for output control
    always @(ps) begin
        case (ps)
            S1: begin
                light_M1 <= 3'b001; // Green
                light_M2 <= 3'b001; // Green
                light_MT <= 3'b100; // Red
                light_S <= 3'b100;  // Red
            end
            S2: begin
                light_M1 <= 3'b001; // Green
                light_M2 <= 3'b010; // Yellow
                light_MT <= 3'b100; // Red
                light_S <= 3'b100;  // Red
            end
            S3: begin
                light_M1 <= 3'b001; // Green
                light_M2 <= 3'b100; // Red
                light_MT <= 3'b001; // Green
                light_S <= 3'b100;  // Red
            end
            S4: begin
                light_M1 <= 3'b010; // Yellow
                light_M2 <= 3'b100; // Red
                light_MT <= 3'b010; // Yellow
                light_S <= 3'b100;  // Red
            end
            S5: begin
                light_M1 <= 3'b100; // Red
                light_M2 <= 3'b100; // Red
                light_MT <= 3'b100; // Red
                light_S <= 3'b001;  // Green
            end
            S6: begin
                light_M1 <= 3'b100; // Red
                light_M2 <= 3'b100; // Red
                light_MT <= 3'b100; // Red
                light_S <= 3'b010;  // Yellow
            end
            default: begin
                light_M1 <= 3'b000; // Off
                light_M2 <= 3'b000; // Off
                light_MT <= 3'b000; // Off
                light_S <= 3'b000;  // Off
            end
        endcase
    end
endmodule
