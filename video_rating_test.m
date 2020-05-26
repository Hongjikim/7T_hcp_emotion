%% Stim Sequence(Video)

video_cat =  {'amusement', 'v-joy', 'romance', 'sexual desire', 'surprise', ...
    'craving', 'anxiety', 'horror', 'v-sadness', 'anger', 'pain', ...
    'disgust', 'neutral'};

% row -> emotion_num(1~13), column -> stim_num(1~8)
rng('shuffle');
stim_order = reshape(randperm(104),13,8);

% save stim order
data.stim_order = stim_order;

%%

global theWindow W H; % window property
global white red orange blue bgcolor; % color
global fontsize window_rect rT; % rating scale

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

rT = 10;

%% Start

Screen('Preference', 'SkipSyncTests', 1);
[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);%[0 0 2560/2 1440/2]
Screen('TextSize', theWindow, fontsize);

% viewing the practice prompt until click.
while (1)
    [~, ~, button] = GetMouse(theWindow);
    [~,~,keyCode] = KbCheck;

    if button(1)
        break
    elseif keyCode(KbName('q'))==1
        abort_man;
    end
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    msg = double('Start(click)');
    DrawFormattedText(theWindow, msg, 'center', 'center', white, [], [], [], 1.5);
    Screen('Flip', theWindow);
end

% 2 seconds: "please focus..."
ratingdata.run_starttime = GetSecs; % run start timestamp
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('please focus...'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(ratingdata.run_starttime, 2);

% Blank
Screen(theWindow,'FillRect',bgcolor, window_rect);
Screen('Flip', theWindow);

% 4 seconds from the runstart
waitsec_fromstarttime(taskdata.runscan_starttime, 4);

%% Display text, Rating

for trial = 1 % repeat for 140 trials (trial: per one video)
    
    [emotion_num,stim_num] = ind2sub(size(stim_order),find(stim_order==trial));
    
    msg = sprintf(['test video category: ', video_cat{emotion_num},'\n stim num: ', num2str(stim_num)]);
    Screen('TextSize', theWindow, fontsize);
    DrawFormattedText(theWindow, msg, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    WaitSecs(3)
        
    % rating    Screen(theWindow,'FillRect',bgcolor, window_rect);
    msg = double('Choose one emotion');
    DrawFormattedText(theWindow, msg, 'center', 'center', white, [], [], [], 1.5);
    Screen('Flip', theWindow);
    WaitSecs(2)
     
    emotion_rating(GetSecs); % sub-function: 10s
    
    % Blank
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    WaitSecs(2);

end

%%

function [emotion_word, trajectory_time, trajectory] = emotion_rating(starttime)

global W H orange bgcolor window_rect theWindow red rT

[choice, xy_rect] = display_emotion_words(1);

% SetMouse(880, 500);
SetMouse(W/2, H/2);

trajectory = [];
trajectory_time = [];

j = 0;

while(1)
    j = j + 1;
    [x, y, button] = GetMouse(theWindow);
    mx = x*1.1;
    my = y*1.1;
    
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    display_emotion_words(1);
    Screen('DrawDots', theWindow, [mx my], 10, orange, [0, 0], 1); % draw orange dot on the cursor
    Screen('Flip', theWindow);
    
    trajectory(j,:) = [mx my];                  % trajectory of location of cursor
    trajectory_time(j) = GetSecs - starttime; % trajectory of time
    
    if trajectory_time(end) >= rT  % maximum time of rating is 8s
        button(1) = true;
    end
    
    if button(1)  % After click, the color of cursor dot changes.
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        display_emotion_words(1);
        Screen('DrawDots', theWindow, [mx;my], 10, red, [0 0], 1);
        Screen('Flip', theWindow);
        
        % which word based on x y from mouse click
        choice_idx = mx > xy_rect(:,1) & mx < xy_rect(:,3) & my > xy_rect(:,2) & my < xy_rect(:,4);
        if any(choice_idx)
            emotion_word = choice{choice_idx};
        else
            emotion_word = '';
        end
        
        WaitSecs(0.3);   
        
        break;
    end
end

end

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

choice =  {'amusement', 'v-joy', 'romance', 'sexual desire', 'surprise', ...
    'craving', 'anxiety', 'horror', 'v-sadness', 'anger', 'pain', ...
    'disgust', 'neutral', ''};
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