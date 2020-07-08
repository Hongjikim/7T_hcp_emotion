%% main script for emotion task in fMRI

% setting: directory and subject information

% addpath(genpath('/Users/7t_mri/Desktop/CocoanLab_emotion_task')); savepath;

% [basedir, dat_dir, stim_dir, ts_dir] = set_directory('hj_mac'); 
[basedir, dat_dir, stim_dir, ts_dir] = set_directory('7T_mri'); % 'hj_mac'

subj_id = input('Subject ID? (e.g., sub001): ', 's');

emo_cat =  {'amusement', 'v-joy', 'romance', 'sexual desire', 'surprise', ...
    'craving', 'anxiety', 'horror', 'v-sadness', 'anger', 'pain', ...
    'disgust', 'neutral', 'm-joy', 'beautiful', 'fear', 'm-sadness'};

% make/load trial_sequence
while true
    ts_fname = filenames(fullfile(ts_dir, ['trial_sequence*' subj_id '*.mat']), 'char');
    if size(ts_fname,1) == 1
        if contains(ts_fname, 'no matches found') % no ts file
            emo_music_generate_trial_sequence(basedir, subj_id); % make ts
        else
            load(ts_fname); break;
        end
    elseif size(ts_fname,1)>1
        error('There are more than one ts file. Please check and delete the wrong files.')
    elseif size(ts_fname,1) == 0 % 7T MRI Mac
        emo_music_generate_trial_sequence(basedir, subj_id); % make ts
    end
end

run_num = input('Run number? (e.g., 1): ');

listen = 1; % str2double(input('Listen for scanner 1=yes, 2=no     >> ','s'));

%% Setting

ptb_drawformattedtext_disableClipping = 1;
bgcolor = 50;
text_color = 255;
fontsize = [28, 32, 41, 54];

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
% window_rect = [0 0 2560/2 1440/2]; %[0 0 window_info.width window_info.height]; %for mac, [0 0 2560 1600];
window_rect = [0 0 window_info.width window_info.height]; % 7T MRI Mac

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

white = 255;
red = [190 0 0];
blue = [0 85 169];
orange = [255 145 0];
%% run

Screen('Preference', 'SkipSyncTests', 1);
[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]
% Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');

% how long is the dummy scan in 7T?
% during dummy scan, display instruction ("please focus...")

data.runscan_starttime = GetSecs; % run start timestamp
Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow)
%%
% HideCursor;

% s key

%% old
% Listen for scanner
% if isnan(listen)
%     listen = 2;
% end
% [keyboardIndex, deviceName, allInfo] = GetKeyboardIndices;
% 
%  % ===== Experimenter
% device(1).product = 'Magic Keyboard with Numeric Keypad';
% device(1).vendorID= 76;
% % % ===== Participant
% device(2).product = '932';
% device(2).vendorID= [1240 6171];
% % ===== Scanner
% device(3).product = 'KeyWarrior8 Flex';
% device(3).vendorID= 1984;
% 
% if listen == 1
%     Experimenter = IDKeyboards(device(1));
%     %Participant = IDKeyboards(device(2));
% %         Scanner = IDKeyboards(device(1));
% else
%     Experimenter =[]; Scanner = []; Participant =[];
% end
% 
% % keyboard
% KbName('UnifyKeyNames');
% syncNum = KbName('s');
% Abort = KbName('q');
% Space = KbName('space');
% 
% done = 0;
% scanPulse=0;

%% new (NY)
HideCursor;

% ===== Experimenter
device(1).product = 'Magic Keyboard with Numeric Keypad';
device(1).vendorID= 76;
% % ===== Participant
device(2).product = '932';
device(2).vendorID= [1240 6171];
% ===== Scanner
device(3).product = 'KeyWarrior8 Flex';
device(3).vendorID= 1984;

if listen == 1
    Experimenter = IDKeyboards(device(1));
    %Participant = IDKeyboards(device(2));
    Scanner = IDKeyboards(device(3));
else
    Experimenter =[]; Scanner = []; Participant =[];
end

% keyboard
KbName('UnifyKeyNames');
syncNum = KbName('s');
Abort = KbName('q');
Space = KbName('space');

done = 0;
scanPulse=0;

%%
% during dummy scan, show instruction
    Screen('TextSize', theWindow, fontsize(3));
    instruction_msg = double('Please focus on the video/music clips. (s)');
    DrawFormattedText(theWindow, instruction_msg, 'center', 'center', text_color);
    Screen('Flip', theWindow);

if listen == 1
    while scanPulse~=1 %wait for a pulse
        [keyIsDown, ~, keyCode] = KbCheck(Scanner);
%                 [keyIsDown, ~, keyCode] = KbCheck(Experimenter);

        if keyIsDown
            if keyCode(syncNum)
                scanPulse = 1;
                data.s_key_receive_time = GetSecs; 
                break;
            end
        end
    end
elseif listen == 2
    while(~done)
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        if keyCode(syncNum)
            done = 1;
        end
    end
end

Screen('TextSize', theWindow, fontsize(3));
fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

%%
% baseline (16 seconds)
waitsec_fromstarttime(data.s_key_receive_time, 16); % baseline (blank)

data.loop_start_time{run_num} = GetSecs;

data.trial_sequence.emo_order = ts.emo_order{run_num};
data.trial_sequence.stim_order = ts.stim_order{run_num};

for block = 1:numel(ts.emo_order{1,run_num}) % block: per emotion category
    
    emotion_num = ts.emo_order{1,run_num}(block);
    
    if emotion_num < 14 % video
        temp_stim_order = ts.stim_order{1,run_num}.video(emotion_num,:);
    else
        temp_stim_order = ts.stim_order{1,run_num}.music(emotion_num-13,:);
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
        
        while GetSecs-data.dat{block}{trial}.stim_start_time < 5 %(~done) %~KbCheck
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
    
    % filler
    trial = trial+1;
    
    data.dat{block}{trial}.task = 'filler task';
    data.dat{block}{trial}.filler_start_time = GetSecs;
    
    msg = sprintf('simple math task');
    Screen('TextSize', theWindow, fontsize(3));
    DrawFormattedText(theWindow, msg, 'center', 'center', white, [], [], [], 1.5);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(data.dat{block}{trial}.filler_start_time, 5);
    
    data.dat{block}{trial}.filler_end_time = GetSecs;
    
    % fixation display (5 seconds)
    data.dat{block}{trial}.fix_start_time = GetSecs;
    
    Screen('TextSize', theWindow, fontsize(3));
    fixation_point = double('+') ;
    DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    waitsec_fromstarttime(data.dat{block}{trial}.fix_start_time, 5);
    
    data.dat{block}{trial}.fix_end_time = GetSecs;
    
end

data.runscan_end_time = GetSecs;

Screen('TextSize', theWindow, fontsize(3));
DrawFormattedText(theWindow, double('This run is done. Please wait.'), 'center', 'center', text_color);
Screen('Flip', theWindow);

% save data
nowtime = clock;
savename = fullfile(dat_dir, ['task_data_' subj_id '_run' num2str(run_num) '_' date '_' num2str(nowtime(4)) '_' num2str(nowtime(5)) '.mat']);
save(savename, 'data');

WaitSecs(5);
Screen('CloseAll');
