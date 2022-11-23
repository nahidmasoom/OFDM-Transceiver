function [d] = map2symbols(c, constellation_order, switch_graph)

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

d = zeros(length(c) / constellation_order, 1);

for i = 1 : constellation_order : length(c)
    
    symbol_index = bi2de(transpose(c(i : i + constellation_order - 1)), 'left-msb');  % Binary to decimal coversion
    d((i-1)/ constellation_order + 1) = constellation_points(symbol_index + 1);   % Symbols are mapped into the constelation points
    
end

if switch_graph == 1
    
    scatterplot(d, 1, 0, 'b*')
    title('Modulated Symbols')
    grid on
    
end

end