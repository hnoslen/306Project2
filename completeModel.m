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
display(sprintf('The total whale population will grow fastest when there are %d blue whales and %d fin whales',blue_pop_int, fin_pop_int));

% Sensitivity of total population growth rate to blue whale population
sensitivity(@(x)(dx(x,fin_pop_max_growth_rate,r(1),K(1),a(1)) + dy(x,fin_pop_max_growth_rate,r(2),K(2),a(2))), blue_pop_max_growth_rate)
% Sensitiviy of total population growth rate to fin whale population
sensitivity(@(y)(dy(blue_pop_max_growth_rate,y,r(2),K(2),a(2)) + dx(blue_pop_max_growth_rate,y,r(1),K(1),a(1))), fin_pop_max_growth_rate)

% Will driving whales to extinction improve growth rates??
% TODO


% Total population of whales
% TODO
% also sensitivity


