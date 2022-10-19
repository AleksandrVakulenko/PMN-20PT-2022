function Output = Unpack_data(Data, Sample)

Mode = Check_mode(Data);

if nargin < 2
    Thickness = 1; %cm
    Surface = 1; %cm
else
    Thickness = Sample.H*100; %cm
    Surface = Sample.S*10000; %cm
end

Data.ch1 = Data.ch1 * Sample.Gain;

Output.period = Data.time(end) - Data.time(1);
Output.temp = Data.temp; %C
Output.voltage_1 = Data.ch1; %V
Output.voltage_2 = Data.ch2; %V
Output.cap = Data.cap; %pF
Output.res = Data.res; % Ohm
Output.sample = Sample;

if Mode == 'error'
   error('Data error: both Cap and Res equal to zero!') 
end

if Mode == 'cap'
   Charge = Data.ch2 * Data.cap*1e-12 * 1e6; %uC 
   Polarization = Charge/Surface; %uC/cm^2
   Field = (Data.ch1/1000)/Thickness; %kV/cm
   Output.mode = "E-P";
   Output.polarization = Polarization; % %uC/cm^2
   Output.field = Field;
   Output.time = Data.time;
end


if Mode == 'res'
   Current = Data.ch2 / Data.res; 
   Field = (Data.ch1/1000)/Thickness; %kV/cm
   Output.mode = "E-I";
   Output.current = Current;
   Output.field = Field;
   Output.time = Data.time;
end

if Mode == 'mixed'
   Output = Data;
   Output.mode = "mixed mode";
end


end