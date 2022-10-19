
function Mode = Check_mode(Data)

if Data.res ~= 0 & Data.cap == 0
    Mode = "res";
end

if Data.res == 0 & Data.cap ~= 0
    Mode = "cap";
end

if Data.res == 0 & Data.cap == 0
    Mode = "error";
end

if Data.res ~= 0 & Data.cap ~= 0
    Mode = "mixed";
end


end