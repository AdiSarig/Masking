function [fullDec] = convertTriggers(trigDec)
% trigDec is a 1X1 struct of decimal triggers which can range from 0 to 255
% fullDec is a cell array of all the converted triggers

trigDec = struct2array(trigDec);
fullDec = cell(length(trigDec),1);
% fullBinary = cell(length(trigDec),1);

for ind = 1:length(trigDec)
    
    tempBin = dec2bin(trigDec(ind),8);
    fullBin = dec2bin(0,24);
    fullBin(8:2:22) = tempBin(:);
    
    fullDec{ind} = bin2dec(fullBin);
%     fullBinary{ind} = fullBin;
end

end

