function previewStim(session)
% Get subjects familiar with the stimuli

ResponsePixx('StartNow',1); % start response collection

Screen('DrawTextures', session.window, session.instructions.previewTex);
Screen('Flip',session.window);
ResponsePixx('GetLoggedResponses',2);

for ind = 1:length(session.stim.face.textures)
    
    % display face
    Screen('DrawTextures', session.window, session.stim.face.textures(ind));
    Screen('Flip',session.window);
    ResponsePixx('GetLoggedResponses',2);
    
    % display house
    Screen('DrawTextures', session.window, session.stim.house.textures(ind));
    Screen('Flip',session.window);
    ResponsePixx('GetLoggedResponses',2);
end

ResponsePixx('StopNow',1); % stop response collection

end
