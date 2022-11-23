function [b_hat] = decode_hamming(c_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph)

if switch_off == 0
    
    b_hat = zeros((length(c_hat) - n_zero_padded_bits) * 4 / 7, 1);
    
    example_error = 0;
    
    for i = 1 : 7 : length(c_hat(1 : end - n_zero_padded_bits))
        
        c_temp = c_hat(i : i + 6);  % Codeword of 7 bits
        syndrome = mod(parity_check_matrix * c_temp, 2);    % Syndrome calculation by modulo 2
        
        if sum(syndrome) > 0    % if there is error
            
            for j = 1 : length(parity_check_matrix)
                
                if(parity_check_matrix(:, j) == syndrome) % Comparing the column of parity_check_matrix with syndrome
                    
                    c_temp(j) = not(c_temp(j)); % Erroneous bit is flipped
                    
                    if switch_graph == 1 && example_error == 0
                        
                        example_error = 1; % No more plotting for next error
                        figure('Name','Exemplary Hamming Decoding')
                        subplot(2,1,1)
                        stem(c_temp)
                        title('Corrected Codeword')
                        xlabel('Index')
                        ylabel('Value')
                        hold on
                        subplot(2,1,2);
                        stem(c_hat(i : i + 6))
                        title('Received Codeword')
                        xlabel('Index')
                        ylabel('Value')
                        
                    end
                    
                    break
                    
                end
                
            end
            
        end
        
        k = (i - 1) * 4 / 7 + 1;    % Indexing for b_hat
        b_hat(k : k + 3) = c_temp(1 : 4); % Decoded symbol
        
    end
    
else
    
    b_hat = c_hat(1 : end - n_zero_padded_bits);
    
end

end