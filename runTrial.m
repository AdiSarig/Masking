
function runTrial(isTypeA, hasProbe, session)
% check framerate
% flip_interval = Screen('GetFlipInterval', session.window);
% ms * fps = frames
% ms / flip_interval = frames

dispCross(session);
vbl = Screen('Flip', session.window);
% waitFrames(.705/flip_interval, session);
%wait 705 ms

dispCheckerboard(session);
dispCross(session);
WaitSecs('UntilTime', vbl + .705);
vbl = Screen('Flip', session.window);
% waitFrames(.096/flip_interval, session);
%wait 96 ms


if isTypeA
    dispCross(session);
    WaitSecs('UntilTime', vbl + .096);
    vbl = Screen('Flip', session.window);
    % waitFrames(.096/flip_interval, session);
    %wait 96
end

dispStimulus(session);
dispCross(session);

if hasProbe
    xy_loc = dispProbe(session, []);
end

WaitSecs('UntilTime', vbl + .096);
vbl = Screen('Flip', session.window);
% waitFrames(.033/flip_interval, session);
%wait 33

if isTypeA
    dispCross(session);
    if hasProbe
        dispProbe(session, xy_loc);
    end
    WaitSecs('UntilTime', vbl + .033);
    vbl = Screen('Flip', session.window);
    % waitFrames(.096/flip_interval, session);
    %wait 96
end

dispCheckerboard(session);
dispCross(session);

if hasProbe
    dispProbe(session, xy_loc);
end

if isTypeA
    WaitSecs('UntilTime', vbl + .096);
else
    WaitSecs('UntilTime', vbl + .033);
end

vbl = Screen('Flip', session.window);
% waitFrames(.096/flip_interval, session);
%wait 96 ms

WaitSecs('UntilTime', vbl + .096);

end