%% filler: Maths task

% exspName = 'calc';
% file_path = pwd;
    
[basedir, dat_dir, stim_dir, ts_dir] = set_directory('byeolmac'); % 'hj_mac'
[~,~,data] = xlsread(fullfile(basedir, 'ref_math_task', '/maths_stim1.xlsx'));

% Stimuli coding %

init.present_rate = 1; init.present_time = 5; init.feedback_time = 1;
numbers = data(2:end,6)';
correct = data(2:end,7)';
conds = cell(1,numel(numbers));
    
Ntrl = numel(numbers);
randomizer = randperm(Ntrl,Ntrl);

% Parameter settings %
init.txtsize1 = 40;
init.txtsize2 = 200;
init.txtsize3 = txtsize160;
init.iti = 2; % = 1TR
init.task_time = 4;
init.trl_time = init.iti + init.present_time + init.task_time + init.feedback_time;
init.randomizer = randomizer;
stim = numbers(randomizer); init.presentOrder.stimuli = stim;
anss = correct(randomizer); init.presentOrder.correct = anss;
cons = conds(randomizer); init.presentOrder.conditions = cons;

task.data_t = NaN(Ntrl,8); 
task.rt = NaN(Ntrl,3); 
task.answer = NaN(Ntrl,1);

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
correct_color = white; wrong_color = white;
init.correct_color = correct_color; init.wrong_color = wrong_color;

[w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1024 768]);
Screen('FillRect', w, white);
Screen('TextSize', w, init.txtsize1);

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

% keyboard setup %
KbName('UnifyKeyNames');
L = KbName('1!');
R = KbName('2@');
L = KbName('z');
R = KbName('x');
fliprate = Screen(w, 'GetFlipInterval');
keys = [L R]; init.keys = keys;
task.exp_start = GetSecs;

Screen('FillRect', w, grey);
DrawFormattedText(w, '+', 'center', 'center', black);
Screen(w,'Flip');

WaitSecs(1); scores = 0;
%task_start = GetSecs;

for trl = 1:2%length(stim)
    task.data_t(trl,1) = GetSecs;
    Screen('TextSize', w, init.txtsize1);
    DrawFormattedText(w, '+', 'center', 'center', black);
    Screen(w,'Flip');
    
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
        while GetSecs - stim_time < init.present_rate; end
    end
    task.data_t(trl,3) = GetSecs;
    disp(['Elapsed Time for Stimuli Presentation: ' num2str(task.data_t(trl,3) - task.data_t(trl,1)) 's']);
    
    % ---- Wait for an answer
    ii = 1;
    while ii <= length(stim_loc)
        if ii == length(stim_loc)
            DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), black);
        else
            DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), correct_color);
        end
        ii = ii + 1;
    end
    DrawFormattedText(w, ['Is ' cnum{end} ' correct?'], stim_mpoint(3), stim_mpoint(4), black);
    Screen('TextSize', w, init.txtsize3);
    DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), correct_color);
    DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), correct_color);
    Screen(w,'Flip');
    rt_start = GetSecs; selection = []; task.data_t(trl,4) = rt_start;
    while GetSecs - rt_start < init.task_time
        [keyisdown,~,keycode,~] = KbCheck;
        if keyisdown 
            if keycode(keys(1))
                task.data_t(trl,5) = GetSecs;
                selection = keys(1);
                if strcmp(cans,'True') == 1
                    response = 1;
                else
                    response = 0;
                end
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
    end
    scores = scores + response;
    while GetSecs - task.data_t(trl,1) < init.trl_time; end
    task.data_t(trl,6) = GetSecs;
    disp(['Elapsed Time for Trial: ' num2str(task.data_t(trl,7) - task.data_t(trl,1))]);
end

task.exp_end = GetSecs;

save(fullfile(pwd, 'data.mat'), 'task');
