function [trial_s] = emo_music_generate_trial_sequence(basedir, subj_id)
% 
% function [ts] = emo_music_generate_trial_sequence
% 
% To make trial sequece for emotion task.
% Each run would have 13 video conditions and 4 music conditions
% 
%
%
% ..
%    Copyright (C) 2020  Cocoan lab
% ..
%
%
%%
datdir.music = fullfile(basedir, 'music'); 
datdir.video = fullfile(baseidr, 'movie');

ts_dir = fullfile(basedir, 'trial_sequence');


%% randomize (1) emotion category order

% conditions to be obtained
% 1) Pos vs. Neg --> no same valence for more than 3 times (maximum twice)
% 2) Music --> no more than 3 times in a row

% video 1-13
% 1. amusement
% 2. v-joy
% 3. romance
% 4. sexual desire
% 5. surprise
% 6. craving
% 
% 7. anxiety
% 8. horror
% 9. v-sadness
% 10. anger
% 11. pain
% 12. disgust
%
% 13. neutral
% 
% Music (14-17)
% 14. m-joy
% 15. beautiful
% 16. fear
% 17. m-sadness

% output: emo_order

rng('shuffle');

music = [14, 15, 16, 17];
positive = [1, 2, 3, 4, 5, 6, 14, 15];
negative = [7, 8, 9, 10, 11, 12, 16, 17];

done = false;

while not(done)
    done = true;  
    emo_order = randperm(17);
    for i = 3:17
        if (any(positive == emo_order(i)) && any(positive == emo_order(i-1)) && any(positive == emo_order(i-2)))...
                || (any(negative == emo_order(i)) && any(negative == emo_order(i-1)) && any(negative == emo_order(i-2)))...
                || (any(music == emo_order(i)) && any(music == emo_order(i-1)) && any(music == emo_order(i-2)))
        done = false;
        end
    end
end
 
%% randomize (2) stimuli order

rng('shuffle');

% video(13): 8 --> 4/4
% music(4): 6 --> 3/3

for i = 1:13
    stim_order.video(i,:) = randperm(8);
    if i < 5
        stim_order.music(i,:) = randperm(6);
    end
end

%% add outputs into ts

trial_s.subj_id = subj_id;
trial_s.emo_order = emo_order;
trial_s.stim_order = stim_order;

%% save ts
nowtime = clock;
savename = fullfile(ts_dir, ['trial_sequence_' subj_id '_' date '_' num2str(nowtime(4)) '_' num2str(nowtime(5)) '.mat']);
save(savename, 'ts');

end