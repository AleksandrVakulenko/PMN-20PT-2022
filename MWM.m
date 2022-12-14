

file_number = 100;
folder = "Output 2022_10_06/";

Sample.H = 85e-6; %m
Sample.S = 0.29/1000^2; %m^2
Sample.Gain = 20;

for i = 1:35
    try
        filename = [num2str(file_number, '%04u') '_' num2str(i, '%01u') '.txt'];
        file_addr = [char(folder) filename];
        Input_data = Read_file(file_addr);
    catch
        filename = [num2str(file_number, '%05u') '_' num2str(i, '%02u') '.txt'];
        file_addr = [char(folder) filename];
        Input_data = Read_file(file_addr);
    end
    
    Data(i) = Unpack_data(Input_data, Sample);
end


%%

figure
hold on
ylim([-10 80])

Ps = [];
for i = 1:35
    plot(Data(i).field, Data(i).polarization)
    drawnow
%     pause(0.1)
    
    Ps(i) = Data(i).polarization(end/2);
    
end



figure
plot(Ps(2:end)/max(Ps(2:end)))
ylim([0 1])
set(gca, 'fontsize', 14)






