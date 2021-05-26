function [fullDec] = convertTriggers(trigDec)

trigDec = struct2array(trigDec);
fullDec = cell(length(trigDec),1);

for ind = 1:length(trigDec)
    
    tempBin = dec2bin(trigDec(ind),8);
    fullBin = dec2bin(0,24);
    fullBin(8:2:22) = tempBin(:);
    
    fullDec{ind} = bin2dec(fullBin);
end

end

