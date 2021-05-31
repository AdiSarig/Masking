function abortSession = dispInstructions(session)

ResponsePixx('StartNow',1); % start response collection
Screen('DrawTexture',session.window, session.instructions.infoTex);
Datapixx('SetDoutValues', session.triggers(1).block_info); % send TTL at the next register write
Screen('Flip',session.window);
Datapixx('RegWr');
WaitSecs(0.001);
resp = ResponsePixx('GetLoggedResponses',2);
ResponsePixx('StopNow',1); % stop response collection

% if two middle buttons => abort, else => continue
if sum(find(resp(2,:))) == 7 % two middle buttons of the response box
    abortSession = 1;
    Datapixx('SetDoutValues', session.triggers(1).exp_aborted); % send TTL at the next register write
    Datapixx('RegWr');
    WaitSecs(0.001);
else
    abortSession = 0;
end

end

