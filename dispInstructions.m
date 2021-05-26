function dispInstructions(session)

ResponsePixx('StartNow',1); % start response collection
Screen('DrawTexture',session.window, session.instructions.infoTex);
Datapixx('SetDoutValues', session.triggers(1).block_info); % send TTL at the next register write
Screen('Flip',session.window);
Datapixx('RegWr');
WaitSecs(0.001);
ResponsePixx('GetLoggedResponses',2);
ResponsePixx('StopNow',1); % stop response collection

end

