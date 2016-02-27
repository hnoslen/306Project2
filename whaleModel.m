% Model to analyze the whaling industry

% Initialize vectors of population characteristics and whale prices
alphaVec = [10^(-8), 10^(-8)];
kVec = [150000, 400000];
rVec = [.05,.08];
priceVec = [12000,6000];

whaleProfit (alphaVec, rVec, kVec, kVec(1) / 2, 0, priceVec)
growthRate (alphaVec, rVec, kVec, kVec(1) / 2, 0, 1)
