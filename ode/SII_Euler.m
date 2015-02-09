function [S, I, A, t] = SII_Euler(S_initial, I_initial, A_initial, t_initial, t_final, n, r, d)
% SII_EULER Solves the ODE with the Forward Euler's Method

% Compute time step
t_step = (t_final-t_initial)/n; 

% Defining the vectors: 
t = [t_initial zeros(1,n)];  
S = [S_initial zeros(1,n)]; 
I = [I_initial zeros(1,n)]; 
A = [A_initial zeros(1,n)]; 

% Forward Euler's Method: 
for i = 1:n 
    t(i+1) = t(i)+t_step; 
    S(i+1) = S(i)+t_step*(-1*Transmission_of_Infection(120, 2, 1, S(i), I(i), A(i)));
    I(i+1) = I(i)+t_step*(Transmission_of_Infection(120, 2, 1, S(i), I(i), A(i))-r*I(i)); 
    A(i+1) = r*I(i) - d*A(i); 
end 

end
