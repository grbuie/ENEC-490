sheet = 'Data 1';
range = 'B:B';
gasPrices = xlsread("MonthlyGasPrices.xlsx",sheet,range);
avgGasPrice = sum(gasPrices)/length(gasPrices);
disp(avgGasPrice);

csvwrite("monthly_average_price.xlsx",avgGasPrice);
