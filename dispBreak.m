function dispBreak(session)

ResponsePixx('StartNow',1); % start response collection
Screen('DrawTexture',w, session.instructions.breakTex);
Screen('Flip',w);
ResponsePixx('GetLoggedResponses',2);
ResponsePixx('StopNow',1); % stop response collection

end

