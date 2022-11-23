function [c_hat] = detect_symbols(d_bar, constellation_order, switch_graph)

if constellation_order == 2
    
    constellation_points = sqrt(1 / 2) * [1+1i; 1-1i; -1+1i; -1-1i];
    % Normalized constellation (indexed according to gray mapping) for 4-QAM having average symbol power 1
    
elseif constellation_order == 4
    
    constellation_points = sqrt(1 / 10) * [-3-3i; -3-1i; -3+3i; -3+1i; -1-3i; -1-1i; -1+3i; -1+1i; 3-3i; 3-1i; 3+3i; 3+1i; 1-3i; 1-1i; 1+3i; 1+1i];
    % Normalized constellation (indexed according to gray mapping) for 16-QAM having average symbol power 1
    
elseif constellation_order == 6
    
    constellation_points = sqrt(1 / 42) * [-7-7i; -7-5i; -7-1i; -7-3i; -7+7i; -7+5i; -7+1i; -7+3i; -5-7i; -5-5i; -5-1i; -5-3i; -5+7i; -5+5i; -5+1i; -5+3i; -1-7i; -1-5i; -1-1i; -1-3i; -1+7i; -1+5i; -1+1i; -1+3i; -3-7i; -3-5i; -3-1i; -3-3i; -3+7i; -3+5i; -3+1i; -3+3i; 7-7i; 7-5i; 7-1i; 7-3i; 7+7i; 7+5i; 7+1i; 7+3i; 5-7i; 5-5i; 5-1i; 5-3i; 5+7i; 5+5i; 5+1i; 5+3i; 1-7i; 1-5i; 1-1i; 1-3i; 1+7i; 1+5i; 1+1i; 1+3i; 3-7i; 3-5i; 3-1i; 3-3i; 3+7i; 3+5i; 3+1i; 3+3i];
    % Normalized constellation (indexed according to gray mapping) for 64-QAM having average symbol power 1
    
end

c_hat = zeros(length(d_bar) * constellation_order, 1);

for i = 1 : length(d_bar)
    
    distance = abs(d_bar(i) - constellation_points);    % Distances are calculted from symbol to constellation points
    [~, symbol_index] = min(distance);  % Symbol index is found by minimum distance
    j = (i-1)* constellation_order + 1;   % Indexing for bit stream c_hat
    c_hat(j : j + constellation_order - 1) = de2bi(symbol_index - 1, constellation_order, 'left-msb')'; % Decimal to binary conversion
    
end

if switch_graph == 1
    
    F = scatterplot(d_bar, 1, 0, 'g.');
    hold on
    scatterplot(constellation_points, 1, 0, 'b*', F)
    title('Constellation at Receiver')
    grid on
    
end

end