
addpath('include');

clc

% figure
hold on

%



filename = '3006.txt';

Input_data = Read_file(['Output/' filename]);

Data = Unpack_data(Input_data);

V = Data.voltage(1:end/2);
I = Data.current(1:end/2)*1e9;

if Data.mode == "E-I"
    plot(Data.voltage(1:end/2), Data.current(1:end/2)*1e9, '-', 'linewidth', 3)
    xlabel("Voltage, V")
    ylabel("Current, nA")
end

% title([filename '  T = ' num2str(Data.period) ' s']);
% xlim([-1000 1000])
% % ylim([-0.2 0.2])


















%%

clc

ch1m = mean(Input_data.ch1)*1e6
% std(Input_data.ch1)*1e6


ch2m = mean(Input_data.ch2)*1e6
% std(Input_data.ch2)*1e6

hold on
plot(Input_data.ch1*1e6, Input_data.ch2*1e6, '-x', 'linewidth', 3)
plot(ch1m, ch2m,'x')

xlim([-2000 2000])
ylim([-2000 2000])




%%



plot(Input_data.time, Input_data.ch1, '-x')













































