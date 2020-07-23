%% Setting

% Clear the workspace
close all;
clear;
sca;

% Directory
basedir = '/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/git_7T_hcp_emotion/hb';
% v01_amusement 
stim_dir = '/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/exp_stimuli/video_stimuli/v01_amusement';

% Color
white = 255;
bgcolor = 50;

% Screen size
screens = Screen('Screens');
window_num = screens(end); 
window_info = Screen('Resolution', window_num);
% window_rect = [0 0 1200 800];
window_rect = [0 0 window_info.width window_info.height];
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

% Center of the screen
xCenter = window_rect(3)/2;
yCenter = window_rect(4)/2;

%% Run

% Open screen
Screen('Preference', 'SkipSyncTests', 1);
[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);

% Fixation 1sec
Screen(theWindow, 'FillRect', bgcolor, window_rect);
drawFixationCross(theWindow, window_rect, 15, white, 4)
Screen('Flip', theWindow)
WaitSecs(1);

% amusement video
% video = [0074, 0080, 0574, 0578, 0910, 1043, 1697, 1801];
video = [0074, 0080];

for i = 1:size(video,2)
    
    % find movie file
    target_file = strcat(num2str(video(i)),'_test.mp4');
    target_file_dir = fullfile(stim_dir, target_file);
    
    [moviePtr, dura] = Screen('OpenMovie', theWindow, target_file_dir);
    Screen('SetMovieTimeIndex', moviePtr,  0);
    Screen('PlayMovie', moviePtr, 1);
    
    stim_start_time = GetSecs;
    % Stim 5sec
    while GetSecs - stim_start_time < 5
        tex = Screen('GetMovieImage', theWindow, moviePtr);       
        if tex <= 0
            waitsec_fromstarttime(stim_start_time, 5);
            break;
        end
        
        Screen('DrawTexture', theWindow, tex);
        Screen('Flip', theWindow)
        Screen('Close', tex);
    end
end


% Close
Screen(theWindow, 'FillRect', bgcolor, window_rect);
drawFixationCross(theWindow, window_rect, 15, white, 4)
Screen('Flip', theWindow)
WaitSecs(1);
Screen('CloseAll');