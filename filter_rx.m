function [z_tilde] = filter_rx(s_tilde, downsampling_factor, switch_graph, switch_off)

if switch_off == 0
    
    rx_filter = 1 / sqrt(downsampling_factor) * transpose(rcosdesign(0.25, 10, 20));
    filtered_output = conv(s_tilde, rx_filter);
    
    z_tilde_filtered = filtered_output(length(rx_filter) : downsampling_factor : end - length(rx_filter) - 1);
    
    z_tilde = z_tilde_filtered / sqrt(mean(abs(z_tilde_filtered).^2)); % Signal power is normalized to 1
    
    if switch_graph == 1
        
        eyediagram(z_tilde, 2)
        
        figure('Name', 'Rx Filter')
        subplot(2,1,1)
        plot(real(z_tilde),'g')
        grid on
        title('Output of Rx Filter')
        xlabel('Time')
        ylabel('Amplitude')
        legend ('Real')
        subplot(2,1,2)
        plot(imag(z_tilde),'r')
        grid on
        xlabel('Time')
        ylabel('Amplitude')
        legend ('Imaginary')
        
    end
    
else
    
    z_tilde = s_tilde;
    
end

end