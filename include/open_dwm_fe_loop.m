function feloop = open_dwm_fe_loop(Sample, folder, file_number, varargin)
if nargin <3
    error("not enough arguments")
end

for i = 0:4
    try
        filename = [num2str(file_number, '%05u') '_' num2str(i, '%02u') '.txt'];
        file_addr = [char(folder) filename];
        Input_data = Read_file(file_addr);
    catch
        filename = [num2str(file_number, '%04u') '_' num2str(i, '%01u') '.txt'];
        file_addr = [char(folder) filename];
        Input_data = Read_file(file_addr);
    end
    
    Data(i+1) = Unpack_data(Input_data, Sample);
end

%compensation

%positive part
[E_main, P_main] = PE_filter(Data(2));
[E_ref, P_ref] = PE_filter(Data(3));
if std(E_main - E_ref) > 0.01
    error("different voltages")
end
E_comp_P = E_main;
P_comp_P = P_main - P_ref;

Initial.E.p = E_main;
Initial.P.p = P_main;
Reference.E.p = E_ref;
Reference.P.p = P_ref;
Reference.time.p = Data(3).time;
Reference.volt.p = Data(3).voltage_1;


%negative part
[E_main, P_main] = PE_filter(Data(4));
[E_ref, P_ref] = PE_filter(Data(5));
if std(E_main - E_ref) > 0.01
    error("different valtages")
end
E_comp_N = E_main;
P_comp_N = P_main - P_ref;

Initial.E.n = E_main;
Initial.P.n = P_main;
Reference.E.n = E_ref;
Reference.P.n = P_ref;
Reference.time.n = Data(5).time;
Reference.volt.n = Data(5).voltage_1;

feloop.align = false;

if nargin > 3 && varargin{1} == "align"
    feloop.align = true;
    
    Bias = (P_comp_P(end) - P_comp_P(1))/2;
    P_comp_P = P_comp_P - Bias;
    
    Bias = (P_comp_N(end) - P_comp_N(1))/2;
    P_comp_N = P_comp_N - Bias;
end

Field.p = E_comp_P;
Field.n = E_comp_N;
Polarization.p = P_comp_P;
Polarization.n = P_comp_N;

feloop.E = Field;
feloop.P = Polarization;

feloop.temp = Data.temp;
feloop.period = Data.period;

feloop.ref = Reference;
feloop.init = Initial;
feloop.sample = Data.sample;

end




function [E, P] = PE_filter(feloop)
E = feloop.field;
P = feloop.polarization;
P = P - mean(P(1:5));
P = medfilt1(P, 3);
P = movmean(P, 5);
end


