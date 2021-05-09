function pixelTrigger = dispStimulus(session)

global GL

textureToDisp = session.blocks(session.current.blockNum).trials(session.current.trialNum).stimulusTexture;
Screen('DrawTextures', session.window, textureToDisp, [], session.stim.location, 0, 0);

% Draw pixel trigger
pixelTrigger = double(session.stim.triggers.image);
glRasterPos2d(session.center(1), session.center(2)-200);
glDrawPixels(size(pixelTrigger, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(pixelTrigger));

end