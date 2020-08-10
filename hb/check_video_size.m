%% Setting

% Clear the workspace
close all;
clear;
sca;

% big size
% stim_dir = '/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/exp_stimuli/video_stimuli/big_size';
% video = {'0074_1024.mp4', '0089_1024.mp4', '0380_1028.mp4', '1468_1026.mp4', '1938_1026.mp4', '1953_1028.mp4'};

% middle size
% stim_dir = '/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/exp_stimuli/video_stimuli/middle_size';
% video = {'0074_800.mp4', '0089_800.mp4', '0380_804.mp4', '1468_800.mp4', '1938_800.mp4', '1953_800.mp4'};

% small size
stim_dir = '/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/exp_stimuli/video_stimuli/small_size';
video = {'0074_600.mp4', '0089_602.mp4', '0380_600.mp4', '1468_602.mp4', '1938_602.mp4', '1953_600.mp4'};

% Color
white = 255;
bgcolor = 50;

% Screen size
screens = Screen('Screens');
window_num = screens(end); 
window_info = Screen('Resolution', window_num);
% window_rect = [0 0 1920 1200]; %7T mac
% window_rect = [0 0 window_info.width window_info.height];
window_rect = [0 0 1000 800];
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

% Center of the screen
xCenter = window_rect(3)/2;
yCenter = window_rect(4)/2;

%% Run

% Open screen
Screen('Preference', 'SkipSyncTests', 1);
[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);

% Korean instruction
inst_data = imread('korean_instruction.png');
inst_texture = Screen('MakeTexture', theWindow, inst_data);
Screen('DrawTexture', theWindow, inst_texture);
Screen('Flip', theWindow);
WaitSecs(5);

% Fixation 1sec
Screen(theWindow, 'FillRect', bgcolor, window_rect);
drawFixationCross(theWindow, window_rect, 15, white, 4);
Screen('Flip', theWindow);
WaitSecs(1);

for i = 1:size(video,2)
    
    target_file_dir = fullfile(stim_dir, video{i});  
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
        Screen('Flip', theWindow);
        Screen('Close', tex);
    end
end


% Close
Screen(theWindow, 'FillRect', bgcolor, window_rect);
drawFixationCross(theWindow, window_rect, 15, white, 4);
Screen('Flip', theWindow);
WaitSecs(1);
Screen('CloseAll');