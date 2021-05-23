function sess = runSession(session)
while session.current.blockNum <= session.totalBlocks
    dispInstructions(session);
    while session.current.trialNum <= session.trialsPerBlock
        % wait intermission
        % if abort signal, return
        if dispIntermission(session)
            sess = session;
            disp(strcat('Session aborted at Block: ', string(session.current.blockNum), '/', string(session.totalBlocks), ' Trial:', string(session.current.trialNum), '/', string(session.trialsPerBlock)));
            return
        end
        
        trialInfo = session.blocks(session.current.blockNum).trials(session.current.trialNum);
        session = runTrial(trialInfo.isTypeA, trialInfo.hasProbe, session);
        
        session.current.trialNum = session.current.trialNum + 1;
    end
    % self paced break at the end of each block
    dispBreak(session);
    % Calculate durations
    session = calcDurations(session);
    % proceed to the next block
    sca
    session.current.blockNum = session.current.blockNum + 1;
    % restart trial count
    session.current.trialNum = 1;
end
dispEnd(session);
sess = session;
end


