function abortSession = dispIntermission(session)
% self pacing intermission - currently not used
% disp a message
message = strcat(session.instructions.intermissionText, '\n\nBlock: ', string(session.current.blockNum), '/', string(session.totalBlocks), '        Trial:', string(session.current.trialNum), '/', string(session.trialsPerBlock));
DrawFormattedText(session.window, char(message), 'center', 'center', session.instructions.colour);
Screen('Flip', session.window);

% if two middle buttons => abort, else => continue
ResponsePixx('StartNow',1); % start response collection
resp = ResponsePixx('GetLoggedResponses',2);
ResponsePixx('StopNow',1); % stop response collection

if sum(find(resp(2,:))) == 7 % two middle buttons of the response box
    abortSession = 1;
    Datapixx('SetDoutValues', session.triggers(1).exp_aborted); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.001);
else
    abortSession = 0;
    Datapixx('SetDoutValues', session.triggers(1).trial_start); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.001);
end


end