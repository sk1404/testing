


module fsm1011 (
    input wire clk,
    input wire rst,
    input wire x,
    output reg y
);

    reg [2:0] ps, ns;

    // State encoding
    parameter s0 = 3'd0,
              s1 = 3'd1,
              s2 = 3'd2,
              s3 = 3'd3;

    // State transition
    always @(posedge clk) begin
        if (rst)
            ps <= s0;
        else
            ps <= ns;
    end

    // Next state and output logic (Mealy type)
    always @(*) begin
        case (ps)
            s0: begin
                y = 0;
                if (x) ns = s1;
                else   ns = s0;
            end
            s1: begin
                y = 0;
                if (x) ns = s1;
                else   ns = s2;
            end
            s2: begin
                y = 0;
                if (x) ns = s3;
                else   ns = s0;
            end
            s3: begin
                if (x) begin
                    y = 1; // Mealy output
                    ns = s1;
                end else begin
                    y = 0;
                    ns = s2;
                end
            end
            default: begin
                y = 0;
                ns = s0;
            end
        endcase
    end

endmodule




set_attr lib_search_path /home/pgstudent14/counter_design_database_45nm/lib/
set_attr hdl_search_path /home/pgstudent14/counter_design_database_45nm/rtl/
set_attr library /home/pgstudent14/counter_design_database_45nm/lib/slow_vdd1v0_basicCells.lib
read_hdl /home/pgstudent14/counter_design_database_45nm/simulation/rakeshvtv/fsm.v
elaborate
read_sdc /home/pgstudent14/counter_design_database_45nm/simulation/rakeshvtv/fsm.sdc
synthesize -to_mapped -effort medium
#write_hdl > dft_10_count_netlist.v
#write_sdc > dft_10_count_sdc.sdc
#report_area > 4_bit_count_area.rep
#report_gates > 4_bit_count_gates.rep
#report_power > 4_bit_count_power.rep
#report_timing > 4_bit_count_timing.rep
gui_show

# Define a primary clock with 10 ns period
create_clock -name clk -period 10 [get_ports clk]

# Set input delay for 'reset' and 'in' signals relative to clock
set_input_delay -clock clk 2 [get_ports reset]
set_input_delay -clock clk 2 [get_ports in]

# Set output delay for 'detected' signal relative to clock
set_output_delay -clock clk 2 [get_ports detected]

# Optional: constraints for multicycle paths or false paths can be added here
# set_false_path -from [get_ports reset]
