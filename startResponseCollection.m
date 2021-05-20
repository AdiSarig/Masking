function startResponseCollection(triggers)

% stop any schedules which might already be running
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');                % Synchronize DATAPixx registers to local register cache
Datapixx('SetDinLog');              % Configure logging with default values
Datapixx('StartDinLog');
Datapixx('RegWrRd');

doutBufferBaseAddr = 0;

Datapixx('WriteDoutBuffer', triggers, doutBufferBaseAddr + 4096*1); % RESPONSEPixx Yellow/Din1 Push
Datapixx('WriteDoutBuffer', zeros(length(triggers),1), doutBufferBaseAddr + 4096*1+2048*1); % RESPONSEPixx Yellow/Din1 Release

Datapixx('WriteDoutBuffer', zeros(length(triggers),1), doutBufferBaseAddr + 4096*0); % RESPONSEPixx RED/Din0 Push 
Datapixx('WriteDoutBuffer', zeros(length(triggers),1), doutBufferBaseAddr + 4096*0+2048*1); % RESPONSEPixx RED/Din0 Release

Datapixx('WriteDoutBuffer', zeros(length(triggers),1), doutBufferBaseAddr + 4096*2); % RESPONSEPixx Green/Din2 Push 
Datapixx('WriteDoutBuffer', zeros(length(triggers),1), doutBufferBaseAddr + 4096*2+2048*1); % RESPONSEPixx Green/Din2 Release

Datapixx('WriteDoutBuffer', zeros(length(triggers),1), doutBufferBaseAddr + 4096*3); % RESPONSEPixx Blue/Din3 Push 
Datapixx('WriteDoutBuffer', zeros(length(triggers),1), doutBufferBaseAddr + 4096*3+2048*1); % RESPONSEPixx Blue/Din3 Release

Datapixx('WriteDoutBuffer', zeros(length(triggers),1), doutBufferBaseAddr + 4096*4); % RESPONSEPixx White/Din4 Push 
Datapixx('WriteDoutBuffer', zeros(length(triggers),1), doutBufferBaseAddr + 4096*4+2048*1); % RESPONSEPixx White/Din4 Release


Datapixx('SetDoutSchedule', 0, 1000, length(triggers)+1, doutBufferBaseAddr); 
% NOTE THE 2 instead of 1, this fixes the problem mentioned above.
Datapixx('SetDinDataDirection', 0);
Datapixx('EnableDinDebounce');      % Filter out button bounce
Datapixx('EnableDoutButtonSchedules', 2); % This starts the schedules
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache
% Datapixx('Close');
% fprintf('\n\nAutomatic buttons schedules running\n\n');


end

