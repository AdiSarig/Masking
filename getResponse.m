function [Response, RTfromStart] = getResponse(timeout,trigger)

Datapixx('SetDinLog');              % Configure logging with default values
Datapixx('StartDinLog');
Datapixx('RegWrRd');

numFrames = 1; % collect only press, not release
Datapixx('RegWrRd');
t_now = Datapixx('GetTime');
timeout = t_now + timeout;  % set timeout by vpixx time

% Enter a polling loop to wait until the requested minimum amount of
% data is available:
while 1
    Datapixx('RegWrRd');
    status = Datapixx('GetDinStatus');
    t_now = Datapixx('GetTime');
    if status.newLogFrames >= numFrames
        % Requested amount of data available: Sent response trigger and exit loop.
        Datapixx('SetDoutValues', trigger); % send TTL at the next register write
        Datapixx('RegWrRd');
        WaitSecs(0.001);
        break;
    else
        % Insufficient amount. If this is a polling request, we
        % simply return no result:
        if t_now > timeout
            Response    = -1;
            RTfromStart = -1;
            return;
        end
    end
    
    % Sleep a msec, then retry:
    WaitSecs('YieldSecs', 0.001);
end

% Retrieve logged data:
[data, timestamps, underflow] = Datapixx('ReadDinLog', numFrames);

% Decode into button state vector:
buttons = zeros(length(data), 5);
for i=1:length(data)
    for j=0:4
        buttons(i, j+1) = ~bitand(data(i), 2^j);
    end
end

% Return all data:
Response = buttons;
RTfromStart = timestamps;

if underflow > 0
    fprintf('ResponsePixx: WARNING! Undeflow of event buffer detected during call to %s. Button events may be lost or corrupted!\n', cmd);
end

Datapixx('StopDinLog');
Datapixx('RegWrRd');
end

