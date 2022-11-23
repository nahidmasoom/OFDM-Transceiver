function [d_bar] = equalize_ofdm(D_tilde, pilot_symbol, switch_graph)

channel_spectrum = D_tilde( : , 1) ./ pilot_symbol;     % Channel frequncy response estimation

D_tilde_equalized = D_tilde( : , 2 : end) ./ channel_spectrum; % Symbol equalization after extracting pilot symbol

d_bar = reshape(D_tilde_equalized, numel(D_tilde_equalized), 1);

if switch_graph == 1
    
    figure('name','Constellation Diagram of Equalizer');
    plot(d_bar,'r*');
    title('Constellation Diagram after Equalization');
    xlabel('In-phase Amplitude');
    ylabel('Quadrature Amplitude');
    drawnow
    
end

end