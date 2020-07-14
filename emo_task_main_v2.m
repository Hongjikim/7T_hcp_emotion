%% main script for emotion task in fMRI

% Run emotion task in CNIR_7T_HCP project
%
% :::Inputs:::
% 1) subject number
% 2) subject name initial 
% 3) run number (1 or 2) 
% 4) listen (1 = sync to MRI, 2 = no sync, default is 1)
%
% :::Outputs:::
% 1) trial sequence per participant
% 2) task data per run (total 2)
%   
%
% ..
%    Copyright (C) 2020 COCOAN lab
%    contact: Hongji Kim (redkim94@hanmail.net)
%
%

%% Directory and subject information

[basedir, dat_dir, stim_dir, ts_dir] = set_directory('7T_mri'); % 'hj_mac'
% [basedir, dat_dir, stim_dir, ts_dir] = set_directory('byeolmac'); % 'hj_mac'

start_input.subj_id = ['sub', input('Subject number? (e.g., 1001): ', 's')];
start_input.subj_initial = input('Subject initial? (e.g., ABC): ', 's');
start_input.run_num = input('Run number? (e.g., 1 or 2): ');
start_input.listen = 1; % str2double(input('Listen for scanner 1=yes, 2=no     >> ','s'));

data.input = start_input; 

% make/load trial_sequence
while true
    ts_fname = filenames(fullfile(ts_dir, ['trial_sequence*' start_input.subj_id '*.mat']), 'char');
    if size(ts_fname,1) == 1
        if contains(ts_fname, 'no matches found') % no ts file
            emo_music_generate_trial_sequence(basedir, start_input.subj_id); % make ts
        else
            load(ts_fname); break;
        end
    elseif size(ts_fname,1)>1
        error('There are more than one ts file. Please check and delete the wrong files.')
    elseif size(ts_fname,1) == 0 % 7T MRI Mac
        emo_music_generate_trial_sequence(basedir, start_input.subj_id); % make ts
    end
end


%% Setting

emo_cat =  {'amusement', 'v-joy', 'romance', 'sexual desire', 'surprise', ...
    'craving', 'anxiety', 'horror', 'v-sadness', 'anger', 'pain', ...
    'disgust', 'neutral', 'm-joy', 'beautiful', 'fear', 'm-sadness'};

% screen set up
screens = Screen('Screens');
window_num = max(screens);
% window_num = max(Screen('Screens'));
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]; % 7T MRI Mac
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

% check resolution
assert(W==1920&&H==1200, 'The monitor resolution is not 1920*1200');

% text location
textH = H/2.3;
r = [0 0 0 0];
stim_loc{1} = CenterRectOnPoint(r, W*0.4, H*0.3);
stim_loc{2} = CenterRectOnPoint(r, W*0.45, H*0.3);
stim_loc{3} = CenterRectOnPoint(r, W*0.5, H*0.3);
stim_loc{4} = CenterRectOnPoint(r, W*0.55, H*0.3);
stim_loc{5} = CenterRectOnPoint(r, W*0.6, H*0.3);
ans_loc{1} = CenterRectOnPoint(r, W*0.3, H*0.65);
ans_loc{2} = CenterRectOnPoint(r, W*0.7, H*0.65);
stim_mpoint = CenterRectOnPoint(r, W*0.45, H*0.5);
mathset.stim_loc = stim_loc; mathset.ans_loc = ans_loc; mathset.stim_mpoint = stim_mpoint;

% fontsize
ptb_drawformattedtext_disableClipping = 1;
fontsize = [28, 32, 41, 60];
mathset.txtsize1 = fontsize(4); mathset.txtsize3 = fontsize(4);

% color
black = 0;
white = 255;
red = [190 0 0];
blue = [0 85 169];
orange = [255 145 0];
bgcolor = 50;
text_color = white;
mathset.correct_color = white; mathset.wrong_color = white;

% calculation problems
n_block = numel(ts.emo_order{start_input.run_num});
[~,~,mathprob] = xlsread(fullfile(basedir, 'Maths_stimuli.xlsx'));
math_stim = mathprob(2:n_block+1,6)';
math_anws = cell2mat(mathprob(2:n_block+1,7))';
randomizer = randperm(n_block,n_block);
math_stim = math_stim(randomizer); 
math_anws = math_anws(randomizer); 

% time interval
mathset.present_rate = 1; 
mathset.present_time = 5; 
mathset.task_time = 4;
mathset.feedback_time = 1;
mathset.trl_time = mathset.present_time + mathset.task_time + mathset.feedback_time;

%% device set up

Screen('Preference', 'SkipSyncTests', 1);
[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor);
% Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');

% how long is the dummy scan in 7T?
% during dummy scan, display instruction ("please focus...")

data.runscan_starttime = GetSecs; % run start timestamp
Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow);

HideCursor;

[keyboardIndex, deviceName, allInfo] = GetKeyboardIndices;
% ===== Experimenter
device(1).product = 'Magic Keyboard with Numeric Keypad';
device(1).vendorID = 76;
% % ===== Participant
device(2).product = '932';
device(2).vendorID = 6171;
% ===== Scanner
device(3).product = 'KeyWarrior8 Flex';
device(3).vendorID = 1984;

if start_input.listen == 1
    Experimenter = IDKeyboards(device(1));
    Participant = IDKeyboards(device(2)); 
    Scanner = IDKeyboards(device(3));
else
    Experimenter =[]; Scanner = []; Participant =[];
end

% keyboard
KbName('UnifyKeyNames');
syncNum = KbName('s');
Abort = KbName('q');
Space = KbName('space');
O = KbName('1!');
X = KbName('2@');
% O = KbName('z');
% X = KbName('x');
keys = [O X]; mathset.keys = keys;

done = 0;
scanPulse=0;

%% sync with scanner 
% during dummy scan, show instruction
Screen('TextSize', theWindow, fontsize(3));
instruction_msg = double('Please focus on the movie/music (s)');
DrawFormattedText(theWindow, instruction_msg, 'center', 'center', text_color);
Screen('Flip', theWindow);

if start_input.listen == 1
    while scanPulse~=1 %wait for a pulse
        [keyIsDown, ~, keyCode] = KbCheck(Scanner);
        if keyIsDown
            if keyCode(syncNum)
                scanPulse = 1;
                data.s_key_receive_time = GetSecs; 
                break;
            end
        end
    end
elseif start_input.listen == 2
    while(~done)
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        if keyCode(syncNum)
            done = 1;
        end
    end
elseif start_input.listen == 3
    WaitSecs(1);
    data.s_key_receive_time = GetSecs; 
end

Screen('TextSize', theWindow, fontsize(3));
fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

%% TASK START
waitsec_fromstarttime(data.s_key_receive_time, 16); % baseline (blank)

data.loop_start_time{start_input.run_num} = GetSecs;

data.trial_sequence.emo_order = ts.emo_order{start_input.run_num};
data.trial_sequence.stim_order = ts.stim_order{start_input.run_num};
data.trial_sequence.math_order = math_stim{1:n_block};

for block = 1:n_block % block: per emotion category
    
    emotion_num = ts.emo_order{1,start_input.run_num}(block);
    
    if emotion_num < 14 % video
        temp_stim_order = ts.stim_order{1,start_input.run_num}.video(emotion_num,:);
    else
        temp_stim_order = ts.stim_order{1,start_input.run_num}.music(emotion_num-13,:);
    end
    
    fix_duration = [];
    while mean(fix_duration) ~= 4
        fix_duration = randi([3 5], 1, numel(temp_stim_order));
    end
    
    for trial = 1:numel(temp_stim_order)% trial: per one video/music
        
        stim_num = temp_stim_order(trial); % stimulus number (e.g., joy001)
        
        target_file = set_stim_dir(stim_dir, emotion_num, stim_num);
        
        data.dat{block}{trial}.trial_start_time = GetSecs;
        data.dat{block}{trial}.emotion_category = emo_cat{emotion_num};
        data.dat{block}{trial}.randomized_stim_order = temp_stim_order;
        data.dat{block}{trial}.target_stim_number = stim_num;
        data.dat{block}{trial}.target_filename = target_file;
        
        % stim display (5 seconds)
        
        playmode = 1;
        [moviePtr, dura] = Screen('OpenMovie', theWindow, target_file);
        Screen('SetMovieTimeIndex', moviePtr,0);
        %         moviePtr = Screen('CreateMovie', windowPtr, movieFile [, width][, height]);
        
        Screen('PlayMovie', moviePtr, playmode); % 0 == Stop playback, 1 == Normal speed forward, -1 == Normal speed backward,
        data.dat{block}{trial}.stim_start_time = GetSecs;
        
        while GetSecs - data.dat{block}{trial}.stim_start_time < 5 %(~done) %~KbCheck
            % Wait for next movie frame, retrieve texture handle to it
            tex = Screen('GetMovieImage', theWindow, moviePtr);
            
            if tex<=0
                waitsec_fromstarttime(data.dat{block}{trial}.stim_start_time,5);
                break;
            end
            
            Screen('DrawTexture', theWindow, tex);
            Screen('Flip', theWindow)
            Screen('Close', tex);
        end
        
        data.dat{block}{trial}.stim_end_time = GetSecs;
        
        % fixation display (3/4/5 seconds)
        data.dat{block}{trial}.fix_start_time = GetSecs;
        
        Screen('TextSize', theWindow, fontsize(3));
        fixation_point = double('+') ;
        DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(data.dat{block}{trial}.fix_start_time, fix_duration(trial));
        
        data.dat{block}{trial}.fix_end_time = GetSecs;
        data.dat{block}{trial}.fix_duration = fix_duration(trial);
        data.dat{block}{trial}.trial_end_time = GetSecs;
    end
    
    % === filler ===
    trial = trial+1;
    
    data.dat{block}{trial}.task = 'filler task';
    data.dat{block}{trial}.filler_start_time = GetSecs;
    data.dat{block}{trial}.filler_stimulus = math_stim{block};
    
    % calculation preparation
    cnum = math_stim{block};
    plusidx  = find(ismember(cnum,'+'));
    minusidx = find(ismember(cnum,'-'));
    equalidx = find(ismember(cnum,'='));
    n3 = cnum(equalidx+1:end); s2 = '=';
    if ~isempty(minusidx)
        n1 = cnum(1:minusidx-1); n2 = cnum(minusidx+1:equalidx-1);
        s1 = '-';
    elseif ~isempty(plusidx)
        n1 = cnum(1:plusidx-1); n2 = cnum(plusidx+1:equalidx-1);
        s1 = '+';
    end
    cnum={}; cnum{1}=n1; cnum{2}=s1; cnum{3}=n2; cnum{4}=s2; cnum{5}=n3;
    
    % calculation presentation (0s)
    Screen('TextSize', theWindow, fontsize(4));
    for n = 1:length(stim_loc)
        stim_time = GetSecs; ii = 1;
        while ii <= n
            DrawFormattedText(theWindow, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), white);
            ii = ii + 1;
        end
        Screen(theWindow,'Flip');
%         while GetSecs - stim_time < 0.1; end
    end
    
    ii = 1;
    while ii <= length(stim_loc)
        if ii == length(stim_loc)
            DrawFormattedText(theWindow, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), white);
        else
            DrawFormattedText(theWindow, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), white);
        end
        ii = ii + 1;
    end
    
    % 'Correct?' (1s)
%     DrawFormattedText(theWindow, ['Is ' cnum{end} ' correct?'], stim_mpoint(3), stim_mpoint(4), black);
    DrawFormattedText(theWindow, 'O', ans_loc{1}(3), ans_loc{1}(4), white);
    DrawFormattedText(theWindow, 'X', ans_loc{2}(3), ans_loc{2}(4), white);
    Screen(theWindow,'Flip');
    
    % rt start (1~5s)
    rt_start = GetSecs; 
    selection = []; 
    
    while GetSecs - rt_start < 4.5
        [keyisdown,~,keycode,~] = KbCheck(Participant);
        if keyisdown 
            if keycode(O)
                rt_end = GetSecs;
                selection = O;
                if math_anws(block); response = 1; else response = 0; end
                feedback_screen(theWindow,response,selection,cnum,mathset); Screen(theWindow,'Flip');
            elseif keycode(X)
                rt_end = GetSecs;
                selection = X;
                if math_anws(block); response = 0; else response = 1; end
                feedback_screen(theWindow,response,selection,cnum,mathset); Screen(theWindow,'Flip');
            end
        end
        clear keyisdown keycode;
    end
    
    if isempty(selection)
        rt_end = NaN; response = 0;
        feedback_screen(theWindow,response,selection,cnum,mathset);
        Screen(theWindow,'Flip');
    end
    
    disp(['=== RT is ' num2str(rt_end - rt_start) 's, response is ' num2str(response)]);

    data.dat{block}{trial}.response = response;
    data.dat{block}{trial}.response_time = rt_end - rt_start;
    data.dat{block}{trial}.filler_end_time = GetSecs;
    disp(['=== filler time: ' num2str(data.dat{block}{trial}.filler_end_time - data.dat{block}{trial}.filler_start_time) 's']);

    waitsec_fromstarttime(data.dat{block}{trial}.filler_start_time, 5);
    
    % fixation display (5 seconds)
    Screen('TextSize', theWindow, fontsize(3));
    fixation_point = double('+') ;
    DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
    Screen('Flip', theWindow);    
    waitsec_fromstarttime(data.dat{block}{trial}.filler_start_time, 10);
    data.dat{block}{trial}.block_end_time = GetSecs;
end

data.runscan_end_time = GetSecs;

Screen('TextSize', theWindow, fontsize(3));
DrawFormattedText(theWindow, double('This run is done. Please wait.'), 'center', 'center', text_color);
Screen('Flip', theWindow);

% save data
nowtime = clock;
savename = fullfile(dat_dir, ['taskdata_' start_input.subj_id '_run' num2str(start_input.run_num, '%.2d') '_' date '_' num2str(nowtime(4)) '_' num2str(nowtime(5)) '.mat']);
save(savename, 'data');

WaitSecs(5);
Screen('CloseAll');

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
end
