function G = Transmission_of_Infection( a, k, h, I, S )
%TRANSMISSION_OF_INFECTION 
%   Quantifies Transmission of Infection

G = (k*I)/(1+(a*(I/S)^h)); 

end

