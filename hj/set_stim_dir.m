%% set directories of stimuli

function target_dir = set_stim_dir(stim_dir, movie_or_music, i)

% stim_dir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates';

if strcmp(movie_or_music, 'movie') % movie
    dir.movie = fullfile(stim_dir, 'movie', 'candidates_video');
    type.movie = {'adoration', 'amusement', 'anxiety', 'fear', ...
        'horror', 'joy', 'romance', 'sexual_desire'};
    type_i.movie = i;
    target_dir.movie = filenames(fullfile(dir.movie, ['*', type.movie{type_i.movie}, '*sorted']), 'char');
    
elseif strcmp(movie_or_music, 'music') % music
    dir.music = fullfile(stim_dir, 'music', 'candidates_music');
    type.music = {'amusing', 'anxious', 'beautiful', 'erotic', 'fear', 'joyful'};
    type_i.music = i;
    target_dir.music = filenames(fullfile(dir.music, ['*', type.music{type_i.music}]), 'char');
end
end