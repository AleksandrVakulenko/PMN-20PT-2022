


function Data = Read_file(filename)

RCT = Read_RCT_header(filename);

[ch1, ch2, time] = Read_Body(filename);

Data.ch1 = ch1;
Data.ch2 = ch2;
Data.time = time;
Data.res = RCT(1);
Data.cap = RCT(2);

if numel(RCT)==3
    Data.temp = RCT(3);
else
    Data.temp = [];
end

end