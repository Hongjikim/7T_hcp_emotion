global theWindow

expt_param.screen_mode = 'Testmode';
screen_param = MPC_setscreen(expt_param);


font = screen_param.window_info.font ;
fontsize = screen_param.window_info.fontsize;
theWindow = screen_param.window_info.theWindow;
window_num = screen_param.window_info.window_num ;
window_rect = screen_param.window_info.window_rect;
H = screen_param.window_info.H ;
W = screen_param.window_info.W;

lb1 = screen_param.line_parameters.lb1 ;
lb2 = screen_param.line_parameters.lb2 ;
rb1 = screen_param.line_parameters.rb1;
rb2 = screen_param.line_parameters.rb2;
scale_H = screen_param.line_parameters.scale_H ;
scale_W = screen_param.line_parameters.scale_W;
anchor_lms = screen_param.line_parameters.anchor_lms;

bgcolor = screen_param.color_values.bgcolor;
orange = screen_param.color_values.orange;
red = screen_param.color_values.red;
white = screen_param.color_values.white;

playmode = 1;
%%

dir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates/movie/candidates_video/v_joy';

moviefile = fullfile(dir, '/1032.mp4');

%%
msgtxt = '���ݺ��� ������ ���۵˴ϴ�.\n\n����, ������ �����ϱ⿡ �ռ� �� ô���� ���� ������ �����ϰڽ��ϴ�.\n\n�����ڴ� ��� �غ� �Ϸ�Ǹ� ���콺�� �����ֽñ� �ٶ��ϴ�.\n\n Click mouse';
DrawFormattedText(theWindow, double(msgtxt), 'center', 'center', white, [], [], [], 2);
Screen('Flip', theWindow);



%%
[moviePtr, dura] = Screen('OpenMovie', theWindow, moviefile);

%% Playing movie
Screen('SetMovieTimeIndex', moviePtr, 0);
Screen('PlayMovie', moviePtr, playmode); %Screen('PlayMovie?')% 0 == Stop playback, 1 == Normal speed forward, -1 == Normal speed backward,

t = GetSecs;

while GetSecs-t < expt_param.movie_duration %(~done) %~KbCheck
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', theWindow, moviePtr);
    Screen('DrawTexture', theWindow, tex);
    Screen('Flip', theWindow);
    Screen('Close', tex);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        %done = 1;
        break;
    end
    % Update display:
    
end

Screen('PlayMovie', moviePtr,0);

%% Close movie
Screen('CloseMovie',moviePtr);
Screen('Flip', theWindow);