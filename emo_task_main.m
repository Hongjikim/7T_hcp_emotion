%% main script for emotion task in fMRI

% setting: directory and subject information

% basedir = '/Users/hyebinkim/Dropbox/Cocoan lab/7T HCP/stimuli_candidates/git_7T_hcp_emotion';
basedir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates\git_7T_hcp_emotion';

% basedir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates/git_7T_hcp_emotion';

subj_id = input('Subject ID? (e.g., sub001): ', 's');

% make trial sequence for each subjects
emo_music_generate_trial_sequence(basedir, subj_id);

%% setting

ptb_drawformattedtext_disableClipping = 1;
bgcolor = 50;
text_color = 255;
fontsize = [28, 32, 41, 54];

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 2560/2 1440/2]; %[0 0 window_info.width window_info.height]; %for mac, [0 0 2560 1600];

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

white = 255;
red = [190 0 0];
blue = [0 85 169];
orange = [255 145 0];

%% setting (2)

% before run, load pre-made trial sequence

emo_cat =  {'amusement', 'v-joy', 'romance', 'sexual desire', 'surprise', ...
    'craving', 'anxiety', 'horror', 'v-sadness', 'anger', 'pain', ...
    'disgust', 'neutral', 'm-joy', 'beautiful', 'fear', 'm-sadness'};

% stim_dir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates';
% dat_dir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates/git_7T_hcp_emotion/data';

stim_dir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates';
dat_dir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates\git_7T_hcp_emotion\data';

% video -> ((stim(5sec) + fixation(5sec))*4 + filler(5sec) + fixation(5sec)) * 13
% music -> ((stim(5sec) + fixation(5sec))*3 + filler(5sec) + fixation(5sec)) * 4

%% run

Screen('Preference', 'SkipSyncTests', 1);
[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]
% Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');

% get s-key to start the run
% how long is the dummy scan in 7T?
% during dummy scan, display instruction ("please focus...")

runscan_starttime = GetSecs;

run_num = 1; % input

data.runscan_starttime = GetSecs; % run start timestamp
Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow)
waitsec_fromstarttime(runscan_starttime, 4) % baseline (blank) = 4 -> ??????ê°?? ëª?ì´??

data.loop_start_time{run_num} = GetSecs;
sTime = data.loop_start_time{run_num};
duration = 0;
test.loopstart{run_num} = GetSecs;

data.trial_sequence.emo_order = ts.emo_order{run_num};
data.trial_sequence.stim_order = ts.stim_order{run_num};

for block = 2:4 % numel(ts.emo_order{1,run_num}) % block: per emotion category
    
    emotion_num = ts.emo_order{1,run_num}(block);
    if emotion_num < 14 % video
        temp_stim_order = ts.stim_order{1,run_num}.video(emotion_num,:);
    else
        temp_stim_order = ts.stim_order{1,run_num}.music(emotion_num-13,:);
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
        
        % fixation display (5 seconds)
        data.dat{block}{trial}.fix_start_time = GetSecs;
        
        Screen('TextSize', theWindow, fontsize(3));
        fixation_point = double('+') ;
        DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(data.dat{block}{trial}.fix_start_time, 5);
        
        data.dat{block}{trial}.fix_end_time = GetSecs;
        data.dat{block}{trial}.trial_end_time = GetSecs;
    end
    
    % filler
    trial = trial+1;
    
    data.dat{block}{trial}.task = 'filler task';
    data.dat{block}{trial}.filler_start_time = GetSecs;
    
    msg = sprintf('filler task (simple math)');
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

Screen('TextSize', theWindow, fontsize(3));
DrawFormattedText(theWindow, double('¸ðµç °úÁ¦°¡ ³¡³µ½À´Ï´Ù. Àá½Ã ´ë±âÇØÁÖ¼¼¿ä.'), 'center', 'center', text_color);
Screen('Flip', theWindow);

% save data
nowtime = clock;
savename = fullfile(dat_dir, ['task_data_' subj_id '_' date '_' num2str(nowtime(4)) '_' num2str(nowtime(5)) '.mat']);
save(savename, 'data');

WaitSecs(5);
Screen('CloseAll');
%% Test one

Screen('Preference', 'SkipSyncTests', 1);
% Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]

a = GetSecs;

Screen('TextSize', theWindow, fontsize(3));
fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

waitsec_fromstarttime(a, 2);

% moviefile =  '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates/music/candidates_music/m14_joyful/6wlbB1PTzJU_0.mp3';
moviefile =  '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates/movie/candidates_video/v02_joy/0035.mp4';
playmode = 1;

% [moviePtr, dura, ] = Screen('OpenMovie', theWindow, moviefile);
[moviePtr, dura, fps, width, height]=Screen('OpenMovie', theWindow, moviefile);
scale_movie_w = width*(width/W);
scale_movie_h = height*(height/H)*(1);

new_rect = [W/2-scale_movie_w*(4.5/10) H*(0.5/10)-scale_movie_h*(1/10) ...
    W/2+scale_movie_w*(4.5/10) H*(1/10)+scale_movie_h*(8/10)];


% moviePtr = Screen('CreateMovie', theWindow, moviefile, 5, 5);

Screen('SetMovieTimeIndex', moviePtr,0);
Screen('PlayMovie', moviePtr, playmode); %Screen('PlayMovie?')% 0 == Stop playback, 1 == Normal speed forward, -1 == Normal speed backward,
t = GetSecs;

while GetSecs-t < dura %(~done) %~KbCheck
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', theWindow, moviePtr);
    
    if tex<=0
        % We're done, break out of loop:
        %done = 1;
        waitsec_fromstarttime(t,5);
        break;
    end
    %     Screen('DrawTexture', theWindow, tex, window_rect, window_rect);
    Screen('DrawTexture', theWindow, tex, [ ], new_rect);
    
    %         Screen('DrawTexture', theWindow, tex);
    
    Screen('Flip', theWindow)
    Screen('Close', tex);
    % Valid texture returned? A negative value means end of movie reached:
    
    
    % Update display:
    
end

Screen('TextSize', theWindow, fontsize(3));
fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

%% stim display - testmode

if emotion_num < 14 % video
    msg = sprintf(['test video category: ', emo_cat{emotion_num}, ...
        '\n stim num: ', num2str(stim_num)]);
else % music
    msg = sprintf(['test music category: ', emo_cat{emotion_num}, ...
        '\n stim num: ', num2str(stim_num)]);
end

Screen('TextSize', theWindow, fontsize(3));
DrawFormattedText(theWindow, msg, 'center', 'center', text_color);
Screen('Flip', theWindow);
waitsec_fromstarttime(data.dat{block}{trial}.stim_start_time, 5); % consider stim loading time
