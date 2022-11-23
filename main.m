%% Nahidul Islam, University of Bremen, Germany

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc;

%% define parameters

switch_graph_run = 1;                   % 0 --> single SNR simulation, 1 --> different SNRs simulation
switch_graph = 0;                       % 1/0--> show/not show the graph
switch_off = 0;                         % 1/0--> switch off/on the block

fft_size = 1024;                        % FFT length /OFDM symbol length
N_blocks = 8;                           % no. of blocks
parity_check_matrix = [1 0 1 1 1 0 0; 1 1 1 0 0 1 0; 0 1 1 1 0 0 1];    % code parity check matrix
constellation_order = 4;                % 2 --> 4QAM; 4 --> 16QAM; 6 --> 64QAM
frame_size = floor(fft_size * N_blocks * constellation_order / 7) * 4;  % frame length
n_zero_padded_bits = fft_size * N_blocks * constellation_order - frame_size * 7 / 4;    % no. of zeros added after encoding

pilot_symbol = pskmod(randi([0 3], fft_size, 1), 4);    % generated pilot symbols

cp_size = 32;                           % CP length

oversampling_factor = 20;               % oversampling factor
downsampling_factor = 20;               % downsampling factor

clipping_threshold_tx = 10;             % tx clipping_threshold, 10 --> no clipping, 2 --> low clipping, 1 --> severe clipping
clipping_threshold_rx = 10;             % rx clipping_threshold

channel_type = 'AWGN';                  % channel type: 'AWGN', 'FSBF'

if switch_graph_run == 0
    
    snr_db = 20;                        % Single SNR in dB
    iter = 10;
    
else
    
    snr_db = 0 : 10;                    % SNRs loop in dB
    iter = 10;                          % No. of iteration
    
end
%% initialize vectors
% You can save the BER result in a vector corresponding to different SNRs

BER_uncoded = [];
BER_coded = [];

papr_ofdm = [];
papr_tx = [];

%% OFDM transmission

for ii = 1 : length(snr_db)     % SNR Loop
    for jj = 1 : iter           % Frame Loop, generate enough simulated bits
        if ii == length(snr_db) && jj == iter
            
            switch_graph = 1;
            
        end
        %% transmitter %%
        
        %generate info bits
        b = generate_frame(frame_size, switch_graph);
        
        %channel coding
        switch_off = 0;
        c = encode_hamming(b, parity_check_matrix, n_zero_padded_bits, switch_off);
        
        %modulation
        d = map2symbols(c, constellation_order, switch_graph);
        
        %pilot insertion
        D = insert_pilots(d, fft_size, N_blocks, pilot_symbol);
        
        %ofdm modulation
        z = modulate_ofdm(D, fft_size, cp_size, switch_graph);
        
        %tx filter
        s = filter_tx(z, oversampling_factor, switch_graph, switch_off);
        
        %non-linear hardware
        x = impair_tx_hardware(s, clipping_threshold_tx, switch_graph);
        
        %% channel %%
        
        %baseband channel
        y = simulate_channel(x, snr_db(ii), channel_type, switch_graph);
        
        %% receiver %%
        
        %rx hardware
        s_tilde = impair_rx_hardware(y, clipping_threshold_rx, switch_graph);
        
        %rx filter
        z_tilde = filter_rx(s_tilde, downsampling_factor, switch_graph, switch_off);
        
        %ofdm demodulation
        D_tilde= demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph);
        
        %equalizer
        d_bar = equalize_ofdm(D_tilde, pilot_symbol, switch_graph);
        
        %demodulation
        c_hat = detect_symbols(d_bar, constellation_order, switch_graph);
        
        %channel decoding
        b_hat = decode_hamming(c_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph);
        
        %digital sink
        BER = digital_sink(b, b_hat, c, c_hat, switch_graph);
        
        if ii == length(snr_db) 
            idx = (jj - 1) * (N_blocks + 1) + 1;
            
            % PAPR of OFDM
            
            z_block = reshape(z, fft_size + cp_size, N_blocks + 1);
            papr_ofdm(idx : idx + N_blocks) = 10 * log10(max(abs(z_block(cp_size + 1 : end)).^2) ./ mean(abs(z_block(cp_size + 1 : end)).^2));
            
            
            % PAPR of Tx Non-linear Hardware
            
            len = length(filter_tx(1, oversampling_factor, 0, 0)) - oversampling_factor;
            x_block = reshape(x(len / 2 + 1 : end - len / 2), (fft_size + cp_size) * oversampling_factor, N_blocks + 1);
            papr_Tx( idx : idx + N_blocks) = 10 * log10(max(abs(x_block(cp_size * 20 + 1 : end)).^2) ./ mean(abs(x_block(cp_size * 20 + 1 : end)).^2));
            
        end
        
    end
    
    BER_coded = [BER_coded BER(1)];    % BER with channel coding
    
    BER_uncoded = [BER_uncoded BER(2)];    % BER without channel coding
    
end

%% plot BER-SNR figure

if switch_graph_run == 1 
    
figure('name', 'BER vs SNR (dB)')
semilogy(snr_db, BER_coded, "go--", "LineWidth", 2)
hold on
semilogy(snr_db, BER_uncoded, "r*-.", "LineWidth", 2)
grid on
xlabel("SNR (dB)")
ylabel("BER")
legend('Coded', 'Uncoded')

end

%% plot PAPR

    
figure('Name','OFDM PAPR')
plot(papr_ofdm)
title('OFDM PAPR')
xlabel('Symbol')
ylabel('PAPR in dB')
figure('Name','OFDM CDF of PAPR')
ecdf(papr_ofdm)
title('OFDM CDF of PAPR')
xlabel('PAPR in dB')
ylabel('Probability')

figure('Name','PAPR of Tx Non-linear Hardware')
plot(papr_Tx)
title('PAPR of Tx Non-linear Hardware')
xlabel('Symbol')
ylabel('PAPR in dB')
figure('Name','CDF of PAPR of Tx Non-linear Hardware')
ecdf(papr_Tx)
title('CDF of PAPR of Tx Non-linear Hardware')
xlabel('PAPR in dB')
ylabel('Probability')


