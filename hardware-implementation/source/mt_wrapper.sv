module mt_wrapper (
    input wire clk, n_rst,
    bus_protocol_if.peripheral_vital busif
);

    // Write to address 0x4 loads a 32-bit unsigned integer into the state
    // Read from address 0x0 generates a 32-bit unsigned random number

    logic write_en, read_en;

    mersenne_twister PRNG (.clk(clk), .n_rst(n_rst), .load_value(write_en), .gen_rv(read_en),
                            .value(busif.wdata), .rv(busif.rdata));

    // read logic
    assign read_en = busif.ren & (busif.addr[3:0] == 4'h0);

    // write logic
    assign write_en = busif.wen & (busif.addr[3:0] == 4'h4);

    // error logic
    //assign busif.error = (!read_en & busif.ren) | (!write_en & busif.wen) | !(&busif.strobe);
    assign busif.error = (!read_en & busif.ren) | (!write_en & busif.wen);

endmodule
