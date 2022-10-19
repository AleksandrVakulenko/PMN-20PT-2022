clc
% cd("F:\_OneDrive\YandexDisk\YandexDisk\Компьютер MAINHOMEPC\OneDrive - Personal\_RF\_Проекты\Temp-FEloop\Matlab2");
addpath('include');


folder = "Output 2022_10_06/";


Sample.H = 85e-6; %m
Sample.S = 0.29/1000^2; %m^2
Sample.Gain = 20;

Save_pics = false;


figure('position', [536 363 747 570])
hold on

Temp_out = [];
Freq_out = [];
Span_out = [];
Coercive_p_out = [];
Coercive_n_out = [];
Eps_out = [];
Res_out = [];
k = 0;
for file_number = 20:38%[17 16 15 14 13 12 6 7 8 9 10 11]
    feloop = open_dwm_fe_loop(Sample, folder, file_number, 'align');
    
    
    
    % FIXME: find switch uniform
    
    E = feloop.E.p(1:end/2);
    P = feloop.P.p(1:end/2);
    time = feloop.ref.time.p(1:end/2);
    
    k = k + 1;
    feloop_out(k) = feloop;
    Freq_out(k) = round(1/(2*feloop.period)*1000)/1000;
    
    Size = size(time, 1);
    Med_size = round(Size*0.00045);
    Move_size = round(Size*0.0045);
    if Med_size == 0
        Med_size = 1;
    end
    if Move_size == 0
        Move_size = 1;
    end
    
    E = medfilt1(E, Med_size);
    E = movmean(E, Move_size);
    P = medfilt1(P, Med_size);
    P = movmean(P, Move_size);
    
    Current = diff(P)./diff(time);
    Current = medfilt1(Current, Med_size);
    Current = movmean(Current, Move_size);
    Current(Current<0) = 0;
    
%     cla
    plot(E(1:end-1), Current*feloop.period);
%     plot(time,'.');
    
    ylabel('P, uC/cm^2', 'FontSize', 14)
    xlabel('E, kV/cm', 'FontSize', 14)
    title(['T = ' num2str(Freq_out(k)) ' Hz'], 'FontSize', 18)
%     title(['|' num2str(file_number) '| T = ' num2str(feloop.temp) ' C'], 'FontSize', 18)
    grid on
    
    if Save_pics
        pic_folder = [char(folder) '../pictures/'];
        pic_filename = [pic_folder num2str(file_number, '%04u') '.png'];
        if ~exist(pic_folder, 'dir')
            mkdir(pic_folder);
        end
        saveas(gcf, pic_filename);
    end
    
    drawnow
    pause(0.1)
    
end

clearvars E P Span Coercive max_file_number
clearvars pic_folder pic_filename k file_number folder