function [z] = modulate_ofdm(D, fft_size, cp_size, switch_graph)

D_ifft = sqrt(fft_size) * ifft(D, fft_size, 1);     % IFFT operation

cyclic_prefix = D_ifft(fft_size - cp_size + 1 : fft_size, :);
D_ifft_cp = [cyclic_prefix; D_ifft];    % Insertion of cyclic prefix

z = reshape(D_ifft_cp, numel(D_ifft_cp), 1);

if switch_graph == 1
    
    figure('name','OFDM Symbol in Time Domain')
    plot(abs(z(fft_size + cp_size + 1 : 2 * (fft_size + cp_size))))
    title('OFDM Symbol in Time Domain')
    xlabel('Time')
    ylabel('Amplitude')
    
    figure('name','OFDM Symbol in Frequency Domain')
    plot(abs(D( : , 2)))
    xlabel('Subcarrier')
    ylabel('|H|')
    title('OFDM Symbol in Frequency Domain')
    
end

end