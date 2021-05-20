
function session = runTrial(isTypeA, hasProbe, session)
% check framerate
% flip_interval = Screen('GetFlipInterval', session.window);
% ms * fps = frames
% ms / flip_interval = frames

%% Fixation
dispCross(session);
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.fix);
% vbl = Screen('Flip', session.window);

% Datapixx('SetDoutValues', session.triggers(1).Trial_START); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);                        % present stimuli

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).fix1Time = vbl;

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

% Datapixx('SetDoutValues', session.triggers(1).Trial_START); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);                        % present stimuli

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).mask1Time = vbl;

% vbl = Screen('Flip', session.window);
% waitFrames(.096/flip_interval, session);
%wait 96 ms

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
    
    % Datapixx('SetDoutValues', session.triggers(1).Trial_START); % send TTL at the next register write
    
    Datapixx('SetMarker');                                      % save the onset of the next register write
    Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen
    
    Screen('Flip',session.window);                        % present stimuli
    
    Datapixx('RegWrRd');                                        % must read the register before getting the marker
    vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
    session.blocks(session.current.blockNum).trials(session.current.trialNum).fix2Time = vbl;
    
    
    % waitFrames(.096/flip_interval, session);
    %wait 96
end

%% Stimulus
dispStimulus(session);
pixelTrigger = dispPixelTrigger(session, session.stim.triggers.image);
dispCross(session);

if hasProbe
    xy_loc = dispProbe(session, []);
end

% WaitSecs('UntilTime', vbl + .096);
while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.CFixDur
        break % break one frame before target frame
    end
end

% vbl = Screen('Flip', session.window);

% Datapixx('SetDoutValues', session.triggers(1).Trial_START); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);                        % present stimuli

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).stimTime = vbl;

% waitFrames(.033/flip_interval, session);
%wait 33

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
    % Datapixx('SetDoutValues', session.triggers(1).Trial_START); % send TTL at the next register write
    
    Datapixx('SetMarker');                                      % save the onset of the next register write
    Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen
    
    Screen('Flip',session.window);                        % present stimuli
    
    Datapixx('RegWrRd');                                        % must read the register before getting the marker
    vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
    session.blocks(session.current.blockNum).trials(session.current.trialNum).fix3Time = vbl;
    
    % waitFrames(.096/flip_interval, session);
    %wait 96
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

% Datapixx('SetDoutValues', session.triggers(1).Trial_START); % send TTL at the next register write

Datapixx('SetMarker');                                      % save the onset of the next register write
Datapixx('RegWrPixelSync',pixelTrigger);                    % register write exactly when the pixels appear on screen

Screen('Flip',session.window);                        % present stimuli

Datapixx('RegWrRd');                                        % must read the register before getting the marker
vbl = Datapixx('GetMarker');                       % retrieve the saved timing from the register
session.blocks(session.current.blockNum).trials(session.current.trialNum).mask2Time = vbl;

% waitFrames(.096/flip_interval, session);
%wait 96 ms

% WaitSecs('UntilTime', vbl + session.timing.maskDur);
while 1
    Datapixx('RegWrRd');
    t_now = Datapixx('GetTime');
    if t_now > vbl + session.timing.maskDur
        break % break one frame before target frame
    end
end

end