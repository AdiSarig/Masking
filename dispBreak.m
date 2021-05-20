function dispBreak(session)

ResponsePixx('StartNow',1); % start response collection
Screen('DrawTexture',session.window, session.instructions.breakTex);
Screen('Flip',session.window);
ResponsePixx('GetLoggedResponses',2);
ResponsePixx('StopNow',1); % stop response collection

end

