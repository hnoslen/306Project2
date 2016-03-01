%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Whaling model
%%% Tristan Knoth, Henry Nelson, Valerie McGraw
%%% Mathematical Modeling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defining anonymous functions for growth rates and gradients for use
% throughout
dx = @(x,y,r1,k1,a1) (r1*x.*(1-(x/k1)))-(a1*x.*y);
dy = @(x,y,r2,k2,a2) (r2*y.*(1-(y/k2)))-(a2*x.*y);
gradXY = @(x,y,r,K,a) dx(x,y,r(1),K(1),a(1))+dy(x,y,r(2),K(2),a(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Initializing constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The model needs only these values set
% The first in each pair is for blue whales,
%   the second is for fin whales

% Inherent growth rate
r = [0.05 0.08];
% Carrying capacity
K = [150000 400000];
% Competition parameter
a = [10^-8 10^-8];
% Profit from harvesting one whale
prices = [12000 6000];


xmax = 1*K(1);
ymax = 1*K(2);



% Maximizing total population growth rate
blue_pop_max_growth_rate = (K(1)*(a(1)*K(2)*r(2) - 2*r(1)*r(2) + a(2)*K(2)*r(2)))/(K(1)*K(2)*a(1)^2 + 2*K(1)*K(2)*a(1)*a(2) + K(1)*K(2)*a(2)^2 - 4*r(1)*r(2));
fin_pop_max_growth_rate = (K(2)*r(1)*(a(1)*K(1) - 2*r(2) + a(2)*K(1)))/(K(1)*K(2)*a(1)^2 + 2*K(1)*K(2)*a(1)*a(2) + K(1)*K(2)*a(2)^2 - 4*r(1)*r(2));
[blue_pop_int, fin_pop_int] = maxFunctionInt(blue_pop_max_growth_rate, fin_pop_max_growth_rate, @(x,y)(dx(x,y,r(1),K(1),a(1)) + dy(x,y,r(1),K(1),a(1))));
max_growth_rate = dx(blue_pop_int,fin_pop_int,r(1),K(1),a(1)) + dy(blue_pop_int,fin_pop_int,r(2),K(2),a(2));
display(sprintf('The total whale population will grow fastest when there are %d blue whales and %d fin whales.\nThe population will be growing at a rate of approximately %f whales per year',blue_pop_int, fin_pop_int, max_growth_rate));

% Sensitivity of total population growth rate to blue whale population
sensitivity(@(x)(dx(x,fin_pop_max_growth_rate,r(1),K(1),a(1)) + dy(x,fin_pop_max_growth_rate,r(2),K(2),a(2))), blue_pop_max_growth_rate)
% Sensitiviy of total population growth rate to fin whale population
sensitivity(@(y)(dy(blue_pop_max_growth_rate,y,r(2),K(2),a(2)) + dx(blue_pop_max_growth_rate,y,r(1),K(1),a(1))), fin_pop_max_growth_rate)

% Will driving whales to extinction improve growth rates??
% TODO


% Total population of whales
% TODO
% also sensitivity


% Maximizing yearly (sustainable) profit
blue_pop_profit = (K(1)*(2*a(1)*K(2)*r(2) - 4*r(1)*r(2) + a(2)*K(2)*r(2)))/(4*K(1)*K(2)*a(1)^2 + 4*K(1)*K(2)*a(1)*a(2) + K(1)*K(2)*a(2)^2 - 8*r(1)*r(2));
fin_pop_profit = (2*K(2)*r(1)*(2*a(1)*K(1) - 2*r(2) + a(2)*K(1)))/(4*K(1)*K(2)*a(1)^2 + 4*K(1)*K(2)*a(1)*a(2) + K(1)*K(2)*a(2)^2 - 8*r(1)*r(2));
[blue_profit_int, fin_profit_int] = maxFunctionInt(blue_pop_profit, fin_pop_profit, @(x,y)whaleProfit(a, r, K, x, y, prices));
max_profit = whaleProfit(a, r, K, blue_profit_int, fin_profit_int, prices);
display(sprintf('The total whale population will grow fastest when there are %d blue whales and %d fin whales.\nThe population will generate approximately $%.2f in profit per year',blue_profit_int, fin_profit_int, max_profit));
display(sprintf('These results come out to %.2f%% of the blue whale carrying capacity and %.2f%% of the fin whale carrying capacity.',100 * blue_profit_int / K(1), 100 * fin_profit_int / K(2)));

% Sensitivity of profit to blue whale population

% Sensitivity of profit to fin whale population

% More sensitivity


% Determining when it will be economically optimal to drive a species to
% extinction
pmaxx = 12000 * r1^2 * k1 * ((2 - r1) / 4);
pmaxy = 6000 * r2^2 * k2 * ((2 - r2) / 4);
syms alpha
cash = whaleProfit([alpha alpha], [r1 r2], [k1 k2], blueProfit, finProfit, [12000 6000]);
eqn1 = cash == pmaxx;
eqn2 = cash == pmaxy;
fin_alpha_max = double(solve(eqn1, alpha));
blue_alpha_max = double(solve(eqn2, alpha));
display(sprintf('As long as alpha is less than %.12f it is not optimal to drive fin whales to extinction.\nSimilarly, it alpha is less than %.12f it is not optimal to drive blue whales to extinction',fin_alpha_max, blue_alpha_max));

% Sensitivity analysis

