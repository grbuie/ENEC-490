function [ n ] = annual_profile( monthly_data )

%number of years
%floor rounds down
total_months = length(monthly_data);
N = floor(total_months/12);

a_p = zeros(12,N);
for i = 1:N
    for j = 1:12
        a_p(j, i) = monthly_data((i-1)*12+j);
    end
end

new_N = 1997:1:2016;
start_year = find(new_N==2008);

n = a_p(:,start_year:end);
end

