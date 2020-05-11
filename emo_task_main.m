%% main script for emotion task in fMRI

% setting: directory and subject information

basedir = '/Users/Hyebin/Dropbox/stimuli_candidates';
subj_id = input('Subject ID? (e.g., sub001): ', 's');


% make trial sequence for each subjects
trial_sequece = emo_music_generate_trial_sequence(basedir, subj_id);
% save(sprintf('~~~.mat', 'trial_sequece'));

% goal

% no movie or music stimuli actually presented! 

% in the screen, display emo-category and filenames
% filler task: "filler"

