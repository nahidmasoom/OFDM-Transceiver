function [D] = insert_pilots(d, fft_size, N_blocks, pilot_symbol)

d_reshaped = reshape(d, fft_size, N_blocks);

D = [pilot_symbol, d_reshaped];     % Inserting pilot symbols for channel estimation at the receiver

end
