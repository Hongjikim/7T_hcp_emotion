function gradCPT_Memory_7T_v2 (varargin)
% memory test for gradCPT 
% % update 05/27/2020, KJ Tark
% % 2 s (1st Trial) - [stim (3 s) - fix (3 s)] x 80 trial - blank (6s, last trial) 
% 1 RUN = 2 + 480 + 6 = 488 sec = 244 TRs 
% 20 freq. + 20 infreq. images + 40 new image (20 indoor, 20 outoor images)

try
    main(varargin{:});
catch me % error handling
    ListenChar(0);
    fclose('all');
    Screen('CloseAll');
    ShowCursor();
	KbQueueRelease();
     
    fprintf(2, '\n\n???:: %s\n\n', me.message); % main error message
	for k = 1:(length(me.stack) - 1)
        current = me.stack(k);
        fprintf('Error in ==> ');
        fprintf('<a href="matlab: opentoline(''%s'',%d,0)">%s at %d</a>\n\n',...
            current.file, current.line, current.name, current.line);
	end
	fclose('all');
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  MAIN EXPERIMENT
function main(varargin)

fclose('all');
format short;
seed_init = ClockRandSeed;
% seed = ClockRandSeed;
seed = seed_init.Seed; 

Screen('Preference','SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);	% suppress display warning
Screen('Preference','SuppressAllWarnings', 1); % suppress text warning

global w cx cy
%--------------------------------------------- EXPERIMENT INFO.
% get user parameters
studyName = 'gradCPT';
SN = input('sub no: ', 's');
if length(SN) < 1; SN = '9999'; end;
subName = input('subName(KNY)?  ','s');		% get subject's initials from user
listen = input('listen (yes=1,no=2)?   ', 's');
RunID = input('Run number (1, 2, 3)?   ', 's');

SN = str2double(SN);
listen = str2double(listen);
RunID  = str2double(RunID);


% ----------------------------------------- CONFIG / STIMULI RELATED
% set experiment design
curr_dir = pwd;
if mod(SN,2)==1
    load('loadingfile/gradCPT_OddSub_loading.mat');
else
    load('loadingfile/gradCPT_EvenSub_loading.mat');
end

nTrials = 80;

%% TrialID, TestRunID, TrialID_old, RunID_old(new=3), in/out(1,2), test/notest(1=old,3=new) 
matTrial_test = matTrial_test(matTrial_test(:,2)==RunID,:);

for ii = 1:nTrials
    matTrial_test_imgname{ii} = matTrial_test_fname{nTrials*(RunID-1)+ii};
end

for i = 1:length(matTrial_test)
    if matTrial_test(i,6) == 1 & matTrial_test(i,5) == 1
        img_test{i}=  imread(fullfile(indoor_old_dir, matTrial_test_imgname{i}));
    elseif matTrial_test(i,6) == 1 & matTrial_test(i,5) == 2
        img_test{i}=  imread(fullfile(outdoor_old_dir, matTrial_test_imgname{i}));
    elseif matTrial_test(i,6) == 3 & matTrial_test(i,5) == 1
        img_test{i}=  imread(fullfile(indoor_new_dir, matTrial_test_imgname{i}));
    elseif matTrial_test(i,6) == 3 & matTrial_test(i,5) == 2
        img_test{i}=  imread(fullfile(outdoor_new_dir, matTrial_test_imgname{i}));
    end  
end

% ---------------------------------------------------- DATA SETUP
data_dir = fullfile(pwd, 'gradCPT_DataOut');
if ~exist(data_dir,'dir'); 	mkdir(data_dir); end;

% -------------------------------------------------- SCREEN SETUP
bcolor  = 125;	% background color
whichScreen = max(Screen('Screens')); % determining a dual monitor setup.

if listen == 1
    [w, screenRect] = Screen('OpenWindow', whichScreen, bcolor);
else
    [w, screenRect] = Screen('OpenWindow', whichScreen, bcolor, [0 0 1024 768]);
end

% Screen('TextFont', w, 'Arial');
[cx, cy] = RectCenter(screenRect);	% center

srcRect = [0, 0, 1024, 768];
srcRect = [0, 0, 1920, 1200];
dstRect = CenterRect(srcRect,screenRect);

% Removes the blue screen flash and minimize extraneous warnings.
oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);

% below see DrawHighQualityUnicodeTextDemo.m
Screen('Preference', 'TextRenderer', 1);	
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);
Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

Screen('TextFont', w, 'Arial');
Screen('TextSize',	w, 32);
Screen('TextColor', w, 255);
Screen('TextStyle', w, 0);

% ------------------------------------------------- TIMING SETUP
blanking = Screen('GetFlipInterval', w);

% ------------------------------------------------- STIMULUS SETUP
sTarg = [0 0 500 500]; % size of target
rectTarg = CenterRect(sTarg, screenRect);
offset = -40;
objSrcRect = sTarg;	% real size
objDstRect = OffsetRect(rectTarg, 0, offset);

% making fixation texture
fixation = ones(17,17);
fixation(8:10,:) = 0;
fixation(:,8:10) = 0;
fixation = fixation*bcolor;
texFix = Screen('MakeTexture', w, fixation);
fixSrcRect = RectOfMatrix(fixation); 
fixDstRect = OffsetRect(CenterRect(fixSrcRect,screenRect), 0, offset);
clear fixation;

% ------------------------------------------------- KEYBOARD INFO
%% KEYBOARD INFO
% % Type and print out deviceName: [keyboardIndex, deviceName, allInfo] = GetKeyboardIndices
% ===== Experimenter
kbStruct(1).product = 'Magic Keyboard with Numeric Keypad';	% MacBook Air
kbStruct(1).vendorID= 76;
% % ===== Participant
kbStruct(2).product = '932';	% Or, device(2).product = 'Current Designs, Inc.';
kbStruct(2).vendorID= 6171;	% list of vendor IDs for valid FORP devices 
% ===== Scanner
kbStruct(3).product = 'KeyWarrior8 Flex';	
kbStruct(3).vendorID= 1984;

if listen == 1
    Experimenter = IDKeyboards(kbStruct(1));
    Participant = IDKeyboards(kbStruct(2)); 
    Scanner = IDKeyboards(kbStruct(3));
else
    Experimenter = IDKeyboards(kbStruct(1)); 
    Participant = Experimenter; 
    Scanner = Experimenter;
end

KbName('UnifyKeyNames'); 
SPC = KbName('space');
GO	= KbName('s');
K1	= KbName('1!');		
K2	= KbName('2@');		
K3	= KbName('3#');		
K4	= KbName('4$');		

keysOfInterest = zeros(1,256);
keysOfInterest(KbName({'1!','2@','3#','4$'})) = 1;

HideCursor;
% ListenChar(2);

% ------------------------------------------------- OUTPUT FILE INFO.
baseName= sprintf('gradCPT_Mem_%i%s_%i', SN, subName, RunID);
fileName = ['datRaw' baseName '.txt'];	
dataFile = fopen(fullfile(data_dir, fileName), 'a');
fileName = ['datStm' baseName '.txt'];	
stimFile = fopen(fullfile(data_dir, fileName), 'a');
% paramName =sprintf('datVar%s_%s_%s.mat', baseName, datestr(now, 1), datestr(now, 13));
paramName =[baseName '.mat'];

%--------------------------------------------------------- LOG.
InitTime = datestr(now, 0);
fprintf(stimFile, '\n**********************\n%s\n', InitTime);
fprintf(		  '\n**********************\n%s\n', InitTime);
fprintf(stimFile, 'Random seed %f\n', seed);
fprintf(stimFile, 'FrameRate=%f %f\n*******\n\n', Screen(0,'FrameRate'),blanking);

%--------------------------------------------------------- START.
Screen('TextSize',	w, 23);
Screen('TextColor', w, 0);
% DrawFormattedText(w, txtStart, 'center', 'center');
Screen('FrameRect', w, 240, dstRect);

[inst_img, map, trans1] = imread('gradCPT_Memory_instruction.png','PNG');
[resp_img, map, trans2] = imread('gradCPT_Memory_resp.png','PNG');
inst_img(:,:,4) = trans1;
resp_img(:,:,4) = trans2;
inst_tex = Screen('MakeTexture', w, inst_img);
resp_tex = Screen('MakeTexture', w, resp_img); 
Screen('DrawTexture', w, inst_tex, sTarg, rectTarg);
Screen('DrawTexture', w, resp_tex, [0 0 500 100], [cx-250 cy+250+offset cx+250 cy+350+offset]);
% Screen('DrawText', w, sprintf('%10i %15i %15i %16i',1,2,3,4) , cx*.4, cy*1.2, [0 0 0]);
% Screen('DrawText', w,  'surely seen    seen    not seen    surely not seen', cx*0.4, cy*1.3, [0 0 0]);
Screen('Flip', w);

fprintf(		  '\n***** Task begins at %s\n', datestr(now, 0));
fprintf(stimFile, '\n***** Task begins at %s\n', datestr(now, 0));
fprintf(		  'SN RunID trial oldnew inoutdoor im_no im_name TrialDur keyResp RT \n');
fprintf(stimFile, 'SN RunID trial oldnew inoutdoor im_no im_name TrialDur keyResp RT \n');
                
KbQueueCreate(Participant, keysOfInterest);
KbQueueStart(Participant);

while 1
	[keyIsDown, initExpt, keyCode] = KbCheck(Scanner);
	if keyIsDown
		if keyCode(GO)
			break;
		end
	end
end

StartTime = GetSecs;
for trial=1:length(matTrial_test) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRIAL LOOP BEGINS
    KbQueueFlush(Participant);
    
	% ------------ Presenting fixation
    StartTrial(trial) = GetSecs;
	if trial == 1        
        Screen('DrawTexture', w, texFix, fixSrcRect, fixDstRect);
        Screen('DrawTexture', w, resp_tex, [0 0 500 100], [cx-250 cy+250+offset cx+250 cy+350+offset]);
        Screen('FrameRect', w, 240, dstRect);
        Screen('Flip', w);
        while GetSecs - StartTrial(trial) < 2
        end
    end

	% ------------ Prepare for a new trial
    xPic = img_test{trial};
	texObj = Screen('MakeTexture', w, xPic);
	clear xPic;		

	% ------------ Presenting stimuli
    StartStim(trial) = GetSecs; 
	Screen('DrawTexture', w, texObj, objSrcRect, objDstRect);
	Screen('FrameRect', w, 240, dstRect);
    Screen('DrawTexture', w, resp_tex, [0 0 500 100], [cx-250 cy+250+offset cx+250 cy+350+offset]);
	initStim = Screen('Flip', w);
    while GetSecs - StartStim(trial) < 3
    end

    % ------------ Presenting fixation
	Screen('DrawTexture', w, texFix, fixSrcRect, fixDstRect);
    Screen('DrawTexture', w, resp_tex, [0 0 500 100], [cx-250 cy+250+offset cx+250 cy+350+offset]);
    Screen('FrameRect', w, 240, dstRect);
	Screen('Flip', w);
    while GetSecs - StartStim(trial) < 5.5
    end
    
    % Response check 
    [pressed, firstPress, fR, lastPress] = KbQueueCheck(Participant);
	if pressed
%         firstP = min(firstPress(keysOfInterest==1));
        firstP  = min(firstPress(firstPress ~= 0)); 
        if firstP ~= 0 
            xKey1(trial) = find(firstPress == firstP);
            xRT(trial) = firstP - StartStim(trial);
        else
            xKey1(trial) = -99;
            xRT(trial) = -999;
        end
    else
        xKey1(trial) = -99;
        xRT(trial) = -999;
    end
    xResp(trial) = -88;
    if xKey1(trial) == K1, xResp(trial)=1; end % sure old
    if xKey1(trial) == K2, xResp(trial)=2; end % old
    if xKey1(trial) == K3, xResp(trial)=3; end % new
    if xKey1(trial) == K4, xResp(trial)=4; end % sure new
    
    % fix color change 
    if trial == length(matTrial_test)
        while GetSecs - StartStim(trial) < 6+6
        end  
    else        
        Screen('DrawTexture', w, texFix, fixSrcRect, fixDstRect);
        Screen('DrawTexture', w, resp_tex, [0 0 500 100], [cx-250 cy+250+offset cx+250 cy+350+offset]);
        Screen('FrameRect', w, 240, dstRect);
        Screen('Flip', w);
        while GetSecs - StartStim(trial) < 6
        end
    end
    TrialDur(trial) = GetSecs - StartTrial(trial);
    
%% TrialID, TestRunID, TrialID_old, RunID_old(new=3), in/out(1,2), test/notest(1=old,3=new) 
	fprintf(		 '%i\t %i\t %i\t %d\t %d\t %i\t %s\t %2.4f\t %i\t %2.4f\n', ...
					SN, RunID, trial, matTrial_test(trial,6), matTrial_test(trial,5), ...
                    matTrial_test(trial,1), matTrial_test_imgname{trial}, TrialDur(trial), xResp(trial), xRT(trial))
	fprintf(stimFile, '%i\t %i\t %i\t %d\t %d\t %i\t %s\t %2.4f\t %i\t %2.4f\n', ...
					SN, RunID, trial, matTrial_test(trial,6), matTrial_test(trial,5), ...
                    matTrial_test(trial,1), matTrial_test_imgname{trial}, TrialDur(trial), xResp(trial), xRT(trial));
	fprintf(dataFile, '%i\t %i\t %i\t %d\t %d\t %i\t %2.4f\t %i\t %2.4f\n', ...
					SN, RunID, trial, matTrial_test(trial,6), matTrial_test(trial,5), ...
                    matTrial_test(trial,1), TrialDur(trial), xResp(trial), xRT(trial));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRIAL LOOP ENDS
end
EndTime = GetSecs;
RunDuration = EndTime-StartTime;

fprintf(stimFile, '***** Task ends at %s\n', datestr(now, 0));
fprintf(stimFile, '***** Run duration = %2.4f\n', RunDuration);
fprintf(		  '***** Task ends at %s\n', datestr(now, 0));
fprintf(		  '***** Run duration = %2.4f\n', RunDuration);

KbQueueRelease(Participant);
fclose(dataFile);
fclose(stimFile);
save(fullfile(data_dir, paramName), ...
    'RunDuration', 'nTrials', 'TrialDur', 'matTrial_test_imgname', ...
    'xResp', 'xRT', 'matTrial_test');

Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);

% clean up and go home
fclose('all');
ListenChar(0);
ShowCursor;
Screen('CloseAll');

return



function deviceIndex = IDKeyboards (kbStruct)
	devices	= PsychHID('Devices');
	kbs		= find([devices(:).usageValue]==6); % value of keyboard
	
	deviceIndex = [];
	for mm=1:length(kbs)
		if strcmp(devices(kbs(mm)).product,kbStruct.product) && ...
				ismember(devices(kbs(mm)).vendorID, kbStruct.vendorID)
			deviceIndex = kbs(mm);
		end
	end
	
	if isempty(deviceIndex)
		error('No %s detected on the system',kbStruct.product);
	end
return
%-------------------------------- EOF.
