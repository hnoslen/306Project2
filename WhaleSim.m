%Whale pop and profit simulation
timestep = 1;
runLength = 10000;

pops = uint64([75000; 200000]);
killRates = uint64([75; 200]);
whalePrice = uint64([12000; 6000]);

% Diff Eqs
dx = @(x,y,r1,k1,a1) (r1*x.*(1-(x/k1)))-(a1*x.*y);
dy = @(x,y,r2,k2,a2) (r2*y.*(1-(y/k2)))-(a2*x.*y);
change = @(p,r,k,a) [dx(p(1),p(2),r(1),k(1),a(1)); dy(p(1),p(2),r(2),k(2),a(2))];

iters = round(runLength/timestep);
popLog = uint64(zeros(iters,2));

r = [0.05 0.08];
K = [150000 400000];
a = [10^-8 10^-8];

profit = 0;
now = uint64(1);
while (now <= iters)
    popDelta = uint64(round(change(pops,r,K,a)));
    pops = pops+popDelta-killRates;
    popLog(now,:) = pops';
    
    profit = profit+sum(whalePrice.*killRates);
    
    if sum(pops)<=0
        break;
    end
    display(sprintf('%d %d',pops(1),pops(2)))
    now = now+1;
end
plot(popLog(:,1))
hold on
plot(popLog(:,2),'r')