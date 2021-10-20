
function session = runTrial(isTypeA, hasProbe, session)
% check framerate
% flip_interval = Screen('GetFlipInterval', session.window);
% ms * fps = frames
% ms / flip_interval = frames

%% Fixation
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fix);
dispCross(session);
% vbl = Screen('Flip', session.window);

Datapixx('SetDoutValues', session.triggers(1).fix); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);  % present fixation
WaitSecs(0.004);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).fix1Onset = vbl;

% Initialize digital output after sending a trigger
Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);


%% Mask
dispCheckerboard(session);
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.mask);
dispCross(session);
% WaitSecs('UntilTime', vbl + .705);

while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.fix1Dur
        break % break one frame before target frame
    end
end

Datapixx('SetDoutValues', session.triggers(1).mask); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);  % present mask
WaitSecs(0.004);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).mask1Onset = vbl;

% Initialize digital output after sending a trigger
Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

%% Fixation
if isTypeA
    pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fix);
    dispCross(session);
    %     WaitSecs('UntilTime', vbl + .096);
    while 1
        Datapixx('RegWrRd');
        t_now = Datapixx('GetTime');
        if t_now > vbl + session.timing.maskDur
            break % break one frame before target frame
        end
    end
    %     vbl = Screen('Flip', session.window);
    
    Datapixx('SetDoutValues', session.triggers(1).fix); % send TTL at the next register write
    
    Datapixx('SetMarker');                                      % save the onset of the next register write
    Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen
    
    Screen('Flip',session.window);  % present fixation
    WaitSecs(0.004);
    
    Datapixx('RegWrRd');                                        % must read the register before getting the marker
    vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
    session.blocks(session.current.blockNum).trials(session.current.trialNum).fix2Onset = vbl;
    
    % Initialize digital output after sending a trigger
    Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.004);
else
    session.blocks(session.current.blockNum).trials(session.current.trialNum).fix2Onset = -1;
end

%% Stimulus
dispStimulus(session);
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.image);
dispCross(session);

if hasProbe
    Datapixx('SetDoutValues', session.triggers(1).hasProbe); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.004);
    % Initialize digital output after sending a trigger
    Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.004);
    xy_loc = dispProbe(session, []);
end

TTL = setTrigger(session,isTypeA);

while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.CFixDur
        break % break one frame before target frame
    end
end

Datapixx('SetDoutValues', TTL); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window); % present stimuli
WaitSecs(0.004);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register

% Initialize digital output after sending a trigger
Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

% send trial number trigger
Datapixx('SetDoutValues', session.triggers(1).trialNum(session.current.trialNum).numBin); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

% Initialize digital output after sending a trigger
Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

% Start response collection and Dout schedule based on Din button press
startResponseCollection(session.triggers(1).resp)

session.blocks(session.current.blockNum).trials(session.current.trialNum).stimOnset = vbl;


%% Fixation
if isTypeA
    dispCross(session);
    pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fix);
    if hasProbe
        dispProbe(session, xy_loc);
    end
    
    while 1
        Datapixx('RegWrRd');
        t_now = Datapixx('GetTime');
        if t_now > vbl + session.timing.stimDur
            break % break one frame before target frame
        end
    end
    
    Datapixx('SetDoutValues', session.triggers(1).fix); % send TTL at the next register write
    
    Datapixx('SetMarker');                                      % save the onset of the next register write
    Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen
    
    Screen('Flip',session.window);  % present fixation
    WaitSecs(0.004);
    
    Datapixx('RegWrRd');                                        % must read the register before getting the marker
    vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
    session.blocks(session.current.blockNum).trials(session.current.trialNum).fix3Onset = vbl;
    
    % Initialize digital output after sending a trigger
    Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.004);
else
    session.blocks(session.current.blockNum).trials(session.current.trialNum).fix3Onset = -1;
end

%% Mask
dispCheckerboard(session);
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.mask);
dispCross(session);

if hasProbe
    dispProbe(session, xy_loc);
end

if isTypeA
    while 1
        Datapixx('RegWrRd');
        t_now = Datapixx('GetTime');
        if t_now > vbl + session.timing.CFixDur
            break % break one frame before target frame
        end
    end
else
    while 1
        Datapixx('RegWrRd');
        t_now = Datapixx('GetTime');
        if t_now > vbl + session.timing.stimDur
            break % break one frame before target frame
        end
    end
end

Datapixx('SetDoutValues', session.triggers(1).mask); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);  % present mask
WaitSecs(0.004);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).mask2Onset = vbl;

% Initialize digital output after sending a trigger
Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);


%% Fixation - Response window
dispCross(session);
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fix);

if hasProbe && ~isTypeA
    dispProbe(session, xy_loc);
end

while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.maskDur
        break % break one frame before target frame
    end
end

Datapixx('SetDoutValues', session.triggers(1).fix); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);  % present fixation
WaitSecs(0.004);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).fix4Onset1 = vbl;

% Initialize digital output after sending a trigger
Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

%% Fixation - Response window - part 2
dispCross(session);
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fixResp);

while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.responseDur1
        break % break one frame before target frame
    end
end

Datapixx('SetDoutValues', session.triggers(1).fix); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);  % present fixation
WaitSecs(0.004);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).fix4Onset2 = vbl;

% Initialize digital output after sending a trigger
Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

%% Intermission screen
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.inter);

while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.responseDur2
        break % break one frame before target frame
    end
end

Datapixx('SetDoutValues', session.triggers(1).trial_end); % send TTL at the next register write

Datapixx('SetMarker');
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);
WaitSecs(0.004);

Datapixx('RegWrRd');
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).intermission = vbl;

% Initialize digital output after sending a trigger
Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

%% Response collection
[Response, RTfromStart, accuracy] = getResponse(hasProbe, vbl, session.timing.responseDur1 + session.timing.responseDur2); % retrive response from register device
switch accuracy % send response triggers
    case 'hit'
        Datapixx('SetDoutValues', session.triggers(1).resp_hit);
        Datapixx('RegWr');
        WaitSecs(0.004);
        % Initialize digital output after sending a trigger
        Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
        Datapixx('RegWr');
        WaitSecs(0.004);
        session.blocks(session.current.blockNum).trials(session.current.trialNum).accuracy = 1;
    case 'miss'
        Datapixx('SetDoutValues', session.triggers(1).resp_miss);
        Datapixx('RegWr');
        WaitSecs(0.004);
        % Initialize digital output after sending a trigger
        Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
        Datapixx('RegWr');
        WaitSecs(0.004);
        session.blocks(session.current.blockNum).trials(session.current.trialNum).accuracy = 0;
    case 'FA'
        Datapixx('SetDoutValues', session.triggers(1).resp_FA);
        Datapixx('RegWr');
        WaitSecs(0.004);
        % Initialize digital output after sending a trigger
        Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
        Datapixx('RegWr');
        WaitSecs(0.004);
        session.blocks(session.current.blockNum).trials(session.current.trialNum).accuracy = 0;
    case 'CR'
        Datapixx('SetDoutValues', session.triggers(1).resp_CR);
        Datapixx('RegWr');
        WaitSecs(0.004);
        % Initialize digital output after sending a trigger
        Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
        Datapixx('RegWr');
        WaitSecs(0.004);
        session.blocks(session.current.blockNum).trials(session.current.trialNum).accuracy = 1;
    case 'error'
        Datapixx('SetDoutValues', session.triggers(1).resp_error);
        Datapixx('RegWr');
        WaitSecs(0.004);
        % Initialize digital output after sending a trigger
        Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
        Datapixx('RegWr');
        WaitSecs(0.004);
        session.blocks(session.current.blockNum).trials(session.current.trialNum).accuracy = 0;
end

session.blocks(session.current.blockNum).trials(session.current.trialNum).Response = Response;
session.blocks(session.current.blockNum).trials(session.current.trialNum).RTfromStart = RTfromStart;
if Response ~= -1
    session.blocks(session.current.blockNum).trials(session.current.trialNum).RT = RTfromStart - session.blocks(session.current.blockNum).trials(session.current.trialNum).stimOnset;
else
    session.blocks(session.current.blockNum).trials(session.current.trialNum).RT = -1;
end

%% Trial end
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.end);
while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.interDur
        break % break one frame before target frame
    end
end
% Datapixx('SetDoutValues', session.triggers(1).trial_end); % send TTL at the next register write

Datapixx('SetMarker');
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);
WaitSecs(0.004);

Datapixx('RegWrRd');
session.blocks(session.current.blockNum).trials(session.current.trialNum).trialEnd = Datapixx('GetMarker');

% Initialize digital output after sending a trigger
Datapixx('SetDoutValues', session.triggers(1).init_Dout); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.004);

%% Timeout for too long response time
if hasProbe && (RTfromStart - session.blocks(session.current.blockNum).trials(session.current.trialNum).stimOnset > session.timing.timeoutLim || strcmp(accuracy, 'miss'))
    DrawFormattedText(session.window, char(session.instructions.timeout), 'center', 'center', session.instructions.colour);
    Screen('Flip', session.window);
    WaitSecs(3);
end

Datapixx('StopDinLog'); % stop response collection
Datapixx('RegWrRd');

end