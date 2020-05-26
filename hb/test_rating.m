%% Stim sequence

basedir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates\git_7T_hcp_emotion';
subj_id = input('Subject ID? (e.g., sub001): ', 's');
% make trial sequence for each subjects
emo_music_generate_trial_sequence(basedir, subj_id);

%% setting 

ptb_drawformattedtext_disableClipping = 1;
bgcolor = 50;
text_color = 255;
% fontsize = [28, 32, 41, 54];
fontsize = 30;

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

%% Start

Screen('Preference', 'SkipSyncTests', 1);
[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]
Screen('TextSize', theWindow, fontsize);

% 4 seconds: "please focus..."
ratingdata.run_starttime = GetSecs; % run start timestamp
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('please focus...'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(ratingdata.run_starttime, 4);

% Blank
Screen(theWindow,'FillRect',bgcolor, window_rect);
Screen('Flip', theWindow);

% 10 seconds from the runstart
waitsec_fromstarttime(taskdata.runscan_starttime, 10);

%% Show video

for stim = 1:numel(stim_sequence)   % repeat for 40 trials
    taskdata.dat{ts_i}.trial_starttime = GetSecs; % trial start timestamp
    display_target_word(ts{ts_i}{1}); % sub-function, display two generated words
    if USE_EYELINK
        Eyelink('Message','Task Words present');
    end
    waitsec_fromstarttime(taskdata.dat{ts_i}.trial_starttime, wordT); % for 15s

%%






%%

function [choice, xy_rect] = display_emotion_words(z)

global W H white theWindow window_rect bgcolor square fontsize

square = [0 0 140 80];  % size of square of word
r=350;
t=360/28;
theta=[t, t*3, t*5, t*7, t*9, t*11, t*13, t*15, t*17, t*19, t*21, t*23, t*25, t*27];
xy=[W/2+r*cosd(theta(1)) H/2-r*sind(theta(1)); W/2+r*cosd(theta(2)) H/2-r*sind(theta(2)); ...
    W/2+r*cosd(theta(3)) H/2-r*sind(theta(3)); W/2+r*cosd(theta(4)) H/2-r*sind(theta(4));...
    W/2+r*cosd(theta(5)) H/2-r*sind(theta(5)); W/2+r*cosd(theta(6)) H/2-r*sind(theta(6));...
    W/2+r*cosd(theta(7)) H/2-r*sind(theta(7)); W/2+r*cosd(theta(8)) H/2-r*sind(theta(8));...
    W/2+r*cosd(theta(9)) H/2-r*sind(theta(9)); W/2+r*cosd(theta(10)) H/2-r*sind(theta(10));...
    W/2+r*cosd(theta(11)) H/2-r*sind(theta(11)); W/2+r*cosd(theta(12)) H/2-r*sind(theta(12));...
    W/2+r*cosd(theta(13)) H/2-r*sind(theta(13)); W/2+r*cosd(theta(14)) H/2-r*sind(theta(14))];

xy_word = [xy(:,1)-square(3)/2, xy(:,2)-square(4)/2-15, xy(:,1)+square(3)/2, xy(:,2)+square(4)/2];
xy_rect = [xy(:,1)-square(3)/2, xy(:,2)-square(4)/2, xy(:,1)+square(3)/2, xy(:,2)+square(4)/2];

colors = 200;

%% words

choice = {'amusement', 'v-joy', 'romance', 'sexual desire', 'surprise', ...
    'craving', 'anxiety', 'horror', 'v-sadness', 'anger', 'pain', ...
    'disgust', 'neutral', 'm-joy', 'beautiful', 'fear', 'm-sadness'};
choice = choice(z);

%%
Screen(theWindow,'FillRect',bgcolor, window_rect);
Screen('TextSize', theWindow, fontsize);
% Rectangle
for i = 1:numel(theta)
    Screen('FrameRect', theWindow, colors, CenterRectOnPoint(square,xy(i,1),xy(i,2)),3);
end
% Choice letter
for i = 1:numel(choice)
    DrawFormattedText(theWindow, double(choice{i}), 'center', 'center', white, [],[],[],[],[],xy_word(i,:));
end

end