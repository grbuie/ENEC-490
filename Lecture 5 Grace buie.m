%Read 2015 electricity demand data
data = csvread('hourly-day-ahead-bid-data-2015.csv',5,1);
vector = mat2vec(data);

%Read 2014 electricity demand data
bizarre_data = csvread('bizarre_data.csv');

%Pre-process Data
processed_data = pre_processor(bizarre_data);

candidates = find(processed_data > 130000);
index = candidates(find(candidates>7000))
day = floor(index/24);
hour = index - day*24;
answer = [day hour]

%histogram
figure;
histogram(processed_data,100); 
xlabel('Demand (MWh)','FontSize', 14)
ylabel('Frequency','FontSize', 14)
title('Pre-processed 2014 Data', 'FontSize',14)


%qqplot
figure; 
qqplot(processed_data); 
xlabel('Theoretical Normal Quantiles','FontSize',14)
ylabel('Empirical Data Normal Quantiles','FontSize',14)
title('QQ Plot of Pre-Processed Demand Data','FontSize',14)

%log transformation
transformed_data = log(processed_data); 

%histogram
figure; 
histogram(transformed_data,100); 
xlabel('log-Demand (MWh)','FontSize', 14)
ylabel('Frequency','FontSize', 14)
title('Log-Transformed 2014 Data', 'FontSize',14)


%qqplot
figure;
qqplot(transformed_data);
xlabel('Theoretical Normal Quantiles','FontSize',14)
ylabel('Empirical Data Normal Quantiles','FontSize',14)
title('QQ Plot of Log-Transformed Demand Data','FontSize',14)

%mean
mu = mean(processed_data); 
dev = std(processed_data); 

%number of standard deviations weird point is away from mean
number_stds = (processed_data(index) - mu)/dev;

window= 700;
num_hours = length(processed_data);

%mean
for i = window/2 + 1:num_hours-window/2
    window_vector = [window,1];
    for j = i-350:i+350
        window_vector(j,1) = processed_data(j,1);
    end
    window_mean = mean(window_vector);
end

%stddev
for i = window/2 + 1:num_hours-window/2
    window_vector = [window,1];
    for j = i-350:i+350
        window_vector(j,1) = processed_data(j,1);
    end
    window_std = std(window_vector);
end

%find ouliers
if processed_data(i) >= window_mean + 3*window_std | processed_data(i) <= window_mean - 3*window_std
        outliers(i) = 1;
    else
        outliers(i) = 0;
end


%Data Mining
% 1.
days = floor(length(processed_data)/24);
day_peaks = zeros(days,1);
for i = 1:days
    for j = 1:24
        day = zeros(24,1);
        day(j,1) = processed_data(((i-1)*24)+j);
    end
      day_peak = max(day);
      day_peaks(i,1) = day_peak;
end

%2.
tempdata = csvread('tempdata.csv',0,1);

%3. 
figure;
scatter(tempdata,day_peaks);

