
function session = runTrial(isTypeA, hasProbe, session)
% check framerate
% flip_interval = Screen('GetFlipInterval', session.window);
% ms * fps = frames
% ms / flip_interval = frames

%% Fixation
dispCross(session);
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fix);
% vbl = Screen('Flip', session.window);

Datapixx('SetDoutValues', session.triggers(1).fix); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);  % present fixation
WaitSecs(0.001);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).fix1Onset = vbl;

% waitFrames(.705/flip_interval, session);
%wait 705 ms

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
WaitSecs(0.001);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).mask1Onset = vbl;

% vbl = Screen('Flip', session.window);
% waitFrames(.096/flip_interval, session);
%wait 96 ms

%% Fixation
if isTypeA
    dispCross(session);
    pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fix);
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
    WaitSecs(0.001);

    Datapixx('RegWrRd');                                        % must read the register before getting the marker
    vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
    session.blocks(session.current.blockNum).trials(session.current.trialNum).fix2Onset = vbl;
    
    
    % waitFrames(.096/flip_interval, session);
    %wait 96
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
    WaitSecs(0.001);
    xy_loc = dispProbe(session, []);
end

TTL = setTrigger(session,isTypeA);

% WaitSecs('UntilTime', vbl + .096);
while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.CFixDur
        break % break one frame before target frame
    end
end

% vbl = Screen('Flip', session.window);

Datapixx('SetDoutValues', TTL); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window); % present stimuli
WaitSecs(0.001);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register

% send trial number trigger
Datapixx('SetDoutValues', session.triggers(1).trialNum(session.current.trialNum).numBin); % send TTL at the next register write
Datapixx('RegWr');
WaitSecs(0.001);

% Start response collection and Dout schedule based on Din button press
startResponseCollection(session.triggers(1).resp)

session.blocks(session.current.blockNum).trials(session.current.trialNum).stimOnset = vbl;

% waitFrames(.033/flip_interval, session);
%wait 33

%% Fixation
if isTypeA
    dispCross(session);
    pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fix);
    if hasProbe
        dispProbe(session, xy_loc);
    end
    %     WaitSecs('UntilTime', vbl + .033);
    while 1
        Datapixx('RegWrRd');
        t_now = Datapixx('GetTime');
        if t_now > vbl + session.timing.stimDur
            break % break one frame before target frame
        end
    end
    %     vbl = Screen('Flip', session.window);
    Datapixx('SetDoutValues', session.triggers(1).fix); % send TTL at the next register write
    
    Datapixx('SetMarker');                                      % save the onset of the next register write
    Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen
    
    Screen('Flip',session.window);  % present fixation
    WaitSecs(0.001);

    Datapixx('RegWrRd');                                        % must read the register before getting the marker
    vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
    session.blocks(session.current.blockNum).trials(session.current.trialNum).fix3Onset = vbl;
    
    % waitFrames(.096/flip_interval, session);
    %wait 96
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
    %     WaitSecs('UntilTime', vbl + .096);
    while 1
        Datapixx('RegWrRd');
        t_now = Datapixx('GetTime');
        if t_now > vbl + session.timing.CFixDur
            break % break one frame before target frame
        end
    end
else
    %     WaitSecs('UntilTime', vbl + .033);
    while 1
        Datapixx('RegWrRd');
        t_now = Datapixx('GetTime');
        if t_now > vbl + session.timing.stimDur
            break % break one frame before target frame
        end
    end
end

% vbl = Screen('Flip', session.window);

Datapixx('SetDoutValues', session.triggers(1).mask); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);  % present mask
WaitSecs(0.001);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).mask2Onset = vbl;

% waitFrames(.096/flip_interval, session);
%wait 96 ms

% WaitSecs('UntilTime', vbl + session.timing.maskDur);


%% Fixation - Response window
dispCross(session);
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fix);

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
WaitSecs(0.001);

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).fix4Onset = vbl;


%% Intermission screen
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.inter);

while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.responseDur
        break % break one frame before target frame
    end
end

Datapixx('SetDoutValues', session.triggers(1).trial_end); % send TTL at the next register write

Datapixx('SetMarker');
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);
WaitSecs(0.001);

Datapixx('RegWrRd');
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).intermission = vbl;

%% Response collection
[Response, RTfromStart, accuracy] = getResponse(hasProbe, vbl, session.timing.responseDur); % retrive response from register device
switch accuracy % send response triggers
    case 'hit'
        Datapixx('SetDoutValues', session.triggers(1).resp_hit);
        Datapixx('RegWr');
        WaitSecs(0.001);
        session.blocks(session.current.blockNum).trials(session.current.trialNum).accuracy = 1;
    case 'miss'
        Datapixx('SetDoutValues', session.triggers(1).resp_miss);
        Datapixx('RegWr');
        WaitSecs(0.001);
        session.blocks(session.current.blockNum).trials(session.current.trialNum).accuracy = 0;
    case 'FA'
        Datapixx('SetDoutValues', session.triggers(1).resp_FA);
        Datapixx('RegWr');
        WaitSecs(0.001);
        session.blocks(session.current.blockNum).trials(session.current.trialNum).accuracy = 0;
    case 'CR'
        Datapixx('SetDoutValues', session.triggers(1).resp_CR);
        Datapixx('RegWr');
        WaitSecs(0.001);
        session.blocks(session.current.blockNum).trials(session.current.trialNum).accuracy = 1;
    case 'error'
        Datapixx('SetDoutValues', session.triggers(1).resp_error);
        Datapixx('RegWr');
        WaitSecs(0.001);
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
WaitSecs(0.001);

Datapixx('RegWrRd');
session.blocks(session.current.blockNum).trials(session.current.trialNum).trialEnd = Datapixx('GetMarker');


%% Timeout for too long response time
if hasProbe && (RTfromStart - session.blocks(session.current.blockNum).trials(session.current.trialNum).stimOnset > session.timing.timeoutLim || strcmp(accuracy, 'miss'))
    DrawFormattedText(session.window, char(session.instructions.timeout), 'center', 'center', session.instructions.colour);
    Screen('Flip', session.window);
    WaitSecs(3);
end

Datapixx('StopDinLog'); % stop response collection
Datapixx('RegWrRd');

end