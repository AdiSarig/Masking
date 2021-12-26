function abortSession = dispInstructions(session)

ResponsePixx('StartNow',1); % start response collection
if strcmp(session.sessionID,'1')
    Screen('DrawTexture',session.window, session.instructions.infoTex);
else % display 2AFC instructions for session 2
    Screen('DrawTexture',session.window, session.instructions.AFCinfoTex);
end
Datapixx('SetDoutValues', session.triggers(1).block_info); % send TTL at the next register write
Screen('Flip',session.window);
Datapixx('RegWr');
WaitSecs(0.004);

resp = ResponsePixx('GetLoggedResponses',2);

% PAS instructions only for 2AFC session
if strcmp(session.sessionID,'2')
    Screen('DrawTexture',session.window, session.instructions.PASinfoTex);
    
    Datapixx('SetDoutValues', session.triggers(1).block_info); % send TTL at the next register write
    Screen('Flip',session.window);
    Datapixx('RegWr');
    WaitSecs(0.004);
    
    ResponsePixx('GetLoggedResponses',2);
end

ResponsePixx('StopNow',1); % stop response collection

progress_indication = sprintf('Block %d / %d',...
        session.current.blockNum, session.totalBlocks);
DrawFormattedText(session.window,progress_indication , 'center', 'center', session.instructions.colour);
Screen('Flip',session.window);
WaitSecs(3);

% if two middle buttons => abort, else => continue
if sum(find(resp(2,:))) == 7 % two middle buttons of the response box
    abortSession = 1;
    Datapixx('SetDoutValues', session.triggers(1).exp_aborted); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.004);
else
    abortSession = 0;
end

end

