% Clear the workspace and the screen
sca;
close all;
clearvars;

subjectID = input('subjectID: ', 's');
sessionID = input('sessionID: ', 's');


% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Initialize Vpixx
isOpen = Datapixx('Open'); % check if Vpixx screen is connected
if ~isOpen
    error('VIEWPixx not connected! Please check connection and try again');
end
PsychDataPixx('Open');
% switch to ScanningBacklight mode for full illumination only after pixels stabilize 
PsychDataPixx('EnableVideoScanningBacklight'); % comment for photodiode test
ResponsePixx('Close'); % to make sure open doesn't fail
ResponsePixx('Open');
Datapixx('EnableDinDebounce');
Datapixx('RegWr');

doutValue = bin2dec('0000 0000 0000 0000 0000 0000'); % initialize digital output
Datapixx('SetDoutValues', doutValue);
Datapixx('RegWr');

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);
bgColour     =  GrayIndex(screenNumber);

% [w, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColour);
[w, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColour, [0 0 1000 800]);
Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % this enables us to use the alpha transparency
% HideCursor;
Screen('TextSize', w, 40);

session = initSession(subjectID, sessionID, 5, 72, 72, 10, w, windowRect, round(bgColour*255));

session = runSession(session);

% save session
fileName = sprintf('..%cdata%cMasking_Sub_%d',filesep,filesep,session.subjectID);
try
    save(fileName,'session');
catch
    mkdir(sprintf('..%cdata',filesep));
    save(fileName,'session');
end

sca;
ResponsePixx('Close');
Datapixx('Close');