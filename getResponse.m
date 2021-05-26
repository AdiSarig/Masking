function [Response, RTfromStart, accuracy] = getResponse(hasProbe)

numFrames = 1; % collect only press, not release

Datapixx('RegWrRd');
status = Datapixx('GetDinStatus');
if status.newLogFrames >= numFrames
    % Retrieve logged data:
    [data, RTfromStart] = Datapixx('ReadDinLog', numFrames);
    % Decode into button state vector:
    Response = zeros(length(data), 5);
    for i=1:length(data)
        for j=0:4
            Response(i, j+1) = ~bitand(data(i), 2^j);
        end
    end
    Response = find(Response);
    
    if Response == 2 && hasProbe
        accuracy = 'hit';
    elseif Response == 2 && ~hasProbe
        accuracy = 'FA'; % false alarm
    else
        accuracy = 'error';
    end
else % No response
    %----send trigger
    Response    = -1;
    RTfromStart = -1;
    if hasProbe
        accuracy = 'miss';
    else
        accuracy = 'CR'; %correct rejection
    end
end

end
