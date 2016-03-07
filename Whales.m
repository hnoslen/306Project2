dx = @(x,y,r1,k1,a1) (r1*x.*(1-(x/k1)))-(a1*x.*y);
dy = @(x,y,r2,k2,a2) (r2*y.*(1-(y/k2)))-(a2*x.*y);
gradXY = @(x,y,r,K,a) dx(x,y,r(1),K(1),a(1))+dy(x,y,r(2),K(2),a(2));

profitFunc = @(x,y,r,k,a, priceVec) priceVec(1)*dx(x,y,r(1),k(1),a(1))+priceVec(2)*dy(x,y,r(2),k(2),a(2));
%both = @(x,y,r,k,a) dx(x,y,r(1),k(1),a(1))+dy(x,y,r(2),k(2),a(2));

xsteps = 50;
ysteps = 50;

r = [0.05 0.08];
K = [150000 400000];
a = [10^-8 10^-8];
prices = [12000 6000];

xmax = 1*K(1);
ymax = 1*K(2);

[x, y] = meshgrid(0:(xmax/xsteps):xmax,ymax:-(ymax/ysteps):0);

gradX = dx(x,y,r(1),K(1),a(1));
gradY = dy(x,y,r(2),K(2),a(2));

% prob prob 1
%surf(gradX+gradY)
gradsmat = [2*r(1)/K(1) a(1)+a(2); a(1)+a(2) 2*r(2)/K(2)];
maxspot = gradsmat\r';
x=[floor(maxspot(1)); floor(maxspot(1))+1; floor(maxspot(1)); floor(maxspot(1))+1];
y=[floor(maxspot(2)); floor(maxspot(2))+1; floor(maxspot(2))+1; floor(maxspot(2))];
nearvals = gradXY(x,y,r,K,a);


%quiver(x,y,gradX,gradY)
% hold on
% magnit = ((x.^2)+(y.^2)).^0.5;
% contour(x,y,magnit)
% hold off

% problem 4
f1 = @(r1,a1,k1,x) (r1/a1)*(1-(x/k1));
f2 = @(r2,a2,k2,x) k2*(1-(a2/r2)*x);
x = 0:150000;

y1 = f1(r(1),a(1),K(1),x);
y2 = f2(r(2),a(2),K(2),x);

xlim = @(r,k,a) (((r(1)*r(2))/K(2))-(a(1)*r(2)))/(((r(1)*r(2))/(K(1)*K(2)))-(a(1)*a(2)));
ylim = @(r,k,a) (((r(1)*r(2))/K(1))-(a(2)*r(1)))/(((r(1)*r(2))/(K(1)*K(2)))-(a(1)*a(2)));
xlimVal = xlim(r,K,a);
ylimVal = ylim(r,K,a);
fig = figure;
hax = axes;
hold on
plot(y1)
plot(y2)
plot(ylimVal*ones(1,length(y1)), 'r')
line([xlimVal xlimVal],get(hax,'YLim'),'Color',[1 0 0])


% problem 7
profitplace = [12000; 6000].*r';
gradProfit = [24000*(r(1)/K(1)) (12000*a(1))+(6000*a(2)); (12000*a(1))+(6000*a(2)) 12000*(r(2)/K(2))];
popsToMaxProfit = gradProfit\profitplace




% Example call to sensitivity function using anonymous function:
%sensitivity(@(x)dx(x, 100,r(1),K(1),a(1)), 500)

% Problem 4 max-value
zerXPos = @(y,r,k,a) (k(1)*(r(1) - sum(a)*y + ((k(1)*k(2)*sum(a)^2*y.^2 - 2*k(1)*k(2)*sum(a)*r(1)*y + k(1)*k(2)*r(1)^2 - 4*r(2)*r(1)*y.^2 + 4*k(2)*r(2)*r(1)*y)./(k(1)*k(2))).^(1/2)))./(2*r(1));
zerXNeg = @(y,r,k,a) -(k(1)*(sum(a)*y - r(1) + ((k(1)*k(2)*sum(a)^2*y.^2 - 2*k(1)*k(2)*sum(a)*r(1)*y + k(1)*k(2)*r(1)^2 - 4*r(2)*r(1)*y.^2 + 4*k(2)*r(2)*r(1)*y)./(k(1)*k(2))).^(1/2)))./(2*r(1));
zerX = @(y,r,k,a) zerXPos(y,r,k,a);% zerXNeg(y,r,k,a)];

% d(foundx)/dy = (k ((a^2 y)/(2 r)-a/2)+s (1-(2 y)/l))/sqrt((k l (a^2 y^2-2 a r y)-r (4 s y (y-l)-k l r))/(k l))-(a k)/(2 r)

% max y = (l*(2*r*(r*s*(k*r + l*s - a*k*l)*(k*s + l*r - a*k*l))^(1/2) + 2*k*r*s^2 + 2*l*r^2*s - a*k*(r*s*(k*r + l*s - a*k*l)*(k*s + l*r - a*k*l))^(1/2) - a*k*l*r^2 - a*k^2*r*s + a^2*k^2*l*r - 2*a*k*l*r*s))/(a^3*k^2*l^2 - a^2*k^2*l*s - a^2*k*l^2*r - 4*a*k*l*r*s + 4*k*r*s^2 + 4*l*r^2*s)
% or -(l*(2*r*(r*s*(k*r + l*s - a*k*l)*(k*s + l*r - a*k*l))^(1/2) - 2*k*r*s^2 - 2*l*r^2*s - a*k*(r*s*(k*r + l*s - a*k*l)*(k*s + l*r - a*k*l))^(1/2) + a*k*l*r^2 + a*k^2*r*s - a^2*k^2*l*r + 2*a*k*l*r*s))/(a^3*k^2*l^2 - a^2*k^2*l*s - a^2*k*l^2*r - 4*a*k*l*r*s + 4*k*r*s^2 + 4*l*r^2*s)

maxYPos = @(r,s,k,l,a) (l*(2*r*(r*s*(k*r + l*s - a*k*l)*(k*s + l*r - a*k*l))^(1/2) + 2*k*r*s^2 + 2*l*r^2*s - a*k*(r*s*(k*r + l*s - a*k*l)*(k*s + l*r - a*k*l))^(1/2) - a*k*l*r^2 - a*k^2*r*s + a^2*k^2*l*r - 2*a*k*l*r*s))/(a^3*k^2*l^2 - a^2*k^2*l*s - a^2*k*l^2*r - 4*a*k*l*r*s + 4*k*r*s^2 + 4*l*r^2*s);
maxYNeg = @(r,s,k,l,a) -(l*(2*r*(r*s*(k*r + l*s - a*k*l)*(k*s + l*r - a*k*l))^(1/2) - 2*k*r*s^2 - 2*l*r^2*s - a*k*(r*s*(k*r + l*s - a*k*l)*(k*s + l*r - a*k*l))^(1/2) + a*k*l*r^2 + a*k^2*r*s - a^2*k^2*l*r + 2*a*k*l*r*s))/(a^3*k^2*l^2 - a^2*k^2*l*s - a^2*k*l^2*r - 4*a*k*l*r*s + 4*k*r*s^2 + 4*l*r^2*s);
maxY = @(r,k,a) [maxYPos(r(1),r(2),k(1),k(2),sum(a)) maxYNeg(r(1),r(2),k(1),k(2),sum(a))];

y= 0:K(2);
plot(y,zerX(y,r,K,a))

intersectOLines = @(r,k,a) [(((r(1)*r(2))/k(2))-a(1)*r(2)) (((r(1)*r(2))/k(1))-a(2)*r(1))]/(((r(1)*r(2))/(k(1)*k(2)))-(a(1)*a(2)));

% xmax = @(r,K,a) (r(2)-(r(1)/(a(1)*K(1)*K(2))))/(a(2)+(r(1)/(a(1)*K(1)*K(2))));
% ymax = @(xmax,r,k,a) (r(1)/a(1))*(1-(xmax/k(1)));


