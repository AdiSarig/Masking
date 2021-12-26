function [Response, RTfromStart, accuracy] = getResponse(hasProbe, windowEnd, respDur, sessionID, stimulusType, resp)

numFrames = 1; % collect only press, not release

Datapixx('RegWrRd');
status = Datapixx('GetDinStatus');
if status.newLogFrames >= numFrames
    % Retrieve logged data:
    [data, RTfromStart] = Datapixx('ReadDinLog', numFrames);
    if windowEnd - RTfromStart < respDur
        % Decode into button state vector:
        Response = zeros(length(data), 5);
        for i=1:length(data)
            for j=0:4
                Response(i, j+1) = ~bitand(data(i), 2^j);
            end
        end
        Response = find(Response);
        if strcmp(sessionID,'1')
            if Response == 2 && hasProbe
                accuracy = 'hit';
            elseif Response == 2 && ~hasProbe
                accuracy = 'FA'; % false alarm
            else
                accuracy = 'error';
            end
        else % 2AFC session
            if Response == resp.face
                if strcmpi(stimulusType, 'face')
                    accuracy = 'hit';
                else
                    accuracy = 'FA'; % false alarm
                end
            elseif Response == resp.house
                if strcmpi(stimulusType, 'house')
                    accuracy = 'hit';
                else
                    accuracy = 'FA'; % false alarm
                end
            else
                accuracy = 'error';
            end
        end
    end
else % No response
    %----send trigger
    Response    = -1;
    RTfromStart = -1;
    if strcmp(sessionID,'1')
        if hasProbe
            accuracy = 'miss';
        else
            accuracy = 'CR'; %correct rejection
        end
    else
        accuracy = 'miss';
    end
end

end
