% Whaling quota script
% A script to calculate optimal whaling quotas

% Input variables - Change these as needed
r = [0.05 0.08];% Intrinsic growth rates for blue and fin whales respectivly
K = [150000 400000];% Carrying capacities for blue and fin whales respectivly
a = [10^-8 10^-8];% Competition coefficient for blue and fin whales respectivly
prices = [12000 6000];% Market price for blue and fin whales respectivly

% The population of each whale must be less than carrying capacity
currentPopulation = [100000 300000];% current population of blue and fin whales respectivly

isconstrained = true;% Are there minimum desired populations?
constraints = [K(1)/2 K(2)/2];% what are the minimum desired populations?
simStep = 0.1;% steps between possible kill rates (smaller is more accurate but slower)


% Functions for use in the script - DO NOT ALTER
dx = @(x,y,r1,k1,a1) (r1*x.*(1-(x/k1)))-(a1*x.*y);
dy = @(x,y,r2,k2,a2) (r2*y.*(1-(y/k2)))-(a2*x.*y);
populationChange = @(p,r,k,a) [dx(p(1),p(2),r(1),k(1),a(1)); dy(p(1),p(2),r(2),k(2),a(2))];
profitFunc = @(x,y,r,k,a, priceVec) priceVec(1)*dx(x,y,r(1),k(1),a(1))+priceVec(2)*dy(x,y,r(2),k(2),a(2));
backupOptimum = @(coor,r,k,a,p) ((p(coor)*r(coor))-(k(coor)/2)*(p(1)*a(1)+p(2)*a(2)))/(2*p(coor)*(r(coor)/k(coor)));

% Calculate global profit maximum
profitplace = prices'.*r';
gradProfit = [2*prices(1)*(r(1)/K(1)) (prices(1)*a(1))+(prices(2)*a(2));...
              (prices(1)*a(1))+(prices(2)*a(2)) 2*prices(2)*(r(2)/K(2))];
popsToMaxProfit = gradProfit\profitplace;

% Which integer population gives highest profit?
possMaxs = [floor([popsToMaxProfit(1) popsToMaxProfit(2)]);...
    floor([popsToMaxProfit(1) popsToMaxProfit(2)])+1;...
    floor(popsToMaxProfit(1)) floor(popsToMaxProfit(2))+1;...
    floor(popsToMaxProfit(1))+1 floor(popsToMaxProfit(2))];

[~, I] =max(profitFunc(possMaxs(:,1),possMaxs(:,2),r,K,a,prices));

popsToMaxProfit = possMaxs(I,:)';

display(sprintf('Global maximum profit at:\n%d blue whales\n%d fin whales\n', popsToMaxProfit(1),popsToMaxProfit(2)))

% Check whether maximum obeys constraints and adjust accordingly
if (isconstrained&&any(popsToMaxProfit<constraints'))
    display(sprintf('Global max outside constraints, adjusting accordingly...\n'))
    
    % If we only violate one of the constraints, optimize the other
    if xor(popsToMaxProfit(1)<constraints(1),popsToMaxProfit(2)<constraints(2))
        if (popsToMaxProfit(1)<contraints(1))
            popsToMaxProfit(1) = backupOptimum(1,r,K,a,prices);
            popsToMaxProfit(2) = constraints(2);
        else
            popsToMaxProfit(2) = backupOptimum(2,r,K,a,prices);
            popsToMaxProfit(1) = constraints(1);
        end
    else
        % if both populations violate constraints
        popsToMaxProfit = constraints';
    end
    
    % Which integer population gives highest profit?
    possMaxs = [floor([popsToMaxProfit(1) popsToMaxProfit(2)]);...
                floor([popsToMaxProfit(1) popsToMaxProfit(2)])+1;...
                floor(popsToMaxProfit(1)) floor(popsToMaxProfit(2))+1;...
                floor(popsToMaxProfit(1))+1 floor(popsToMaxProfit(2))];

    [~, I] =max(profitFunc(possMaxs(:,1),possMaxs(:,2),r,K,a,prices));
    popsToMaxProfit = possMaxs(I,:)';
end
display(sprintf('Using maximum profit point found at:\n%d blue whales\n%d fin whales\n', popsToMaxProfit(1),popsToMaxProfit(2)))

harvest = zeros(1,2); % matrix to store values to harvest this year

% Calculate how populations will change this year
thisYear = populationChange(currentPopulation,r,K,a);

% Where are current populations relative to desired levels?
if currentPopulation(1)>popsToMaxProfit(1)
    % Harvest enough to end the year at the population that maximizes
    % profit
    harvest(1) = currentPopulation(1)+thisYear(1)-popsToMaxProfit(1);
elseif currentPopulation(1)==popsToMaxProfit(1)
    % Harvest at the growth rate
    harvest(1) = thisYear(1);
end

% Where are current populations relative to desired levels?
if currentPopulation(2)>popsToMaxProfit(2)
    % Harvest enough to end the year at the population that maximizes
    % profit
    harvest(2) = currentPopulation(2)+thisYear(2)-popsToMaxProfit(2);
elseif currentPopulation(2)==popsToMaxProfit(2)
    % Harvest at the growth rate
    harvest(2) = thisYear(2);
end

if any((currentPopulation<popsToMaxProfit'))
    % Decide how much to hunt by running simulation
    display(sprintf('Running simulation to find best course of action...\n'))
    records = zeros(1,3);
    record_inc = 1;
    for startingKill = 0:simStep:0.99
        timestep = 1;
        pops = currentPopulation';
        profit = 0;
        yearsToProfitPoint = 0;
        while true
            popDelta = populationChange(pops,r,K,a);
            killRates = startingKill*popDelta;
            if killRates(1)<0
                killRates(1) = 0;
            end
            if killRates(2)<0
                killRates(2) = 0;
            end
            
            pops = pops+popDelta-killRates;
            profit = profit + sum(prices'.*killRates);
            yearsToProfitPoint= yearsToProfitPoint + 1;
            if all(pops>=popsToMaxProfit)
                break;
            end
        end
        records(record_inc, 1) = startingKill;
        records(record_inc, 2) = profit;
        records(record_inc, 3) = yearsToProfitPoint;
        record_inc = record_inc +1;
    end
    
    missedTimeAtMaximum = records(:,3)-records(1,3);
    missedProfit = profitFunc(popsToMaxProfit(1),popsToMaxProfit(2),r,K,a,prices)*missedTimeAtMaximum;
    
    display(sprintf('Harvest Fraction'))
    display(sprintf('    of Growth\t\tProfit\t\tProfit if Wait \n'))
    
    for n = 1:size(records,1)
        display(sprintf('    %.2f\t\t%.2f\t\t%.2f\n', records(n,1), records(n,2), missedProfit(n,1)))
    end
    
    profitDifference = missedProfit-records(:,2);
    [~,I] = max(profitDifference);
    display(sprintf('The optimal strategy is to:'))
    if profitDifference(I)>=0
        harvest = zeros(1,2);
        display(sprintf('Wait for populations to recover. This will take %d years',records(1,3)))
    else
        harvest = records(I,1)*thisYear;
        display(sprintf('Harvest whales at %f.2 times the growth rate',records(I,1)))
    end
end
display(sprintf('In order to maximize profit quotas should be set at:\n%d blue whales\n%d fin whales',harvest(1),harvest(2)))
display(sprintf('This will produce a profit of $%.2f this year',sum(prices.*harvest)))
