
addpath('include');

clc

% figure
hold on

%

% Add Sample info
Sample.H = 40e-6; %m
Sample.S = 500e-6 * 250e-6; %m^2

Gain = 20;

% filename = '1060.txt';


N = 26;

filename = [num2str(N, '%04u') '.txt'];

Input_data = Read_file(['2022_07_01/' filename]);

Data = Unpack_data(Input_data, Sample);


if Data.mode == "E-P"
%     plot(Data.field*Gain, Data.polarization)
    plot(Data.voltage*Gain, Data.polarization)
    xlabel("Field, kV/cm")
    ylabel("Polarization, uC/cm2")
    xline(0)
end

if Data.mode == "E-I"
    plot(Data.field*Gain, Data.current*1e6*Data.period, '-', 'linewidth', 3)
    xlabel("Field, kV/cm")
    ylabel("Normalized Current, uA∙s")
end

title([filename '  T = ' num2str(Data.period) ' s']);
% xlim([-1000 1000])
% ylim([-0.2 0.2])
% Data.period


%%



figure
plot(Input_data.ch1, Input_data.ch2, 'x')
xlim([-0.005 0.005])
ylim([-0.005 0.005])
yline(0)
xline(0)


%%
addpath('include');

clc

figure
hold on

%

% Add Sample info
Sample.H = 40e-6; %m
Sample.S = 500e-6 * 250e-6; %m^2

Gain = 20;

% filename = '1060.txt';


for N = 34:43%[16:18 23 33]

filename = [num2str(N, '%04u') '.txt'];

Input_data = Read_file(['2022_07_01/' filename]);

Data = Unpack_data(Input_data, Sample);


if Data.mode == "E-P"
%     plot(Data.field*Gain, Data.polarization - mean(Data.polarization))
plot(Data.voltage*Gain, Data.polarization - mean(Data.polarization))
    xlabel("Field, kV/cm")
    ylabel("Polarization, uC/cm2")
    xline(0)
end

% if Data.mode == "E-I"
%     plot(Data.field*Gain, Data.current*1e6*Data.period, '-', 'linewidth', 3)
%     xlabel("Field, kV/cm")
%     ylabel("Normalized Current, uA∙s")
% end

% title([filename '  T = ' num2str(Data.period) ' s']);
% xlim([-1000 1000])
% ylim([-0.2 0.2])
% Data.period
end
