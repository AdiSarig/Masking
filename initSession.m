function session = initSession(totalBlocks, AtrialsPerBlock, BtrialsPerBlock, probeTrialsPerBlock)
    trialsPerBlock = AtrialsPerBlock + BtrialsPerBlock;

    session.subjectID = input('subjectID: ', 's');
    session.sessionID = input('sessionID: ', 's');
    session.CreationTime = datestr(now);
    session.matlabVersion = version;
    session.trialsPerBlock = trialsPerBlock;
    session.totalBlocks = totalBlocks;
    session.current.blockNum = 1;
    session.current.trialNum = 1;
    session.isComplete = 0;

    for i = 1:totalBlocks
        session.blocks(i) = initTrialInfo(AtrialsPerBlock, BtrialsPerBlock, probeTrialsPerBlock);
    end

    % allTrials = initTrialInfo(AtrialsPerBlock*totalBlocks, BtrialsPerBlock*totalBlocks, probeTrialsPerBlock*totalBlocks)
    % for i = 1:totalBlocks
    %     session.blocks(i) = allTrials(((i-1)*trialsPerBlock)+1:(i*trialsPerBlock)+1)
    % end

end

% [WARNING]: Probe occurance ranom. Not ballanced between trials A and B
function allTrials = initTrialInfo(totalAtrials, totalBtrials, totalProbeTrials)
    totalTrials = totalAtrials+totalBtrials
    for i = 1:totalAtrials
        trials(i).isTypeA = 1;
        trials(i).hasProbe = 0;
    end
    for i = totalAtrials+1:totalTrials
        trials(i).isTypeA = 0;
        trials(i).hasProbe = 0;
    end
    for i = datasample(1:totalTrials,totalProbeTrials,'Replace',false)
        trials(i).hasProbe = 1;
    end

    % for i = 1:totalTrials
    %     trials(i).stimulus = ?
    % end

    allTrials = trials(randperm(totalTrials))

end
% five blocks of 144 trials (48 faces, 48 houses, 48 noise stimuli, so that each stimulus repeated four times within a block).
% 5 blocks
% 144 trials
% half A, half B
% ~15% probed