function G = Transmission_of_Infection( k, l, a, S, I, A)
%TRANSMISSION_OF_INFECTION 
%   Quantifies Transmission of Infection

x = (I+A)/S; 
G = (S*k*(x^l))/(1+a*x); 

end

