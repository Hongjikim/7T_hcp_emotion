%% set directories of stimuli

function target_dir = set_stim_dir(stim_dir, emotion_num, stim_num)

% stim_dir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates';
% emo_cat =  {'amusement', 'v-joy', 'romance', 'sexual desire', 'surprise', ...
%     'craving', 'anxiety', 'horror', 'v-sadness', 'anger', 'pain', ...
%     'disgust', 'neutral', 'm-joy', 'beautiful', 'fear', 'm-sadness'};

if emotion_num < 14 % movie
    dir.movie = filenames(fullfile(stim_dir, 'exp_stimuli', 'video_stimuli', ['*', num2str(emotion_num, '%.2d'), '*']));
    files = filenames(fullfile(dir.movie{1}, '*mp4'));
    target_dir = files{stim_num};
else % music
    dir.music = filenames(fullfile(stim_dir, 'exp_stimuli', 'music_stimuli', ['*', num2str(emotion_num, '%.2d'), '*']));
    files = filenames(fullfile(dir.music{1}, '*mp3'));
    target_dir = files{stim_num};
end


end