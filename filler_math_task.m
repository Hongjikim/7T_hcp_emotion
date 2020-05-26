%% filler: Maths task

expName = 'calc';
file_path = pwd;

[~,~,data] = xlsread([file_path '/maths_stim1.xlsx']);

% Stimuli coding %

init.present_rate = 1; init.present_time = 5; init.feedback_time = 1;
numbers = {}; correct = {}; conds = {};
for i = 1:size(data,1)-1
    ii = 1 + length(numbers);
    
    numbers{ii} = data{i+1,6}; numbers{ii+1} = data{i+1,8};
    correct{ii} = data{i+1,7}; correct{ii+1} = data{i+1,9};
    conds{ii} = 'easy'; conds{ii+1} = 'hard';
end

    
Ntrl = length(numbers);
% Stimuli randomization %
randomizer = randperm(Ntrl,Ntrl);

% Parameter settings %
init.txtsize1 = 40;
init.txtsize2 = 200;
init.txtsize3 = 60;
init.iti = 2; % = 1TR
init.task_time = 4;
%init.present_reward = 2;
%init.trl_time = init.iti + init.present_time + init.task_time + init.feedback_time + init.present_reward;
init.trl_time = init.iti + init.present_time + init.task_time + init.feedback_time;
init.randomizer = randomizer;
stim = numbers(randomizer); init.presentOrder.stimuli = stim;
anss = correct(randomizer); init.presentOrder.correct = anss;
cons = conds(randomizer); init.presentOrder.conditions = cons;

task.data_t = NaN(Ntrl,8); task.rt = NaN(Ntrl,3); task.answer = NaN(Ntrl,1);

%% experiment %%
% Set up
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
FlushEvents;
%HideCursor;
PsychDefaultSetup(1);

% Screen set up %
screens = Screen('Screens'); %count the screen
whichScreen = max(screens); %select the screen;
white = BlackIndex(whichScreen); black = WhiteIndex(whichScreen);
grey = [130 130 130];
%correct_color = [0 220 0]; wrong_color = [250 0 0];
%correct_color = white; wrong_color = [130 130 130];
correct_color = white; wrong_color = white;
init.correct_color = correct_color; init.wrong_color = wrong_color;

%[w, rect] = Screen('OpenWindow', whichScreen, black);
[w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1024 768]);
% img = screencapture(0,'Position',[0 310 1024 768]); % screenshot function
% screenshot(0,[0 310 1024 768],'/home/hun/Downloads/experiments/series/imgs/fixX');
Screen('FillRect', w, white);
Screen('TextSize', w, init.txtsize1);
% Load instruction
inst = imread('maths_instruction.png');
instscreen = Screen('MakeTexture',w,inst);
Screen('DrawTexture',w,instscreen,[],rect);

Screen(w,'Flip');

% Location specs %
r = [0 0 0 0];

    stim_loc{3} = CenterRectOnPoint(r, rect(3)*0.5, rect(4)*0.3);
    stim_loc{4} = CenterRectOnPoint(r, rect(3)*0.6, rect(4)*0.3);
    stim_loc{5} = CenterRectOnPoint(r, rect(3)*0.7, rect(4)*0.3);
    stim_loc{1} = CenterRectOnPoint(r, rect(3)*0.3, rect(4)*0.3);
    stim_loc{2} = CenterRectOnPoint(r, rect(3)*0.4, rect(4)*0.3);

ans_loc{1} = CenterRectOnPoint(r, rect(3)*0.3, rect(4)*0.65);
ans_loc{2} = CenterRectOnPoint(r, rect(3)*0.7, rect(4)*0.65);
stim_mpoint = CenterRectOnPoint(r, rect(3)*0.4, rect(4)*0.5);
init.stim_loc = stim_loc; init.ans_loc = ans_loc; init.stim_mpoint = stim_mpoint;

%r = [0 0 300 250];
%reward_loc = CenterRectOnPoint(r, rect(3)*0.5, rect(4)*0.5);

% keyboard setup %
KbName('UnifyKeyNames');
syncNum = KbName('s');
L = KbName('1!');
R = KbName('2@');
fliprate = Screen(w, 'GetFlipInterval');
keys = [L R]; init.keys = keys;
% Receive a scanpulse %
done = 0;
scanPulse=0;
while scanPulse~=1
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(syncNum)
            scanPulse = 1;
            break;
        end
    end
end
task.exp_start = GetSecs;

Screen('FillRect', w, grey);
DrawFormattedText(w, '+', 'center', 'center', black);
Screen(w,'Flip');

WaitSecs(10); scores = 0;
%task_start = GetSecs;

for trl = 1:length(stim)
    task.data_t(trl,1) = GetSecs;
    Screen('TextSize', w, init.txtsize1);
    % ---- fixation cross (ITI)
    %Screen('TextSize', w, init.fixX_size);
    DrawFormattedText(w, '+', 'center', 'center', black);
    Screen(w,'Flip'); %t2 = init.trial_length - (GetSecs - t1);
    
    if strcmp(expName,'series')==1
        cn = str2num(stim{trl}); cnum = {};
        for i = 1:length(cn)
            cnum{i} = num2str(cn(i));
        end
    elseif strcmp(expName,'calc')==1
        cnum = stim{trl};
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
    end
    ccond = cons{trl}; cans = anss{trl};
    while GetSecs - task.data_t(trl,1) < init.iti - fliprate; end
    task.data_t(trl,2) = GetSecs;
    disp(['Elapsed Time for ITI: ' num2str(task.data_t(trl,2) - task.data_t(trl,1)) 's']);
    % ---- Stimuli presentation
    for n = 1:length(stim_loc)
        stim_time = GetSecs; ii = 1;
        while ii <= n
            DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), black);
            ii = ii + 1;
        end
        Screen(w,'Flip');
        %WaitSecs(0.1);
        %fname = [expName '_n' num2str(n)];
        %screenshot(0,[0 310 1024 768],['/home/hun/Downloads/experiments/series/imgs/' fname]);
        while GetSecs - stim_time < init.present_rate; end
    end
    task.data_t(trl,3) = GetSecs;
    disp(['Elapsed Time for Stimuli Presentation: ' num2str(task.data_t(trl,3) - task.data_t(trl,1)) 's']);
    % ---- Wait for an answer
    %Screen('FrameRect',w,[0 220 0],stim_loc{end},2); ii = 1;
    ii = 1;
    while ii <= length(stim_loc)
        if ii == length(stim_loc)
            %DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), correct_color);
            DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), black);
        else
            %DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), black);
            DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), correct_color);
        end
        ii = ii + 1;
    end
    DrawFormattedText(w, ['Is ' cnum{end} ' correct?'], stim_mpoint(3), stim_mpoint(4), black);
    Screen('TextSize', w, init.txtsize3);
    DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), correct_color);
    DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), correct_color);
    %Screen('TextSize', w, init.txtsize2);
    Screen(w,'Flip');
    %screenshot(0,[0 310 1024 768],['/home/hun/Downloads/experiments/series/imgs/' expName '_Q']);
    rt_start = GetSecs; selection = []; task.data_t(trl,4) = rt_start;
    while GetSecs - rt_start < init.task_time
        [keyisdown,~,keycode,~] = KbCheck;
        if keyisdown % && isnan(task.rt(trial,state))
            if keycode(keys(1))
                task.data_t(trl,5) = GetSecs;
                selection = keys(1);
                if strcmp(cans,'True') == 1; response = 1; else; response = 0; end
                feedback_screen(w,response,selection,cnum,init); Screen(w,'Flip');
            elseif keycode(keys(2))
                task.data_t(trl,5) = GetSecs;
                selection = keys(2);
                if strcmp(cans,'False') == 1; response = 1; else; response = 0; end
                feedback_screen(w,response,selection,cnum,init); Screen(w,'Flip');
            end
        end
        clear keyisdown keycode;
    end
    if isempty(selection)
        task.data_t(trl,5) = NaN; response = 0;
        feedback_screen(w,response,selection,cnum,init);
        Screen(w,'Flip');
        %screenshot(0,[0 310 1024 768],['/home/hun/Downloads/experiments/series/imgs/' expName '_A']);
    end
    scores = scores + response;
    %     while GetSecs - task.data_t(trl,3) < init.task_time + init.feedback_time; end
    %     task.data_t(trl,6) = GetSecs;
    %     disp(['Elapsed Time for Feedback: ' num2str(task.data_t(trl,6) - task.data_t(trl,1))]);
    %     % ---- reward screen
    %     rewscreen = Screen('MakeTexture',w,reward);
    %     Screen('DrawTexture',w,rewscreen,[],reward_loc);
    %     Screen('TextSize', w, init.txtsize3);
    %     DrawFormattedText(w, '50', 'center', 'center', white);
    %     Screen('TextSize', w, init.txtsize2);
    %     switch response
    %         case 1
    %             DrawFormattedText(w, 'O', 'center', 'center', correct_color);
    %         case 0
    %             DrawFormattedText(w, 'X', 'center', 'center', wrong_color);
    %     end
    %     Screen(w,'Flip');
    while GetSecs - task.data_t(trl,1) < init.trl_time; end
    %task.data_t(trl,7) = GetSecs;
    task.data_t(trl,6) = GetSecs;
    disp(['Elapsed Time for Trial: ' num2str(task.data_t(trl,7) - task.data_t(trl,1))]);
end

Screen('TextSize', w, init.txtsize1);

Screen(w, 'FillRect', grey);
DrawFormattedText(w, [
    'Congratz - You finished the exp!' '\n\n' ...
    'You have been ' num2str((scores/Ntrl)*100) '% correct' ...
    ], 'center', 'center', black);
Screen(w, 'Flip');
WaitSecs(10);
task.exp_end = GetSecs;

if init.save == 1
    save([data_file_path '/expData'], 'task', 'init', '-v6');
end