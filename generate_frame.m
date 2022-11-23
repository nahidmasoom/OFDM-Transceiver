function [b] = generate_frame(frame_size, switch_graph)

b = rand(frame_size, 1) > 0.5;  % Bit stream with equal probability of 0s and 1s

if switch_graph == 1
    
    figure('name', 'Binary Data of Digital Source')
    stem(b)
    title('Binary Data of Digital Source')
    
end

end