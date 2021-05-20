function dispCheckerboard(session)

toTexture = repmat(eye(2), 4, 4);
checkerTexture = Screen('MakeTexture', session.window, toTexture);

Screen('DrawTextures', session.window, checkerTexture, [], session.stim.location, 0, 0);

end
