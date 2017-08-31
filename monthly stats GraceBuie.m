function [ stats ] = monthly_stats( monthly_data )

data = annual_profile(monthly_data);

%create matrix
stats = zeros(12,2);
for i = 1 
    for j = 1:12
    stats(j,i) = mean(data(j,1:end));
    end
end
for i = 2
    for j = 1:12
        stats(j,i) = std(data(j,1:end));
    end
end
