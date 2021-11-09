function session = calcDurations(session)
% calculate durations at the end of the block

data = session.blocks(session.current.blockNum).trials;
if strcmpi(session.design, 'sandwich masking')
    uc_loc = [data.fix2Onset] < 0;
    
    fix1Dur = num2cell([data.mask1Onset] - [data.fix1Onset]);
    [data.fix1Dur] = fix1Dur{:};
    
    mask1Dur = num2cell([data.fix2Onset] - [data.mask1Onset]);
    [data(~uc_loc).mask1Dur] = mask1Dur{~uc_loc};
    mask1Dur = num2cell([data.stimOnset] - [data.mask1Onset]);
    [data(uc_loc).mask1Dur] = mask1Dur{uc_loc};
    
    fix2Dur = num2cell([data.stimOnset] - [data.fix2Onset]);
    [data(~uc_loc).fix2Dur] = fix2Dur{~uc_loc};
    fix2Dur = num2cell(ones(size(data,2),1)*-1);
    [data(uc_loc).fix2Dur] = fix2Dur{uc_loc};
else % backward masking
    uc_loc = [data.fix3Onset] < 0;
    fix1Dur = num2cell([data.stimOnset] - [data.fix1Onset]);
    [data.fix1Dur] = fix1Dur{:};
end
stimDur = num2cell([data.fix3Onset] - [data.stimOnset]);
[data(~uc_loc).stimDur] = stimDur{~uc_loc};
stimDur = num2cell([data.mask2Onset] - [data.stimOnset]);
[data(uc_loc).stimDur] = stimDur{uc_loc};

fix3Dur = num2cell([data.mask2Onset] - [data.fix3Onset]);
[data(~uc_loc).fix3Dur] = fix3Dur{~uc_loc};
fix3Dur = num2cell(ones(size(data,2),1)*-1);
[data(uc_loc).fix3Dur] = fix3Dur{uc_loc};

mask2Dur = num2cell([data.fix4Onset1] - [data.mask2Onset]);
[data.mask2Dur] = mask2Dur{:};

fix4Dur1 = num2cell([data.fix4Onset2] - [data.fix4Onset1]);
[data.fix4Dur1] = fix4Dur1{:};

fix4Dur2 = num2cell([data.intermission] - [data.fix4Onset2]);
[data.fix4Dur2] = fix4Dur2{:};

intermissionDur = num2cell([data.trialEnd] - [data.intermission]);
[data.intermissionDur] = intermissionDur{:};

session.blocks(session.current.blockNum).trials = data;

end

