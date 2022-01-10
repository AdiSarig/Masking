% Clear the workspace and the screen
sca;
close all;
clearvars;

try
    subjectID = input('subjectID: ', 's');
    sessionID = '1';
    
    
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    %% Initialize Vpixx
    isOpen = Datapixx('Open'); % check if Vpixx screen is connected
    if ~isOpen
        error('VIEWPixx not connected! Please check connection and try again');
    end
    PsychDataPixx('Open');
    % switch to ScanningBacklight mode for full illumination only after pixels stabilize
    PsychDataPixx('EnableVideoScanningBacklight'); % comment for photodiode test
    ResponsePixx('Close'); % to make sure open doesn't fail
    ResponsePixx('Open');
    Datapixx('EnableDinDebounce');
    Datapixx('RegWr');
    
    doutValue = bin2dec('0000 0000 0000 0000 0000 0000'); % initialize digital output
    Datapixx('SetDoutValues', doutValue);
    Datapixx('RegWr');
    
    %% Initialize screen
    % Get the screen numbers
    screens = Screen('Screens');
    
    % Draw to the external screen if avaliable
    screenNumber = max(screens);
    bgColour     =  GrayIndex(screenNumber);
    
    [w, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColour);
%     [w, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColour, [0 0 1000 800]);
    Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % this enables us to use the alpha transparency
    HideCursor;
    Screen('TextSize', w, 40);
    
    %% Run main session - masked/unmasked face/house/noise
    session = initSession(subjectID, sessionID, 5, 72, 72, 20, w, windowRect, round(bgColour*255));
    
    previewStim(session);

    runPractice(session);
    
    session = runSession(session);
    
    % save main session
    fileName = sprintf('..%cdata%cMasking_Sub_%s_%s_%s',filesep,filesep,...
        session.subjectID, 'temp',datestr(now,30));
    try
        save(fileName,'session*');
    catch
        mkdir(sprintf('..%cdata',filesep));
        save(fileName,'session*');
    end
    
    %% Post test - 2AFC (face/house) and PAS
    sessionID = '2';
    session2 = initSession(subjectID, sessionID, 2, 72, 72, 0, w, windowRect, round(bgColour*255));
    
    previewStim(session2); % remove when done with piloting
    
    runPractice(session2);
    
    session2 = runSession(session2);
    
    %% save both sessions - including post test
    fileName = sprintf('..%cdata%cMasking_Sub_%s_%s_%s',filesep,filesep,...
        subjectID, 'final',datestr(now,30));
    try
        save(fileName,'session*');
    catch
        mkdir(sprintf('..%cdata',filesep));
        save(fileName,'session*');
    end
    
    %% End of experiment
    Datapixx('SetDoutValues', session2.triggers(1).init_Dout); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.004);
    
    sca;
    Datapixx('DisableDoutButtonSchedules');
    Datapixx('StopDoutSchedules');
    Datapixx('RegWr');
    ResponsePixx('Close');
    Datapixx('Close');
catch me
    sca;
    Datapixx('DisableDoutButtonSchedules');
    Datapixx('StopDoutSchedules');
    Datapixx('RegWr');
    ResponsePixx('Close');
    Datapixx('Close');
    rethrow(me)
end