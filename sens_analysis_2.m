r=.05; %r1
s=.08; %r2
K=150000; %K1
L=400000; %K2
a=10^-8; %a1
b=10^-8; %a2

X=(3*K*(3*a*L*s - 6*r*s + 4*b*L*s))/(2*(9*K*L*a^2 + 24*K*L*a*b + 16*K*L*b^2 - 18*r*s)); %blueprofit from scratch.m

dXdr= -(9*K*L*s*(3*a+4*b)*(3*a*K+4*b*K-3*s))/(K*L*(3*a+4*b)^2-18*r*s)^2;
dXds= (3*K^2*L*(3*a+4*b)^2*(3*a*L+4*b*L-6*r))/(2*(K*L*(3*a+4*b)^2-18*r*s)^2);
dXdK= -(27*r*s^2*(3*a*L+4*b*L-6*r))/(K*L*(3*a+4*b)^2-18*r*s)^2;
dXdL= (9*K*r*s*(3*a+4*b)*(3*a*K+4*b*K-3*s))/(K*L*(3*a+4*b)^2-18*r*s)^2;
dXda= (9*K*L*s*(K*(-(3*a+4*b))*(3*a*L+4*b*L-12*r)-18*r*s))/(2*(K*L*(3*a+4*b)^2-18*r*s)^2);
dXdb= (6*K*L*s*(K*(-(3*a+4*b))*(3*a*L+4*b*L-12*r)-18*r*s))/(K*L*(3*a+4*b)^2-18*r*s)^2;

sens_X_r= dXdr*(r/X);
sens_X_s= dXds*(s/X);
sens_X_K= dXdK*(K/X);
sens_X_L= dXdL*(L/X);
sens_X_a= dXda*(a/X);
sens_X_b= dXdb*(b/X);

