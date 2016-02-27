function [ rate ] = growthRate( a, r, k, x, y, species )
%growthRate computes growth rate of given whale species
%  for species parameter, 1 indicates blue whales, 2 indicates fin whales

if (species == 1)
    rate = r(1) * x * (1 - (x / k(1))) - a(1) * x * y;
elseif (species == 2) 
    rate = r(2) * y * (1 - (y / k(2))) - a(2) * x * y;
end

end

