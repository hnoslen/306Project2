r=.05; %r1
s=.08; %r2
K=150000; %K1
L=400000; %K2
a=10^-8; %a1
b=10^-8; %a2

dxdK=-(4*r*(s^2)*(L*(a+b)-2*r))/(K*L*(a+b)^2-4*r*s)^2;
dydK=(2*L*(s^2)*(a+b)*(L*(a+b)-2*r))/(K*L*((a+b)^2)-(4*r*s))^2;
dxdL=(2*K*r*s*(a+b)*(K*(a+b)-2*s))/(K*L*((a+b)^2)-(4*r*s))^2;
dydL=-(4*r*(s^2)*(K*(a+b)-2*s))/(K*L*(a+b)^2-4*r*s)^2;
dxda=(K*L*s*(K*(-(a+b))*(L*(a+b)-4*r)-4*r*s))/(K*L*(a+b)^2-4*r*s)^2;
dyda=(K*L*s*(4*s*(L*(a+b)-r)-K*L*(a+b)^2))/(K*L*(a+b)^2-4*r*s)^2;
dxdb=(K*L*s*(K*(-(a+b))*(L*(a+b)-4*r)-4*r*s))/(K*L*(a+b)^2-4*r*s)^2;
dydb=(K*L*s*(4*s*(L*(a+b)-r)-K*L*(a+b)^2))/(K*L*(a+b)^2-4*r*s)^2;
dxdr=-(2*K*L*s*(a+b)*(K*(a+b)-2*s))/(K*L*(a+b)^2-4*r*s)^2;
dydr=(4*L*s^2*(K*(a+b)-2*s))/(K*L*(a+b)^2-4*r*s)^2;
dxds=(K^2*L*(a+b)^2*(L*(a+b)-2*r))/(K*L*(a+b)^2-4*r*s)^2;
dyds=(L*(K^2*L*(a+b)^3-4*K*L*s*(a+b)^2+8*r*s^2))/(K*L*(a+b)^2-4*r*s)^2;
x=69104;
y=196545;
sens_x_K= dxdK*(K/x);
sens_y_K= dxdK*(K/y);
sens_x_L= dxdL*(L/x);
sens_y_L= dydL*(L/y);
sens_x_a= dxda*(a/x);
sens_y_a= dyda*(a/y);
sens_x_b= dxdb*(b/x);
sens_y_b= dydb*(b/y);
sens_x_r= dxdr*(r/x);
sens_y_r=dydr*(r/y);
sens_x_s=dxds*(s/x);
sens_y_s=dyds*(s/y);

%display(sprintf('The sensitivity of blue whale population to K1 is: %f \nThe sensitivity of fin whale population to K1 is: %f \nThe sensitivity of blue whale poulation to K2 is: %f \nThe sensitivity of fin whale population to K2 is: %f \nThe sensitivity of blue whale population to r1 is: %f \nThe sensitivity of fin whale population to r1 is: %f \nThe sensitivity of blue whale population to r2 is: %f \nThe sensitivity of fin whale population to r2 is: %f \nThe sensitivity of blue whale population to a1 is: %f \nThe sensitivity of fin whale population to a1 is: %f \nThe sensitivity of blue whale population to a2 is: %f \nThe sensitivity of fin whale population to a2 is: %f', sens_x_K, sens_y_K, sens_x_L, sens_y_L, sens_x_r, sens_y_r, sens_x_s, sens_y_s, sens_x_a, sens_y_a, sens_x_b, sens_y_b))
