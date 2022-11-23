function [c] = encode_hamming(b, parity_check_matrix, n_zero_padded_bits, switch_off)

generator_matrix = [eye(4), transpose(parity_check_matrix(: , 1 : 4))]; % Generator matrix derived from parity check matrix

if switch_off == 0
    
    b_reshaped = reshape(b, 4, length(b) / 4); 
    codewords = mod(b_reshaped' * generator_matrix, 2); % Codewords are clalculated by modulo 2
    c_reshaped = reshape(codewords', length(b) * 7 / 4, 1);
    c = [c_reshaped; zeros(n_zero_padded_bits, 1)];     % Zero padding
    
else
    
    c = [b; zeros(n_zero_padded_bits, 1)];
    
end

end