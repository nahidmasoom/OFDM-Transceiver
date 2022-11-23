function [BER] = digital_sink(b, b_hat, c, c_hat, switch_graph)

error_coded = (b ~= b_hat);     % Erroneous bits with channel coding
error_uncoded = (c ~= c_hat);   % Erroneous bits without channel coding

BER_coded = sum(error_coded) / length(b);   % Coded BER calculation
BER_uncoded = sum(error_uncoded) / length(c);   % Uncoded BER calculation

BER = [BER_coded BER_uncoded];

if switch_graph == 1
    
    figure('name','Representation of Erroneous Positions')
    subplot(3,1,1)
    stem(b,'b')
    title('Original Signal')
    grid on
    subplot(3,1,2)
    stem(b_hat,'b')
    title('Estimated Signal')
    subplot(3,1,3)
    stem(error_coded,'k')
    title('Error Position')
    
end

end