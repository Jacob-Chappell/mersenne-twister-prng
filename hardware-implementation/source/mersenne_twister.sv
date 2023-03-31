// Mersenne twister hardware module
// default it is set to MT19937

module mersenne_twister #(
    parameter W = 32,
    parameter N = 624,
    parameter M = 397,
    parameter A = 32'h9908B0DF,
    parameter R = 31,
    parameter U = 11,
    parameter S = 7,
    parameter B = 32'h9D2C5680,
    parameter T = 15,
    parameter C = 32'hEFC60000,
    parameter L = 18
)(
    input clk, n_rst, load_value, gen_rv,
    input [W-1:0] value,
    output logic [W-1:0] rv
);

    logic shift_en;
    logic [W-1:0] x_n, stage2_out, stage2_out, stage3_out;

    logic [W-1:0] state_0, state_1, state_m;

    logic [W-1:0] [N-1:0] state;

    genvar i;
    generate
    for(i = 0; i < W; i++) begin
        flex_stp_sr IX #(.NUM_BITS(N), .SHIFT_MSB(0)) (.clk(clk), .n_rst(n_rst), .shift_enable(shift_en), .serial_in(x_n[i]), .parallel_out(state[i]));

//        assign state_0[i] = state[i][0];
//        assign state_1[i] = state[i][1];
//        assign state_m[i] = state[i][M];
    end

    assign state_0 = state[W-1:0][0];
    assign state_1 = state[W-1:0][1];
    assign state_m = state[W-1:0][M];

    //flex_stp_sr STATE[W-1:0] #(.NUM_BITS(N), .SHIFT_MSB(0)) (.clk(clk), .n_rst(n_rst), .shift_enable(shift_en), .serial_in(x_i), .parallel_out(state));

    // shift enable logic
    assign shift_en = load_val | gen_rv;

    // loading value logic
    assign x_n = load_i ? load_val : stage2_out;

    // stage 1 and 2
    always_comb begin
        stage1_out = {state_0[W-1:R], state_1[R-1:0]};
        stage2_out = state_m ^ (stage1_out >> 1) ^ (stage1_out[0] ? A : 0);
    end

    // stage 3
    always_comb begin
        stage3_out = stage2_out;
        stage3_out = stage3_out ^ (stage3_out >> U);
        stage3_out = stage3_out ^ ((stage3_out << S) & B);
        stage3_out = stage3_out ^ ((stage3_out << T) & C);
        stage3_out = stage3_out ^ (stage3_out >> L);
    end

    // register the output
    always_ff @(posedge clk, negedge n_rst) begin
        if(n_rst == 1'b0) rv = '0;
        else              rv = stage3_out;
    end

endmodule
