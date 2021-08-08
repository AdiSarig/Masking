function dispStimulus(session)

block_num = session.current.blockNum;
trial_num = session.current.trialNum;

if ~strcmp(session.blocks(block_num).trials(trial_num).stimulusType,'noise')
    textureToDisp = session.blocks(block_num).trials(trial_num).stimulusTexture;
    Screen('DrawTextures', session.window, textureToDisp, [], session.stim.location, 0, 0);
end

end