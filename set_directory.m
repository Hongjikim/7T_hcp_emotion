function [basedir, dat_dir, stim_dir, ts_dir] = set_directory(where)
%
% It sets up the essential directories according to where you are.
% and in case of server, it add paths
%
%  ::: example :::
%   [basedir, dat_dir, stim_dir, ts_dir] = set_directory('hj_mac');
%
%  ::: options :::
%             'hj_mac'
%             'hb_mac'
%             'hb_window'
%             '7T_mri'
%
%%
switch where
    case 'hj_mac'
        basedir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/sync_7T_emotion/git_7T_hcp_emotion';
        stim_dir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/sync_7T_emotion';
        
    case 'hb_mac'
        basedir = '/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/git_7T_hcp_emotion';
        stim_dir = '/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates';
        
    case 'hb_window'
        basedir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates\git_7T_hcp_emotion';
        stim_dir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates';
        
    case 'byeolmac'
        basedir = '/Users/byeolkim/Dropbox/stimuli_candidates/git_7T_hcp_emotion';
        stim_dir = '/Users/byeolkim/Dropbox/stimuli_candidates';
        
    case '7T_mri'
        basedir = '/Users/7t_mri/Desktop/CocoanLab_emotion_task/7T_hcp_emotion';
        stim_dir = '/Users/7t_mri/Desktop/CocoanLab_emotion_task';
        
end

dat_dir = fullfile(basedir, 'data');
ts_dir = fullfile(basedir, 'trial_sequence');
addpath(genpath(basedir));

end