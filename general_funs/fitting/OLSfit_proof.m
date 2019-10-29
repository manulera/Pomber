%% Linear data with noise
xx = rand(1,100)*100;
yy = 3*xx + rand(1,100)*15-7.5;

% Function
f = @(x,a) a*x;

pred_a = OLSfit(xx,yy,f,[3],'Robust');

figure
scatter(xx,yy)
hold on
plot(xx,f(xx,pred_a))



