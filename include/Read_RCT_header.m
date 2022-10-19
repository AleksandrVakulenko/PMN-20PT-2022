function Untitled = Read_RCT_header(filename)
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [2, 2];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["ROhm", "CpF", "TempC"];
opts.SelectedVariableNames = ["ROhm", "CpF", "TempC"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
% opts = setvaropts(opts, "Var3", "WhitespaceRule", "preserve");
% opts = setvaropts(opts, "Var3", "EmptyFieldRule", "auto");

% Import the data
Untitled = readtable(filename, opts);

%% Convert to output type
Untitled = table2array(Untitled);

end