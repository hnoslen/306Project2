%Whale pop and profit simulation
timestep = 1;
runLength = 100;

pops = [75000; 200000];
killRates = [75; 200];
whalePrice = [12000; 6000];

% Diff Eqs
dx = @(x,y,r1,k1,a1) (r1*x.*(1-(x/k1)))-(a1*x.*y);
dy = @(x,y,r2,k2,a2) (r2*y.*(1-(y/k2)))-(a2*x.*y);
change = @(p,r,k,a) [dx(p(1),p(2),r(1),k(1),a(1)); dy(p(1),p(2),r(2),k(2),a(2))];

iters = round(runLength/timestep);
popLog = zeros(iters,2);

r = [0.05 0.08];
K = [150000 400000];
a = [10^-8 10^-8];

profit = zeros(iters,1);
now = uint64(1);
while (now <= iters)
    popDelta = change(pops,r,K,a);
    
    %update kill rate
    killRates(:) = 0.9*change(pops,r,K,a);
    if any(killRates<0)
        killRates(:) = [0 0];
    end
    
    pops = pops+popDelta-killRates;
    popLog(now,:) = pops';
    
    profit(now) = sum(whalePrice.*killRates);
    
    if (~pops(1)||~pops(2))
        if (pops(1)<=0)&&(pops(2)<=0)
            pops(1) = 0;
            pops(2) = 0;
            break;
        elseif pops(1)<=0
            pops(1) = 0;
        else
            pops(2) = 0;
        end
    end
    display(sprintf('%d %d',pops(1),pops(2)))
    now = now+1;
end
plot(popLog(:,1))
hold on
plot(popLog(:,2),'r')
sum(profit)
figure
plot(profit)