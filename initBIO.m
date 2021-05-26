function triggers = initBIO(session)
%% this is Leemor's version of the triggers! 

%% General
triggers.init_Dout = 0;    % main - end of exp
triggers.exp_start = 250;  % runSession - before running loops
triggers.exp_end   = 251;  % runSession - after end screen
triggers.exp_aborted   = 252;  % dispIntermission - after end screen

triggers.block_info   = 240;  % dispInstructions - after flip
triggers.block_start  = 241;  % runSession - after reading instructions
triggers.block_end    = 242;  % runSession - before break

triggers.trial_start = 230; % dispIntermission - after response collection
triggers.trial_end   = 231; % runTrial - last flip (end of sequence)

%% Trial trigger sequence:
triggers.C_face   = 200; % runTrial - present stimulus
triggers.UC_face  = 201; % runTrial - present stimulus
triggers.C_house  = 202; % runTrial - present stimulus
triggers.UC_house = 203; % runTrial - present stimulus
triggers.C_noise  = 204; % runTrial - present stimulus
triggers.UC_noise = 205; % runTrial - present stimulus

triggers.fix  = 150; % runTrial - present fixation
triggers.mask = 151; % runTrial - present mask

triggers.hasProbe = 160; % runTrial - in the first hasProbe condition

%% Responses:
triggers.resp        = 180; % runTrial - send to response schedule
triggers.resp_hit    = 190; % hit - correct response when should be
triggers.resp_miss   = 191; % miss - no response when should be
triggers.resp_FA     = 192; % false alarm - response when shouldn't be
triggers.resp_CR     = 193; % correct rejection - no response when shouldn't be
triggers.resp_error  = 199; % wrong button

%% Convert to binary for Vpixx digital output
trigNames = fieldnames(triggers);
trigBin = convertTriggers(triggers);
trigBinstruct = cell2struct(trigBin,trigNames);
triggers = [trigBinstruct triggers];

%% Trial numbers (1:144)
trials = num2cell(1:session.trialsPerBlock);
[trialNum(1:session.trialsPerBlock).num] = trials{:};

%% More conversion
trigBin = convertTriggers(trialNum);
[trialNum(1:session.trialsPerBlock).numBin] = trigBin{:};

%% Assignment
triggers(1).trialNum   = trialNum;

end

