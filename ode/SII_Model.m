%Clear working space:
clear; 

%Initial time condition: 
t_initial = 0; 
t_final = 10;  

%Defining the time step: 
n = 1000; 
t_step = (t_final-t_initial)/n; 

%Defining initial condition: 
S_initial = 1000; 
I_initial = 30; 
A_initial = 10; 

%Defining the rate people enter advanced stage of Ebola: 
r = .50; 
d = .10; 

%Defining the vectors: 
t = [t_initial zeros(1,n)];  
S = [S_initial zeros(1,n)]; 
I = [I_initial zeros(1,n)]; 
A = [A_initial zeros(1,n)]; 

%Forward Euler's Method: 
for i = 1:n 
    t(i+1) = t(i)+t_step; 
    S(i+1) = S(i)+t_step*(-1*Transmission_of_Infection(1, 2, 1, S(i), I(i), A(i)));
    I(i+1) = I(i)+t_step*(Transmission_of_Infection(1, 2, 1, S(i), I(i), A(i))-r*I(i)); 
    A(i+1) = r*I(i) - d*A(i); 
end 

figure 
plot(t,S,'--g', t,I,':r', t,A,'-b')
xlabel('Time Steps'); 
ylabel('Population of People'); 


