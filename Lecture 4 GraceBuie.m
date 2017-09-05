%1
%Load data from Excel
[data text combined] = xlsread('monthly_demandNC.xlsx');

%2
%annual profile
d = annual_profile(data); 

%3
%year on year differences
[months,years] = size(d);
differences = zeros(months,years-1);

for i = 1:12
    for j = 1:years-1
        differences(i,j) = (d(i,j+1) - d(i,j))/d(i,j);
    end
end

%create new figure
figure; 
hold on;

%plot function within for loop
for i  = 1:12
    plot(differences(i,:)*100,'color',rand(1,3));
end

xlabel('Year','FontSize',14);
set(gca, 'XTickLabel',{'1998','2000','2002','2004','2006','2008','2010','2012','2014'});
set(gca,'XTick',1:2:18);
ylabel('Demand Growth (%)','FontSize',14);
legend('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

%4
%annual demand percentages
totals = sum(d);
monthly_fractions = zeros(months,years);
for i = 1:years
    monthly_fractions(:,i) = d(:,i)/totals(i);
end

%create new figure
figure; 
hold on;

%plot function within for loop
for i  = 1:12
    plot(monthly_fractions(i,:)*100,'color',rand(1,3));
end

xlabel('Year','FontSize',14);
set(gca, 'XTickLabel',{'1998','2000','2002','2004','2006','2008','2010','2012','2014'});
set(gca,'XTick',1:2:18);
ylabel('% of Total Annual Demand','FontSize',14);
legend('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Location','northwest');

%Simulation

%5.
%bootstrapping
num_years = 10;
bootstrap_sample = zeros(12*num_years,1);
for i = 1:num_years
    for j = 1:12
    s = ceil(years*rand(1));
    bootstrap_sample((i-1)*12+j) = d(j,s);
    end
end

figure;
%bootstrap sample
subplot(2,2,1);
plot(bootstrap_sample);
xlabel('Year','FontSize',14);
ylabel('Demand (MWh)','FontSize',14);

%autocorrelation
subplot(2,2,2);
autocorr(bootstrap_sample);
xlabel('Months','FontSize',14);
ylabel('Autocorrelation','FontSize',14);

%6
%Monte Carlo resampling
monteCarlo_sample = zeros(12*num_years,1);
random = randn((num_years*12),1);
for i = 1:num_years*12
    r = random(i,1);
    if r < 0
        r = r * -1;
    end
    random(i,1) = r;
end

for i = 1:num_years
    for j = 1:12
    s = ceil(random((i-1)*12+j));
    monteCarlo_sample((i-1)*12+j) = d(j,s);
    end
end

figure;
%Monte Carlo sample
subplot(2,2,1);
plot(monteCarlo_sample);
xlabel('Months','FontSize',14);
ylabel('Demand (MWh)','FontSize',14);

%autocorrelation
subplot(2,2,2);
autocorr(monteCarlo_sample);
xlabel('Year','FontSize',14);
ylabel('Autocorrelation','FontSize',14);

%the resulting sample is more regular with a smaller variance than the
%bootstrapping sample

%7
% I think that the labels for month and year were switched on the
% bootstrapping example, so I switched them for the Monte Carlo example and
% this answer is based on the switched labels. The autocorrelation seems to match
% historical data well, showing how the demand changes from months of high
% demand to months of low demand and vice versa with positive and negative correlations.
% The two methods seem to be very similar, with Monte Carlo showing
% slightly stronger negative auto correlations than bootstrapping. 
