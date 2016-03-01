syms r1 r2 a1 a2 k1 k2
A = [(2*r1 / k1) (a1 + a2); (a1 + a2) (2 * r2 / k2)];
B = [r1; r2];
A\B;

dxdt = @(x,y,r,k,a) (r * x) * (1 - (x / k)) - (a * x * y);
dydt = @(x,y,r,k,a) (r * y) * (1 - (y / k)) - (a * x * y);

r1 = .05;
r2 = .08;
k1 = 150000;
k2 = 400000;
a1 = 1e-8;
a2 = 1e-8;

% Max growth values
blue = (k1*(a1*k2*r2 - 2*r1*r2 + a2*k2*r2))/(k1*k2*a1^2 + 2*k1*k2*a1*a2 + k1*k2*a2^2 - 4*r1*r2);
fin = (k2*r1*(a1*k1 - 2*r2 + a2*k1))/(k1*k2*a1^2 + 2*k1*k2*a1*a2 + k1*k2*a2^2 - 4*r1*r2);

maxGrow = dxdt(blue, fin, r1, k1, a1) + dydt(blue, fin, r2, k2, a2);

rateBlueExtinct = dydt(0,k2 / 2,r2,k2,a2);
rateFinExtinct = dxdt(k1 / 2,0,r1,k1,a1);


%syms r1 r2 a1 a2 k1 k2
%C = [24000 * (r1 / k1) (12000 * a1 + 6000 * a2) ; (12000 * a1 + 6000 * a2) 12000 * (r2 / k2)];
%D = [12000 * r1 ; 6000 * r2];
%C\D;

blueProfit = (k1*(2*a1*k2*r2 - 4*r1*r2 + a2*k2*r2))/(4*k1*k2*a1^2 + 4*k1*k2*a1*a2 + k1*k2*a2^2 - 8*r1*r2);
finProfit = (2*k2*r1*(2*a1*k1 - 2*r2 + a2*k1))/(4*k1*k2*a1^2 + 4*k1*k2*a1*a2 + k1*k2*a2^2 - 8*r1*r2);

whaleProfit([a1 a2], [r1 r2], [k1 k2], blueProfit, finProfit, [12000 6000])


[blueIntMax, finIntMax] = maxFunctionInt(blueProfit, finProfit, @(b, f)whaleProfit([a1 a2], [r1 r2], [k1 k2], b, f, [12000 6000]))
syms a
cash = whaleProfit([a a], [r1 r2], [k1 k2], blueProfit, finProfit, [12000 6000]);

% max profit in terms of a in the form m / n - (pa / q)
m = 9674268919362393375;
n = 137438953472;
p = 36524032448555282942964047753604375;
q = 147573952589676412928;

pmaxy = 6000 * r2^2 * k2 * ((2 - r2) / 4);
pmaxx = 12000 * r1^2 * k1 * ((2 - r1) / 4);

eqn = cash == pmaxy;
solve(eqn, a)

k = k1;
a = a1;
r = r1;
b = a2;
l = k2;
s = r2;

%for the following, a2 = b, k2 = l, r2 = s
dfda = (9*k*l*r)/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)-(3*l*r*(18*a*k*l+24*b*k*l)*(3*a*k+4*b*k-3*s))/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)^2;
sfa = dfda * a / finIntMax;
dfdb = (12*k*l*r)/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)-(3*l*r*(24*a*k*l+32*b*k*l)*(3*a*k+4*b*k-3*s))/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)^2;
sfb = dfdb * b / finIntMax;
dfdk = (3*l*r*(3*a+4*b))/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)-(3*l*r*(9*a^2*l+24*a*b*l+16*b^2*l)*(3*a*k+4*b*k-3*s))/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)^2;
sfk = dfdk * k / finIntMax;
dfdl = -(54*r^2*s*(3*a*k+4*b*k-3*s))/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)^2;
sfl = dfdl * l / finIntMax;
dfdr = (3*l*(3*a*k+4*b*k-3*s))/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)+(54*l*r*s*(3*a*k+4*b*k-3*s))/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)^2; 
sfr = dfdr * r / finIntMax;
dfds = (54*l*r^2*(3*a*k+4*b*k-3*s))/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s)^2-(9*l*r)/(9*a^2*k*l+24*a*b*k*l+16*b^2*k*l-18*r*s);
sfs = dfds * s / finIntMax;

%disp(maxFunctionInt(blueProfit, finProfit, @(b,f)whaleProfit([a1 a2], [r1 r2], [k1 k2], b, f, [12000 6000])))