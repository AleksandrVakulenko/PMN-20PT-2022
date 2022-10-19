
% TODO:
% 1) Add waveform number to output files
% 2) Create single Matlab library
% 3) Add sample spec in output folder


clc
Folder = "Output 2022_10_06/";

%% Get all file names
Files = dir(Folder);
Files(1:2) = [];
File_names = convertCharsToStrings({Files.name}')

Extensions = extractAfter(File_names, ".");
Range = Extensions ~= "txt";
File_names(Range) = [];
clearvars Files Extensions Range


%% find groups and files in groups
Groups_list = unique(extractBefore(File_names, "_"));

Prefixes = extractBefore(File_names, "_");
Postfixes = extractBefore(extractAfter(File_names, "_"), '.');

Groups = [];
for i = 1:numel(Groups_list)
    
    Groups(i).prefix = Groups_list(i);
    Range = Prefixes == Groups(i).prefix;
    Groups(i).postfix = Postfixes(Range);
    Number_of_files = numel(find(Range));
    
    if Number_of_files == 1
        Type = "single";
    elseif Number_of_files == 5
        Type = "DWM";
    elseif Number_of_files > 5
        Type = "multiple";
    else
        Type = "null";
    end
    
    Groups(i).type = Type;
    Groups(i).folder = Folder;
end

Groups = Groups_sort(Groups);

clearvars i Type Range Postfixes Prefixes Groups_list Number_of_files File_names Folder

%%
function Groups = Groups_sort(Groups)
for i = 1:numel(Groups)
    Groups(i) = Group_files_sort(Groups(i));
end
[~, Indexes] = sort(str2num(char([Groups.prefix]')));
Groups = Groups(Indexes);
end


function Group = Group_files_sort(Group)
Postfixes = Group.postfix;
numbers = str2num(char(Postfixes));
[~, indexes] = sort(numbers);
Postfixes = Postfixes(indexes);
Group.postfix = Postfixes;
end








