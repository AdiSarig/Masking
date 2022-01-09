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
        session = runTrial(trialInfo.isTypeA, trialInfo.hasProbe, trialInfo.probe_loc, session);
        
        session.current.trialNum = session.current.trialNum + 1;
        
        % Stop for maintenance
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            if strcmpi(KbName(keyCode),'m') % m for maintenance
                stopForMaintenance(session);
            elseif strcmpi(KbName(keyCode),'ESCAPE') || strcmpi(KbName(keyCode),'esc')% abort experiment
                ListenChar(0);
                ShowCursor;
                Screen('closeall');
                sess = session;
                return
            end
        end
    end
    % send end of block trigger
    Datapixx('SetDoutValues', session.triggers(1).block_end); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.004);
    
    % Calculate durations
    session = calcDurations(session);
    
    % Save data after each block
    fileName = sprintf('..%cdata%cMasking_Sub_%s_block_%d',filesep,filesep,...
        session.subjectID,session.current.blockNum);
    try
        save(fileName,'session');
    catch
        mkdir(sprintf('..%cdata',filesep));
        save(fileName,'session');
    end
    
    % self paced break at the end of each block
    if session.current.blockNum < session.totalBlocks
        dispBreak(session);
    end
    
    % proceed to the next block
    session.current.blockNum = session.current.blockNum + 1;
    % restart trial count
    session.current.trialNum = 1;
end
if strcmp(session.sessionID,'2')
    dispEnd(session);
end
Datapixx('SetDoutValues', session.triggers(1).exp_end); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

sess = session;
end


