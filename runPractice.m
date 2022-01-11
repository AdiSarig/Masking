function runPractice(session)

%% prepare practice
if strcmp(session.sessionID,'1')
    load('Prac1_data', 'trials');
else
    load('Prac2_data', 'trials');
end
session.totalBlocks = 1;
%% Replace textures
stimType = extractfield(session.blocks(1).trials, 'stimulusType');
n_trials = find(strcmp(stimType, 'noise'));
f_trials = find(strcmp(stimType, 'face'));
h_trials = find(strcmp(stimType, 'house'));
for ind = 1:length(trials)
    switch trials(ind).stimulusType
        case 'noise'
            trials(ind).stimulusTexture = session.blocks(1).trials(n_trials(1)).stimulusTexture;
        case 'face'
            trials(ind).stimulusTexture = session.blocks(1).trials(f_trials(1)).stimulusTexture;
        case 'house'
            trials(ind).stimulusTexture = session.blocks(1).trials(h_trials(1)).stimulusTexture;
    end
end
session.blocks(1).trials = trials;

%% Run practice
Datapixx('SetDoutValues', session.triggers(1).exp_start); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

if dispInstructions(session)
    disp(strcat('Session aborted at Block: ', string(session.current.blockNum), '/', string(session.totalBlocks), ' Trial:', string(session.current.trialNum), '/', string(session.trialsPerBlock)));
    return
end
Datapixx('SetDoutValues', session.triggers(1).block_start); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);
while session.current.trialNum <= length(trials)
    
    trialInfo = trials(session.current.trialNum);
    runTrial(trialInfo.isTypeA, trialInfo.hasProbe, trialInfo.probe_loc, session);
    
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
            return
        end
    end
end
% send end of block trigger
Datapixx('SetDoutValues', session.triggers(1).block_end); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

% self paced break at the end of each block
if session.current.blockNum < session.totalBlocks
    dispBreak(session);
end

% restart trial count
session.current.trialNum = 1;


end

