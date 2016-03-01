%sensitivity analysis of blue whale profit to all 6 parameters
r=.05; %r1
s=.08; %r2
K=150000; %K1
L=400000; %K2
a=10^-8; %a1
b=10^-8; %a2

X=(3*K*(3*a*L*s - 6*r*s + 4*b*L*s))/(2*(9*K*L*a^2 + 24*K*L*a*b + 16*K*L*b^2 - 18*r*s)); %blueprofit from scratch.m

dXdr= -(4*K*L*s*(2*a+b)*(2*a*K+b*K-2*s))/(K*L*((2*a+b)^2)-8*r*s)^2;
dXds= ((K^2)*L*(2*a+b)^2*(2*a*L+b*L-4*r))/(K*L*(2*a+b)^2-8*r*s)^2;
dXdK= -(8*r*s^2*(2*a*L+b*L-4*r))/(K*L*(2*a+b)^2-8*r*s)^2;
dXdL= (4*K*r*s*(2*a+b)*(2*a*K+b*K-2*s))/(4*a^2*K*L+4*a*b*K*L+b^2*K*L-8*r*s)^2;
dXda= (2*K*L*s*(K*(-(2*a+b))*(2*a*L+b*L-8*r)-8*r*s))/(K*L*(2*a+b)^2-8*r*s)^2;
dXdb= (K*L*s*(K*(-(2*a+b))*(2*a*L+b*L-8*r)-8*r*s))/(K*L*(2*a+b)^2-8*r*s)^2;

sens_X_r= dXdr*(r/X);
sens_X_s= dXds*(s/X);
sens_X_K= dXdK*(K/X);
sens_X_L= dXdL*(L/X);
sens_X_a= dXda*(a/X);
sens_X_b= dXdb*(b/X);
