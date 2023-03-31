`timescale 1ns / 10ps

module tb_mersenne_twister();

    parameter INIT_STATE_FILENAME = "./docs/startState.bin"
    parameter OUTPUT_FILENAME     = "./docs/output_hw.bin"

    localparam SEEK_START = 0;
    localparam SEEK_CUR   = 1;
    localparam SEEK_END   = 2;

    // DUT Signals
    logic tb_clk;
    logic tb_n_rst;
    logic tb_load_value;
    logic tb_gen_rv;
    logic [31:0] tb_value;
    logic [31:0] tb_rv;

    // Test bench signals
    integer i; // iterator variable
    logic [31:0] x; // variable for reading/writing unsigned integers
    integer in_file;
    integer out_file;
    integer quiet_catch;

    localparam N = 624;

    localparam CLK_PERIOD = 10ns;

    task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronize with clock)
		tb_n_reset = 1'b0;

		// Wait for a couple clock cycles
		@(posedge tb_clk);
		@(posedge tb_clk);

		// Release the reset
		@(negedge tb_clk);
		tb_n_reset = 1;

		// Wait for a while before activating the design
		@(posedge tb_clk);
		@(posedge tb_clk);
	end
	endtask

	// Clock gen block
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
	end

	// DUT portmap
	mersenne_twister DUT (.clk(tb_clk), .n_rst(tb_n_rst), .load_value(tb_load_value), .gen_rv(tb_gen_rv)
                            .value(tb_value), .rv(tb_rv));

    // task for loading a single value into the state
    task send_value;
        input [31:0] value;
    begin
        @(negedge tb_clk);

        tb_value = value;
        tb_load_value = 1'b1;

        @(negedge tb_clk);
        tb_load_value = 1'b0;
    end
    endtask

    // task for loading the state from the in_file
    task load_state;
    begin
        in_file = $fopen(INIT_STATE_FILENAME, "rb");

        for(i = 0; i < N; i = i + 1) begin
            // not sure how to read in the binary data in any other way. May have to be adjusted to match the c program
            quiet_catch = $fscanf(in_file, "%c", x[7:0]);
            quiet_catch = $fscanf(in_file, "%c", x[15:8]);
            quiet_catch = $fscanf(in_file, "%c", x[23:16]);
            quiet_catch = $fscanf(in_file, "%c", x[31:24]);

            send_value(x);
        end

        $fclose(in_file);
    end
    endtask

    // task for getting a new rv
    task get_rv;
    begin
        @(negedge tb_clk);

        tb_gen_rv = 1'b1;

        @(negedge tb_clk);
        tb_gen_rv = 1'b0;

        $fwrite(out_file, "%c", x[7:0]);
        $fwrite(out_file, "%c", x[15:8]);
        $fwrite(out_file, "%c", x[23:16]);
        $fwrite(out_file, "%c", x[31:24]);
    end
    endtask

    // task for generating a specific number of rvs
    begin gen_n_rvs;
        integer n;
    begin
        out_file = $fopen(OUTPUT_FILENAME, "wb");

        for(i = 0; i < n; i = i + 1) begin
            get_rv();
        end

        $fclose(out_file);
    end
    endtask

    // main bench process
    intial begin
        logic tb_clk;
        logic tb_n_rst;
        logic tb_load_value;
        logic tb_gen_rv;
        logic [31:0] tb_value;
        logic [31:0] tb_rv;

        $stop;
    end


