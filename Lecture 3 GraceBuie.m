%import data
naturalGasPrices = xlsread("Monthly Natural Gas Prices.xlsx","Data 1",'B4:B250');

% % 2. call annual_profile function
ap = annual_profile(naturalGasPrices);
[months,years] = size(ap);

% % 3. create figure
figure;
hold on;
for i = 1:years
    plot(ap(:,i),'color',rand(1,3));   
end

% %figure parameters
xlabel('Month','FontSize',14);
set(gca, 'XTickLabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});
set(gca,'XTick',1:1:12);
ylabel('Natural Gas Price ($/MMBtu)','FontSize',14);
legend('2008','2009','2010','2011','2012','2013','2014','2015','2016');

%Statistics
%2. call monthly stats
ms = monthly_stats(naturalGasPrices);
disp(ms);

%3. create random sample
%april
aprilrand = ms(4,2)*randn(1000,1) + ms(4,1);

%january
janrand = ms(1,2)*randn(1000,1) + ms(1,1);

%4. create histogram 
figure;
histogram(aprilrand);
histogram(janrand);

%the histogram has a binomial distribution when the two months are plotted
%on the same figure 
