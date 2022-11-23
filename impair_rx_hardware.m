function [s_tilde] = impair_rx_hardware(y, clipping_threshold_rx, switch_graph)

r = abs(y);
theta = angle(y);

clipping_mask = r > clipping_threshold_rx;   % Comparing with clipping threshold
r(clipping_mask) = clipping_threshold_rx;

[a, b] = pol2cart(theta, r);
s_tilde = a + b * 1i; % Polar to cartesian transformation

if switch_graph == 1
    
    figure('name','Rx Hardware')
    subplot(2,1,1)
    plot(abs(y))
    title('Input Signal of Rx Hardware')
    xlabel('Time')
    ylabel('Magnitude')
    grid on
    subplot(2,1,2)
    plot(abs(s_tilde))
    grid on
    title('Output Signal of Rx Hardware')
    xlabel('Time')
    ylabel('Magnitude')
    
end

end