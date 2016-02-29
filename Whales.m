dx = @(x,y,r1,k1,a1) (r1*x.*(1-(x/k1)))-(a1*x.*y);
dy = @(x,y,r2,k2,a2) (r2*y.*(1-(y/k2)))-(a2*x.*y);


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
gradXY = @(x,y,r,k,a) dx(x,y,r(1),K(1),a(1))+dy(x,y,r(2),K(2),a(2));

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

% problem 7
profitplace = [12000; 6000].*r';
gradProfit = [24000*(r(1)/K(1)) (12000*a(1))+(6000*a(2)); (12000*a(1))+(6000*a(2)) 12000*(r(2)/K(2))];
popsToMaxProfit = gradProfit\profitplace;

% problem 11, max sustained profits
%if (popsToMaxProfit(1) < xmax || popsToMaxProfit(2) < ymax)
%    newXPop = ((2 * r(1) * k(1)) - 
%end

% Example call to sensitivity function using anonymous function:
sensitivity(@(x)dx(x, 100,r(1),K(1),a(1)), 500)
