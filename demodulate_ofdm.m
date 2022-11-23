function [D_tilde] = demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph)

ch_len = length(z_tilde) - mod(length(z_tilde), fft_size + cp_size);    % Channel length
z_reshaped = reshape(z_tilde(1 : ch_len), fft_size + cp_size, ch_len / (fft_size + cp_size));

z_reshaped_cp_remove = z_reshaped(cp_size + 1 : end, : );   % Removing cyclic prefix

D_tilde = fft(z_reshaped_cp_remove, fft_size, 1) / sqrt(fft_size);  % FFT operation

if switch_graph == 1
    
    scatterplot(reshape(D_tilde, numel(D_tilde), 1));
    title('Constellation Diagram of OFDM Demodulation');
    
end

end