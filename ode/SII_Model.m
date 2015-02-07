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

%Defining the rate people enter advanced stage of Ebola: 
r = .50; 

%Defining the vectors: 
t = [t_initial zeros(1,n)] ;  
S = [S_initial zeros(1,n)]; 
I_not = [I_initial zeros(1,n)]; 

%Forward Euler's Method: 
for i = 1:n 
    t(i+1) = t(i)+t_step; 
    S(i+1) = S(i)+t_step*(-1*Transmission_of_Infection(1, 4, 3, I_not(i), S(i)));
    I_not(i+1) = I_not(i)+t_step*(Transmission_of_Infection(1, 4, 3, I_not(i), S(i))-r); 
end 

figure 
plot(t,S,'--g',t,I_not,':r')
xlabel('Time Steps'); 
ylabel('Population of People'); 


