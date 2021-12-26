function triggers = initBIO(session)
%% this is Leemor's version of the triggers! 

%% General
triggers.init_Dout = 0;    % main - end of exp
triggers.exp_start = 40;  % runSession - before running loops
triggers.exp_end   = 41;  % runSession - after end screen
triggers.exp_aborted = 42;  % dispIntermission - after end screen

triggers.block_start  = 30;  % runSession - after reading instructions
triggers.block_end    = 31;  % runSession - before break
triggers.block_info   = 32;  % dispInstructions - after flip

triggers.trial_start = 20; % dispIntermission - after response collection
triggers.trial_end   = 21; % runTrial - last flip (end of sequence)

%% Trial trigger sequence:
triggers.C_face   = 10; % runTrial - present stimulus
triggers.UC_face  = 11; % runTrial - present stimulus
triggers.C_house  = 12; % runTrial - present stimulus
triggers.UC_house = 13; % runTrial - present stimulus
triggers.C_noise  = 14; % runTrial - present stimulus
triggers.UC_noise = 15; % runTrial - present stimulus

triggers.fix  = 50; % runTrial - present fixation
triggers.mask = 60; % runTrial - present mask

triggers.interval = 65; % runTrial - flicker fixation
triggers.hasProbe = 70; % runTrial - in the first hasProbe condition
triggers.PAS = 75; % runTrial - only during the second session (2AFC)

%% Responses:
triggers.resp        = 80; % runTrial - send to response schedule
triggers.resp_hit    = 90; % hit - correct response when should be
triggers.resp_miss   = 91; % miss - no response when should be
triggers.resp_FA     = 92; % false alarm - response when shouldn't be
triggers.resp_CR     = 93; % correct rejection - no response when shouldn't be
triggers.resp_error  = 99; % wrong button

%% Convert to binary for Vpixx digital output
trigNames = fieldnames(triggers);
trigBin = convertTriggers(triggers);
trigBinstruct = cell2struct(trigBin,trigNames);
triggers = [trigBinstruct triggers];

%% Trial numbers (100:244)
trials = num2cell(101:session.trialsPerBlock+100);
[trialNum(1:session.trialsPerBlock).num] = trials{:};

%% More conversion
trigBin = convertTriggers(trialNum);
[trialNum(1:session.trialsPerBlock).numBin] = trigBin{:};

%% Assignment
triggers(1).trialNum   = trialNum;

end

