%% main script for emotion task in fMRI

% setting: directory and subject information

basedir = '/Users/hyebinkim/Dropbox/Cocoan lab/7T HCP/stimuli_candidates/git_7T_hcp_emotion';
subj_id = input('Subject ID? (e.g., sub001): ', 's');


% make trial sequence for each subjects
trial_sequece = emo_music_generate_trial_sequence(basedir, subj_id);
% save(sprintf('~~~.mat', 'trial_sequece'));

% goal

% no movie or music stimuli actually presented! 

% in the screen, display emo-category and filenames
% filler task: "filler"

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

%% 

% video -> (stim(5sec)*4 + fixation(5sec) + filler(5sec)) * 13
% music -> (stim(5sec)*3 + fixation(5sec) + filler(5sec)) * 4

% Screen('Preference', 'SkipSyncTests', 1);
% [theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]
% Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');

test.scanstart = GetSecs;
data.runscan_starttime = GetSecs; % run start timestamp
Screen(theWindow, 'FillRect', bgcolor, window_rect);

data.loop_start_time{story_num} = GetSecs;
sTime = data.loop_start_time{story_num};
duration = 0;
test.loopstart{story_num} = GetSecs;

for emotion = trial_sequece.emo_order{1,1}
    
    % video
    if emotion < 14  
        for stim = trial_sequece.stim_order{1,1}.video(emotion,:)
            Screen('TextSize', theWindow, fontsize(3));
            fixation_point = double('+') ;
            DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
            Screen('Flip', theWindow);
            waitsec_fromstarttime(data.runscan_starttime, 2);
            
            
        end
    
    % music
    else
        for stim = trial_sequece.stim_order{1,1}.music(emotion-13,:)

        end
    end
    
    % fixation
    Screen('TextSize', theWindow, fontsize(3));
    fixation_point = double('+') ;
    DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    
    % filler
    Screen('TextSize', theWindow, fontsize(3));
    fixation_point = double('+') ;
    DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    
end

%% Test one

Screen('Preference', 'SkipSyncTests', 1);
% Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]

Screen('TextSize', theWindow, fontsize(3));
fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);


Screen('CloseAll')