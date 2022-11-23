function [s] = filter_tx(z, oversampling_factor, switch_graph, switch_off)

if switch_off == 0
    
    z_upsampled = zeros(length(z) * oversampling_factor, 1);
    z_upsampled(1: oversampling_factor : end) = z;    % Upsampling by oversampling factor
    
    tx_filter = sqrt(oversampling_factor) * rcosdesign(0.25,10,20);
    s_filtered = conv(z_upsampled, tx_filter);
    
    s = s_filtered / sqrt(mean(abs(s_filtered).^2));    % Signal power is normalized to 1
    
    if switch_graph == 1
        
        fvtool(tx_filter)
        figure('Name', 'Transmitter Filter Output')
        subplot(2,1,1)
        plot(real(s),'g')
        grid on
        title('Tx Filter Output')
        xlabel('Time')
        ylabel('Amplitude')
        legend ('Real')
        subplot(2,1,2)
        plot(imag(s),'r')
        grid on
        xlabel('Time')
        ylabel('Amplitude')
        legend ('Imaginary')
        
    end
    
else
    
    s = z;
    
end

end