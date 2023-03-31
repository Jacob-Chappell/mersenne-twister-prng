`timescale 1ns / 10ps

module tb_test();

    logic [3:0] [31:0] state;
    integer file;

    initial begin
        file = $fopen("data.txt", "wb");

        state[0] = 32'h12345678;
        state[1] = 32'h00000001;
        state[2] = 32'h00000020;
        state[3] = 32'h00000300;

        $fwrite(file, state[0]);
        $fwrite(file, state[1]);
        $fwrite(file, state[2]);
        $fwrite(file, state[3]);

        $fclose(file);

        #(10);
        state[0] = '0;
        state[1] = '0;
        state[2] = '0;
        state[3] = '0;
        #(10);

        file = $fopen("data.txt", "rb");

        $fread(state[0], file);
        $fread(state[1], file);
        $fread(state[2], file);
        $fread(state[3], file);

        $fclose(file);

        $display("%8h", state[0]);
        $display("%8h", state[1]);
        $display("%8h", state[2]);
        $display("%8h", state[3]);

        #(10);

        $stop;
    end

endmodule