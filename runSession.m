function sess = runSession(session)

Datapixx('SetDoutValues', session.triggers(1).exp_start); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

while session.current.blockNum <= session.totalBlocks
    if dispInstructions(session)
        sess = session;
        disp(strcat('Session aborted at Block: ', string(session.current.blockNum), '/', string(session.totalBlocks), ' Trial:', string(session.current.trialNum), '/', string(session.trialsPerBlock)));
        return
    end
    Datapixx('SetDoutValues', session.triggers(1).block_start); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.004);
    while session.current.trialNum <= session.trialsPerBlock
        
        trialInfo = session.blocks(session.current.blockNum).trials(session.current.trialNum);
        session = runTrial(trialInfo.isTypeA, trialInfo.hasProbe, session);
        
        session.current.trialNum = session.current.trialNum + 1;
    end
    % send end of block trigger
    Datapixx('SetDoutValues', session.triggers(1).block_end); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.004);
    % self paced break at the end of each block
    dispBreak(session);
    % Calculate durations
    session = calcDurations(session);
    % proceed to the next block
    session.current.blockNum = session.current.blockNum + 1;
    % restart trial count
    session.current.trialNum = 1;
end
dispEnd(session);

Datapixx('SetDoutValues', session.triggers(1).exp_end); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

sess = session;
end


