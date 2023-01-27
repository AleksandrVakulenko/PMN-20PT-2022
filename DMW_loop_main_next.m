clc
% cd("F:\_OneDrive\YandexDisk\YandexDisk\Компьютер MAINHOMEPC\OneDrive - Personal\_RF\_Проекты\Temp-FEloop\Matlab2");
addpath('include');


folder = "Output 2022_10_06/";

% PMN-20PT
% Sample.H = 85e-6; %m
% Sample.S = 0.29/1000^2; %m^2
% Sample.Gain = 20;

% PZT
Sample.H = 35e-6; %m
Sample.S = 450e-6 * 280e-6; %m^2
Sample.Gain = 20;

Save_pics = false;


figure('position', [536 363 747 570])
hold on

Temp_out = [];
Freq_out = [];
Span_out = [];
Coercive_p_out = [];
Coercive_n_out = [];
k = 0;
for file_number = 430:448%20:38%[17 16 15 14 13 12 6 7 8 9 10 11]
    feloop = open_dwm_fe_loop(Sample, folder, file_number, 'align');
    
    % FIXME: find switch uniform
    
%     disp(round(feloop.period*100)/100)
    E = feloop.E;
    P = feloop.P;

    [Span, Coercive] = get_loop_prop(feloop);
    
    
    k = k + 1;
    Temp_out(k) = feloop.temp;
    Freq_out(k) = round(1/(2*feloop.period)*1000)/1000;
    Span_out(k) = (Span.p + Span.n)/2;
    Coercive_p_out(k) = Coercive.p;
    Coercive_n_out(k) = Coercive.n;
    
    
    [Field, Current] = Get_current(feloop);
    
   
%     cla
%     plot3(ones(size(Field.p))*k, Field.p, Current.p*feloop.period, '-r')
    plot(Field.p, Current.p*feloop.period, '-r')
    plot(Field.n, -Current.n*feloop.period, '-b')
%     xlim([-7 7])
%     plot(E.p, P.p, '-r')
%     plot(E.n, P.n, '-b')
%      plot(-feloop.init.E.n, -feloop.init.P.n, '-k')
%      plot(-feloop.ref.E.n, -feloop.ref.P.n, '-b')

    set(gca, 'FontSize', 14)
    if Span_out(k) > 1
%         xline(Coercive.p, 'k', 'linewidth', 1);
%         xline(-Coercive.n, 'k', 'linewidth', 1);
    end
    xlim([-15 15])
%     xlim([1 7])
%     ylim([0 50])
%     ylim([-40 40])
%     ylim([-10 80])
    ylabel('P, uC/cm^2', 'FontSize', 14)
    xlabel('E, kV/cm', 'FontSize', 14)
    title(['f = ' num2str(Freq_out(k)) ' Hz'], 'FontSize', 18)
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


%%

figure('position', [520 139 745 802])
subplot(3,1,1)

Temp_out = Freq_out;

plot(Temp_out, Span_out, '-b', 'linewidth', 1.5)
xlabel('Temp, C')
ylabel('Psat, uC/cm^2')
title('P saturation')
grid on
% xlim([20 130])
ylim([0 70])

range = Span_out > 0.5;

subplot(3,1,2)
hold on
plot(Temp_out(range), Coercive_p_out(range), '-r', 'linewidth', 1.5)
plot(Temp_out(range), Coercive_n_out(range), '-b', 'linewidth', 1.5)
xlabel('Temp, C')
ylabel('Ec, kV/cm')
title('Coercive field')
set(gca, 'YTick', [0:2:15])
grid on
% xlim([20 130])
ylim([0 4])

legend({'Positive', 'Negative'})


%%

figure('position', [520 139 745 802])
subplot(2,1,1)

plot(Temp_out, Span_out, '-b', 'linewidth', 1.5)
xlabel('Temp, C')
ylabel('Psat, uC/cm^2')
title('P saturation')
grid on
xlim([20 130])
ylim([0 70])

range = Span_out > 0.5;

subplot(2,1,2)
hold on
plot(Temp_out(range), Coercive_p_out(range), '-r', 'linewidth', 1.5)
plot(Temp_out(range), Coercive_n_out(range), '-b', 'linewidth', 1.5)
xlabel('Temp, C')
ylabel('Ec, kV/cm')
title('Coercive field')
set(gca, 'YTick', [0:2:15])
grid on
xlim([20 130])
ylim([0 10])

legend({'Ec^+', 'Ec^-'})




