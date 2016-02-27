syms r1 r2 a1 a2 k1 k2
A = [(2*r1 / k1) (a1 + a2); (a1 + a2) (2 * r2 / k2)];
B = [r1; r2];
A\B

dxdt = @(x,y,r,k,a) (r * x) * (1 - (x / k)) - (a * x * y);
dydt = @(x,y,r,k,a) (r * y) * (1 - (y / k)) - (a * x * y);

r1 = .05;
r2 = .08;
k1 = 150000;
k2 = 400000;
a1 = 1e-8;
a2 = 1e-8;

% Max growth values
blue = (k1*(a1*k2*r2 - 2*r1*r2 + a2*k2*r2))/(k1*k2*a1^2 + 2*k1*k2*a1*a2 + k1*k2*a2^2 - 4*r1*r2)
fin = (k2*r1*(a1*k1 - 2*r2 + a2*k1))/(k1*k2*a1^2 + 2*k1*k2*a1*a2 + k1*k2*a2^2 - 4*r1*r2)

maxGrow = dxdt(blue, fin, r1, k1, a1) + dydt(blue, fin, r2, k2, a2)

rateBlueExtinct = dydt(0,k2 / 2,r2,k2,a2)
rateFinExtinct = dxdt(k1 / 2,0,r1,k1,a1)


syms r1 r2 a1 a2 k1 k2
C = [24000 * (r1 / k1) (12000 * a1 + 16000 * a2) ; (12000 * a1 + 16000 * a2) 12000 * (r2 / k2)];
D = [12000 * r1 ; 6000 * r2];
C\D

blueProfit =  (3*k1*(3*a1*k2*r2 - 6*r1*r2 + 4*a2*k2*r2))/(2*(9*k1*k2*a1^2 + 24*k1*k2*a1*a2 + 16*k1*k2*a2^2 - 18*r1*r2));
finProfit = (3*k2*r1*(3*a1*k1 - 3*r2 + 4*a2*k1))/(9*k1*k2*a1^2 + 24*k1*k2*a1*a2 + 16*k1*k2*a2^2 - 18*r1*r2);

whaleProfit([a1 a2], [r1 r2], [k1 k2], blueProfit, finProfit, [12000 6000])