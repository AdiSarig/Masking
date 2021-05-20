function dispStimulus(session)

textureToDisp = session.blocks(session.current.blockNum).trials(session.current.trialNum).stimulusTexture;
Screen('DrawTextures', session.window, textureToDisp, [], session.stim.location, 0, 0);

end