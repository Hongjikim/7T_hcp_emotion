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
        basedir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates/git_7T_hcp_emotion';
        stim_dir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates';
        
    case 'hb_mac'
        basedir = '/Users/hyebinkim/Dropbox/Cocoan lab/7T HCP/stimuli_candidates/git_7T_hcp_emotion';
        % stim_dir
        
    case 'hb_window'
        basedir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates\git_7T_hcp_emotion';
        stim_dir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates';
        
    case '7T_mri'
%         basedir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates\git_7T_hcp_emotion';
%         stim_dir = 'C:\Users\nutri\Dropbox\Cocoan lab\7T HCP\stimuli_candidates';
end

dat_dir = fullfile(basedir, 'data');
ts_dir = fullfile(basedir, 'trial_sequence');
addpath(genpath(basedir));

end