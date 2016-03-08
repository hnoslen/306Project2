records = zeros(1,5);
record_inc = 1;
for startingpop = 0.1:0.05:0.45
    for startingKill = 0:0.1:0.9

        close all
        %Whale pop and profit simulation
        timestep = 1;
        runLength = 500;

        r = [0.05 0.08];
        K = [150000 400000];
        a = [10^-8 10^-8];
        halfK = true;

        pops = startingpop*K';% Starting population
        whalePrice = [12000; 6000];
        killRates = zeros(2,1);%[2000; 8000];% Starting rates
        killRatesStart = startingKill*ones(2,1);

        % Diff Eqs
        dx = @(x,y,r1,k1,a1) (r1*x.*(1-(x/k1)))-(a1*x.*y);
        dy = @(x,y,r2,k2,a2) (r2*y.*(1-(y/k2)))-(a2*x.*y);
        change = @(p,r,k,a) [dx(p(1),p(2),r(1),k(1),a(1)); dy(p(1),p(2),r(2),k(2),a(2))];
        profitFunc = @(x,y,r,k,a, priceVec) priceVec(1)*dx(x,y,r(1),k(1),a(1))+priceVec(2)*dy(x,y,r(2),k(2),a(2));

        % Calculate max point
        profitplace = [12000; 6000].*r';
        gradProfit = [24000*(r(1)/K(1)) (12000*a(1))+(6000*a(2)); (12000*a(1))+(6000*a(2)) 12000*(r(2)/K(2))];
        popsToMaxProfit = gradProfit\profitplace;

        possMaxs = [floor([popsToMaxProfit(1) popsToMaxProfit(2)]);...
            floor([popsToMaxProfit(1) popsToMaxProfit(2)])+1;...
            floor(popsToMaxProfit(1)) floor(popsToMaxProfit(2))+1;...
            floor(popsToMaxProfit(1))+1 floor(popsToMaxProfit(2))];

        [~, I] =max(profitFunc(possMaxs(:,1),possMaxs(:,2),r,K,a,whalePrice));

        popsToMaxProfit = possMaxs(I,:);

        % Make sure we are above constraint if necessary, and if so change point
        if (halfK&&any(popsToMaxProfit<(0.5*K)))
            display(sprintf('Global max outside constraints, adjusting accordingly...\n'))
            possMaxs = [K(1)/2 (K(2)/(2*r(1)))*(r(2)-(2*a(1)+a(2))*(K(1)/2));...
                        (K(1)/2)*(1-(2*a(1)+a(2))*(K(2)/(4*r(1)))) K(2)/2];
            [~, I] =max(profitFunc(possMaxs(:,1),possMaxs(:,2),r,K,a,whalePrice));
            popsToMaxProfit = possMaxs(I,:);

            if any(popsToMaxProfit<(0.5*K))
                popsToMaxProfit = K/2;
            end
        end

        iters = round(runLength/timestep);
        popLog = zeros(iters+1,2);
        popLog(1,:) = pops';

        killRateRecord = zeros(iters,2);
        profit = zeros(iters,1);
        now = uint64(1);

        transitionProfit = 0;
        transitionYears = 0;

        while true
            popDelta = change(pops,r,K,a);

            %update kill rate
%             if pops(1)>popsToMaxProfit(1)
%                 killRates(1) = max(popDelta(1),pops(1)-popsToMaxProfit(1));        
%             elseif pops(1)==popsToMaxProfit(1)
%                 killRates(1) = popDelta(1);
%             else
%                 killRates(1) = killRatesStart(1)*popDelta(1);
%             end
% 
%             if pops(2)>popsToMaxProfit(2)
%                 killRates(2) = max(popDelta(2),pops(2)-popsToMaxProfit(2));
%             elseif pops(2)==popsToMaxProfit(2)
%                 killRates(2) = popDelta(2);
%             else
%                 killRates(2) = killRatesStart(2)*popDelta(2);
%             end
% 
            killRates = killRatesStart.*popDelta;
            if killRates(1)<0
                killRates(1) = 0;
            end
            if killRates(2)<0
                killRates(2) = 0;
            end
            
            
            pops = pops+popDelta-killRates;
            killRatesRecords(now,:) = killRates;
            popLog(now,:) = pops';

            profit(now) = sum(whalePrice.*killRates);

%             if (killRates(1)<popDelta(1) || killRates(2)<popDelta(2))
%                 transitionProfit = transitionProfit + profit(now);
%                 
%             end

            if any(pops<1)
                if (pops(1)<=0)&&(pops(2)<=0)
                    pops(1) = 0;
                    pops(2) = 0;
                    break;
                elseif pops(1)<=0
                    pops(1) = 0;
                    killRates(1)=0;
                else
                    pops(2) = 0;
                    killRates(2)=0;
                end
            end
            if all((pops<1))killRates(1)=0;
                break;
            end
            if all(pops>=(0.5*K'))
                break;
            end
            transitionYears = transitionYears + 1;
            %display(sprintf('%d %d',pops(1),pops(2)))
            now = now+1;
        end
        profit(now) = sum(whalePrice.*killRates);
        popLog(now,:) = pops';

        %display(sprintf('In transition, the whaling industry averaged $%.2f per year over %d years', transitionProfit / transitionYears, transitionYears));

        %hold on
        %plot(popLog(:,1))
        %plot(popLog(:,2),'r')
        %plot((K(1)/2)*ones(iters,1),'b--')
        %plot((K(2)/2)*ones(iters,1),'r--')
        %hold off

        records(record_inc, 1) = startingpop;
        records(record_inc, 2) = startingKill;
        records(record_inc, 3) = sum(profit(1:transitionYears))/transitionYears;
        records(record_inc, 4) = sum(profit(1:transitionYears));
        records(record_inc, 5) = transitionYears;
        record_inc = record_inc +1;
        %figure
        %plot(profit(1:transitionYears))
    end
end
profit(now) = sum(whalePrice.*killRates);
popLog(now,:) = pops';

display(sprintf('In transition, the whaling industry averaged $%.2f per year over %d years', transitionProfit / transitionYears, transitionYears));

hold on
plot(popLog(:,1))
plot(popLog(:,2),'r')
plot((K(1)/2)*ones(iters,1),'b--')
plot((K(2)/2)*ones(iters,1),'r--')
hold off

sum(profit)
figure
plot(profit)
