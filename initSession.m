function session = initSession(subjectID, sessionID, totalBlocks, AtrialsPerBlock, BtrialsPerBlock, probeTrialsPerBlock, w, windowRect, bg)
trialsPerBlock = AtrialsPerBlock + BtrialsPerBlock;

%% General info
session.window = w;
session.windowRect = windowRect;
session.center = [windowRect(3)/2, windowRect(4)/2];
session.subjectID = subjectID;
session.sessionID = sessionID;
session.CreationTime = datestr(now);
session.matlabVersion = version;
session.trialsPerBlock = trialsPerBlock;
session.totalBlocks = totalBlocks;
session.current.blockNum = 1;
session.current.trialNum = 1;

%% Instructions
session.instructions.intermissionText = 'Press shift+a to abort experiment. \nPress any other key to continue.';
session.instructions.folderPath = 'instructions';
session.instructions.fileExtension = '.tif';
session.instructions.font = 'Comic Sans MS';
session.instructions.colour = 0;

infoFilePattern = fullfile(session.instructions.folderPath, char(strcat('*', session.instructions.fileExtension)));
infofileNames = dir(infoFilePattern);
breakPath = sprintf('%s%cbreak.tif',infofileNames(1).folder, filesep);
breakImg = imread(breakPath);
session.instructions.breakTex = Screen('MakeTexture', session.window, breakImg);

endPath = sprintf('%s%cEnd.tif',infofileNames(1).folder, filesep);
endImg = imread(endPath);
session.instructions.endTex = Screen('MakeTexture', session.window, endImg);


Screen('TextFont', session.window ,session.instructions.font);

%% Timing parameters
session.timing.ifi = Screen('GetFlipInterval',session.window);
if 1/session.timing.ifi< 115 || 1/session.timing.ifi> 125                   % abort if refresh rate isn't 120 hz
    ResponsePixx('Close');Datapixx('Close');sca
    error('Screen refresh rate should be set to 120 hz')
end

% Remove one frame duration from timing for accuracy
session.timing.fix1Dur = 0.7 - session.timing.ifi;
session.timing.CFixDur = 0.1 - session.timing.ifi;
session.timing.maskDur = 0.1 - session.timing.ifi;
session.timing.stimDur = 0.033 - session.timing.ifi;

%% Stimuli
session.stim.face.folderPath = 'faceStim';
session.stim.house.folderPath = 'houseStim';
session.stim.fileExtension = '.pcx';

halfStimSize = 175/2; % visual degree 4.42 X 4.42
session.stim.location = round([session.windowRect(3:4)/2-halfStimSize, session.windowRect(3:4)/2+halfStimSize]);

faceFilePattern = fullfile(session.stim.face.folderPath, char(strcat('*', session.stim.fileExtension)));
houseFilePattern = fullfile(session.stim.house.folderPath, char(strcat('*', session.stim.fileExtension)));

session.stim.face.fileNames = dir(faceFilePattern);
for i = 1:size(session.stim.face.fileNames)
    imPath = sprintf('%s%c%s',session.stim.face.fileNames(i).folder, filesep, session.stim.face.fileNames(i).name);
    img = imread(imPath);
    img = addNoise(img, .25, 80);
    session.stim.face.textures(i) = Screen('MakeTexture', session.window, img);
end

session.stim.house.fileNames = dir(houseFilePattern);
for i = 1:size(session.stim.house.fileNames)
    imPath = sprintf('%s%c%s',session.stim.house.fileNames(i).folder, filesep, session.stim.house.fileNames(i).name);
    img = imread(imPath);
    img = addNoise(img, .25, 80);
    session.stim.house.textures(i) = Screen('MakeTexture', session.window, img);
end

% Create noise stimuli
for i = 1:size(session.stim.house.fileNames)
    imPath = sprintf('%s%c%s',session.stim.house.fileNames(i).folder, filesep, session.stim.house.fileNames(i).name);
    img = imread(imPath);
    img = addNoise(img, .5, 80);
    session.stim.noise.textures(i) = Screen('MakeTexture', session.window, img);
end

for i = 1:totalBlocks
    session.blocks(i).trials = initTrialInfo(AtrialsPerBlock, BtrialsPerBlock, probeTrialsPerBlock, session.stim.face.textures, session.stim.house.textures, session.stim.noise.textures);
end

% create pixel triggers
vpix_trig=uint8([bg+2 bg-2 bg+2 bg-2 bg+2 bg-2 bg+2 bg-2,...
    bg+2 bg-3 bg+2 bg-3 bg+2 bg-3 bg+2 bg-3,...
    bg+3 bg-2 bg+3 bg-2 bg+3 bg-2 bg+3 bg-2;...
    bg+2 bg-2 bg+2 bg-2 bg+2 bg-2 bg+2 bg-2,...
    bg+2 bg-3 bg+2 bg-3 bg+2 bg-3 bg+2 bg-3,...
    bg+3 bg-2 bg+3 bg-2 bg+3 bg-2 bg+3 bg-2;...
    bg+2 bg-2 bg+2 bg-2 bg+2 bg-2 bg+2 bg-2,...
    bg+2 bg-3 bg+2 bg-3 bg+2 bg-3 bg+2 bg-3,...
    bg+3 bg-2 bg+3 bg-2 bg+3 bg-2 bg+3 bg-2]);

session.stim.triggers.image = vpix_trig(:,1:8);       % image trigger
session.stim.triggers.fix = vpix_trig(:,9:16);        % fixation trigger
session.stim.triggers.mask = vpix_trig(:,17:24);      % mask trigger

% allTrials = initTrialInfo(AtrialsPerBlock*totalBlocks, BtrialsPerBlock*totalBlocks, probeTrialsPerBlock*totalBlocks)
% for i = 1:totalBlocks
%     session.blocks(i) = allTrials(((i-1)*trialsPerBlock)+1:(i*trialsPerBlock)+1)
% end

end

% [WARNING]: Probe occurance random. Not ballanced between trials A and B
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


function noised = addNoise(img, noiseRatio, gray)
shape = size(img);
totalPix = shape(1)*shape(2);
toFlip = datasample(1:totalPix, round(totalPix*noiseRatio), 'Replace',false);
img(toFlip) = 255 * ~img(toFlip);

img(img==255) = img(img==255) - gray;
img(img==0) = img(img==0) + gray;

noised = img;

end
