function [x] = impair_tx_hardware(s, clipping_threshold_tx, switch_graph)

r = abs(s);
theta = angle(s);

clipping_mask = r > clipping_threshold_tx;   % Comparing with clipping threshold
r(clipping_mask) = clipping_threshold_tx;

[p, q] = pol2cart(theta, r);    % Polar to cartesian transformation

x = p + q * 1i;

if switch_graph == 1
    
    figure('name','Tx Hardware')
    subplot(2, 1, 1)
    plot(abs(s),'b')
    title('Input of Tx Hardware')
    xlabel('Time')
    ylabel('Magnitude')
    grid on
    subplot(2, 1, 2)
    plot(abs(x),'b')
    grid on
    title('Output of Tx Hardware')
    xlabel('Time')
    ylabel('Magnitude')
    
end

end