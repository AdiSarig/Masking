function session = initSession(subjectID, sessionID, totalBlocks, AtrialsPerBlock, BtrialsPerBlock, probeTrialsPerBlock, w, windowRect)
    trialsPerBlock = AtrialsPerBlock + BtrialsPerBlock;
    
    session.window = w;
    session.windowRect = windowRect;
    session.subjectID = subjectID;
    session.sessionID = sessionID;
    session.CreationTime = datestr(now);
    session.matlabVersion = version;
    session.trialsPerBlock = trialsPerBlock;
    session.totalBlocks = totalBlocks;
    session.current.blockNum = 1;
    session.current.trialNum = 1;
    session.intermissionText = 'Press shift+a to abort experiment. \nPress any other key to continue.';
    session.stim.face.folderPath = 'faceStim';
    session.stim.house.folderPath = 'houseStim';
    session.stim.fileExtension = '.pcx';
    session.instructions.folderPath = 'instructions';
    session.instructions.fileExtension = '.tif';
    session.instructions.font = 'Comic Sans MS';
    session.instructions.colour = 0;
    
    halfStimSize = 238/2; % visual degree 6X6
    session.stim.location = round([session.windowRect(3:4)/2-halfStimSize, session.windowRect(3:4)/2+halfStimSize]);
    
    faceFilePattern = fullfile(session.stim.face.folderPath, char(strcat('*', session.stim.fileExtension)));
    houseFilePattern = fullfile(session.stim.house.folderPath, char(strcat('*', session.stim.fileExtension)));
    
    session.stim.face.fileNames = dir(faceFilePattern);
    for i = 1:size(session.stim.face.fileNames)
        imPath = sprintf('%s%c%s',session.stim.face.fileNames(i).folder, filesep, session.stim.face.fileNames(i).name);
        [img, color_map] = imread(imPath);
        img = addNoise(img, .25);
        session.stim.face.textures(i) = Screen('MakeTexture', session.window, ind2rgb(img, color_map));
    end

    session.stim.house.fileNames = dir(houseFilePattern);
    for i = 1:size(session.stim.house.fileNames)
        imPath = sprintf('%s%c%s',session.stim.house.fileNames(i).folder, filesep, session.stim.house.fileNames(i).name);
        [img, color_map] = imread(imPath);
        img = addNoise(img, .25);
        session.stim.house.textures(i) = Screen('MakeTexture', session.window, ind2rgb(img, color_map));
    end
       
    % Create noise stimuli
    for i = 1:size(session.stim.house.fileNames)
        imPath = sprintf('%s%c%s',session.stim.house.fileNames(i).folder, filesep, session.stim.house.fileNames(i).name);
        [img, color_map] = imread(imPath);
        img = addNoise(img, .5);
        session.stim.noise.textures(i) = Screen('MakeTexture', session.window, ind2rgb(img, color_map));
    end
    
    infoFilePattern = fullfile(session.instructions.folderPath, char(strcat('*', session.instructions.fileExtension)));
    infofileNames = dir(infoFilePattern);
    breakPath = sprintf('%s%c%s',infofileNames(1).folder, filesep, 'break.tif');
    breakImg = imread(breakPath);
    session.instructions.breakTex = Screen('MakeTexture', session.window, breakImg);
    
    Screen('TextFont', session.window ,session.instructions.font);
    
    for i = 1:totalBlocks
        session.blocks(i).trials = initTrialInfo(AtrialsPerBlock, BtrialsPerBlock, probeTrialsPerBlock, session.stim.face.textures, session.stim.house.textures, session.stim.noise.textures);
    end
    
    % allTrials = initTrialInfo(AtrialsPerBlock*totalBlocks, BtrialsPerBlock*totalBlocks, probeTrialsPerBlock*totalBlocks)
    % for i = 1:totalBlocks
    %     session.blocks(i) = allTrials(((i-1)*trialsPerBlock)+1:(i*trialsPerBlock)+1)
    % end
    
end

% [WARNING]: Probe occurance random. Not ballanced between trials A and B
% [WARNING]: Face/house/noise occurance random. Not ballanced between trials A and B
function allTrials = initTrialInfo(totalAtrials, totalBtrials, totalProbeTrials, faceTextures, houseTextures, noiseTextures)
    totalTrials = totalAtrials + totalBtrials;
    % check there is the right number of stimuli
    faceTexturesShape = size(faceTextures);
    houseTexturesShape = size(houseTextures);
    noiseTexturesShape = size(noiseTextures);
    if totalTrials ~= 4*(faceTexturesShape(2) + houseTexturesShape(2) + noiseTexturesShape(2))
        error(strcat('Error: expected totalFaceTextures = totalHouseTextures = totalNoiseTextures = trialsPerBlock/12 but found: ', string(faceTexturesShape(2)), ' face textures, ', string(houseTexturesShape(2)), ' house textures, and ', string(noiseTexturesShape(2)),'noise textures for ', string(totalTrials), ' trialsPerBlock'));
    end
    
    for i = 1:totalAtrials
        trials(i).isTypeA = 1;
        trials(i).hasProbe = 0;
    end
    for i = totalAtrials+1:totalTrials
        trials(i).isTypeA = 0;
        trials(i).hasProbe = 0;
    end
    for i = datasample(1:totalTrials,totalProbeTrials,'Replace',false)
        trials(i).hasProbe = 1;
    end
    
    
%     trials = trials(randperm(totalTrials));

%     trials(:).stimulus.texture = [ faceTextures houseTextures addNoise(faceTextures, .5)];
%     trials(:).stimulus.type = [ repmat('face',[1 faceTexturesShape(2)]) repmat('house',[1 houseTexturesShape(2)]) repmat('noise',[1 faceTexturesShape(2)])];
    
    textures = num2cell(repmat([ faceTextures houseTextures noiseTextures],1,4));
    types = repmat(repelem({'face', 'house', 'noise'},1,12),1,4);

    [trials(:).stimulusTexture] = textures{:};
    [trials(:).stimulusType] = types{:};

    allTrials = trials(randperm(totalTrials));
    
end
% five blocks of 144 trials (48 faces, 48 houses, 48 noise stimuli, so that each stimulus repeated four times within a block).
% 5 blocks
% 144 trials
% half A, half B
% ~15% probed

% [xCenter, yCenter] = RectCenter(session.windowRect);
% dstRect = session.windowRect;
% dstRect = CenterRectOnPointd(dstRect, xCenter, yCenter);
% Screen('DrawTextures', session.window, checkerTexture, [], dstRect, 0, 0);
%


function noised = addNoise(img, noiseRatio)
    shape = size(img);
    totalPix = shape(1)*shape(2);
    toFlip = datasample(1:totalPix, round(totalPix*noiseRatio), 'Replace',false);
    img(toFlip) = 255 * ~img(toFlip);
    
    noised = img;
    
end