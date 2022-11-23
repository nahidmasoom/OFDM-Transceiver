function [y] = simulate_channel(x, snr_db, channel_type, switch_graph)

if channel_type == "AWGN"
    
    n = sqrt(1 / 2) * (randn(length(x), 1) + 1j * randn(length(x), 1));    % White Gaussian Noise with mean 0 and variance 1
    sigma = sqrt(mean(abs(x).^2) / 10^(snr_db / 10));    % Noise statndard deviation
    y = x + sigma * n;  % Noisy signal over the AWGN channel
    
else
    
    d = 0.5 : 0.20 : 40.5;
    power_profile = (exp(-d)).^2;
    channel_taps = length(power_profile);
    h = (randn(1, channel_taps) + 1j * randn(1, channel_taps)) .* sqrt(power_profile / 2); % Channel impulse response
    
    faded_signal = conv(x, h);
    n = sqrt(1 / 2) * (1 * randn(length(faded_signal), 1) + 1j * randn(length(faded_signal), 1));
    sigma = sqrt(mean(abs(faded_signal).^2) / 10^(snr_db / 10));
    y = faded_signal + sigma * n;   % Noisy signal over the frequency slective channel
    
end

if switch_graph == 1
    
    figure('name', 'Transmitted Signal and Received Signal')
    subplot(2, 1, 1)
    plot(abs(x))
    title('Transmitted Signal')
    xlabel('Time')
    ylabel('Magnitude')
    subplot(2, 1, 2)
    plot(abs(y))
    title('Received Signal')
    xlabel('Time')
    ylabel('Magnitude')
    
end

end

