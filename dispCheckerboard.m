function pixelTrigger = dispCheckerboard(session)

global GL

toTexture = repmat(eye(2), 4, 4);
checkerTexture = Screen('MakeTexture', session.window, toTexture);

Screen('DrawTextures', session.window, checkerTexture, [], session.stim.location, 0, 0);

% Draw pixel trigger
pixelTrigger = double(session.stim.triggers.mask);
glRasterPos2d(session.center(1), session.center(2)-200);
glDrawPixels(size(pixelTrigger, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(pixelTrigger));

end
