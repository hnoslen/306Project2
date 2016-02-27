function [ prof ] = whaleProfit( a,r,k,x,y,p)
%profit computes the whaling industry's profit given a certain whale
%population
%   Assumes whales are harvested at the same rate they grow, and uses price
%   parameters to determine profit.

prof = p(1) * growthRate(a, r, k, x, y, 1) + p(2) * growthRate(a, r, k, x, y, 2);
end

