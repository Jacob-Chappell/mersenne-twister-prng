`timescale 1ns / 10ps

module tb_test();

    logic [0:3] [31:0] state;
    integer file, i;

    initial begin
        file = $fopen("data.txt", "wb");

        state[0] = 32'h12345678;
        state[1] = 32'h00000001;
        state[2] = 32'h00000020;
        state[3] = 32'h00000300;

        $fdisplay(file, "0x%8x", state[0]);
	    $fdisplay(file, "0x%8x", state[1]);
	    $fdisplay(file, "0x%8x", state[2]);
	    $fdisplay(file, "0x%8x", state[3]);

        $fclose(file);

        #(10);
        state[0] = '0;
        state[1] = '0;
        state[2] = '0;
        state[3] = '0;
        #(10);

        file = $fopen("startState.bin", "rb");

        $fread(state, file);

        for(i = 0; i < 4; i ++) begin
            state[i] = {state[i][7:0], state[i][15:8], state[i][23:16], state[i][31:24]};
        end

        $fclose(file);

        $display("%8h", state[0]);
        $display("%8h", state[1]);
        $display("%8h", state[2]);
        $display("%8h", state[3]);

        #(10);

        $stop;
    end

endmodule