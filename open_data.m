
clc

load('All_data.mat')

figure
hold on


for i = 1:12
    
    Data = output{i};
       
    
    plot(Data.field, Data.current*1e6*Data.period, '-', 'linewidth', 3)
    xlabel("Field, kV/cm")
    ylabel("Normalized Current, uA∙s")
    xlim([-1000 1000])
    
end


clearvars i Data


