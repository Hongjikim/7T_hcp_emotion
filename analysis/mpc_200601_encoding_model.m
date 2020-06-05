%function mpc_cocoan_ica_first_level()
clear;
clc;

sub_idx = [23:26]; 

%% SET-UP: DIRECTORY
%addpath(genpath('/sas1/cocoanlab/Resources'));

%basedir = '/cocoanlab2/GPU1_sync/data/MPC/MPC_wani/';
basedir = '/media/cnir09/GPU1_sync/data/MPC/MPC_wani/';
%basedir = '/media/das/dropbox/data/MPC/MPC_wani/';

img_dir = fullfile(basedir, '/imaging/preprocessed');
%img_dir = fullfile(basedir, '/imaging/preprocessed/cocoan_prep');
%modeldir = '/cocoanlab2/GPU1_sync/projects/MPC/analysis/imaging/first_level/cocoan_prep_ica_nonaggr'; 
modeldir = '/media/das/dropbox/projects/MPC/MPC_wani/analysis/imaging/first_level/qc_encoding_model_heat'; 

dataset_dir = fullfile(basedir, 'behavioral/preprocessed');
dataset_file = 'MPC_wani_dataset_behavioral*.mat';
load(filenames(fullfile(dataset_dir, dataset_file), 'char'));

if ~exist(modeldir, 'dir'), mkdir(modeldir); end

%% Set the parameters
TR = 0.46;
hpfilterlen = 180;


% Onsets and Durations from D
% [~, movie_onset] = get_var(D, 'EventOnsetTime', 'conditional', {'EventName' 'Movie'});
[~, run_num] = get_var(D, 'RunNumber');
[~, trial_num] = get_var(D, 'TrialNumber');
[~, event_name] = get_var(D, 'EventName');
[~, onset_list] = get_var(D, 'EventOnsetTime');
[~, dur_list] = get_var(D, 'EventDuration');
[~, heat_level] = get_var(D, 'HeatPainLevel');

incompltes = D.Description.incomplete_subjects;


for sub_id = 1:numel(sub_idx)  
    
    sub_num = sub_idx(sub_id);
    subj_outputdir = fullfile(modeldir,sprintf('/sub-mpc%03d',sub_num));
    subj_dir = fullfile(img_dir, sprintf('sub-mpc%03d', sub_num));
    
    load(fullfile(subj_dir, 'PREPROC.mat'));
    nuisance_dir = fullfile(subj_dir, 'nuisance_mat'); 
    
    
    images_by_run = {};
    multi_nuisance_matfilenames = {};
    k = 1;
    for i =2:9
        is_incomplete = strcmp(incompltes(:,1), sprintf('sub-%02d', sub_num)) & strcmp(incompltes(:,2), sprintf('run-%02d', i));
        if sum(is_incomplete) > 0
            continue
        end
        
        img = filenames(fullfile(subj_dir, sprintf('func/asw*task*movie_run-%02d*.nii', i)), 'char');
        nui = fullfile(nuisance_dir, sprintf('nuisance_run%d.mat', i));
        
        if isempty(img)
           continue 
        end
        images_by_run{k,1} =img;
        multi_nuisance_matfilenames{k} = nui;
        k = k+1;
    end
    
%%
    sub_run_num = run_num{sub_num};
    sub_trial_num = trial_num{sub_num};
    sub_event_name = event_name{sub_num};
    sub_onset_list = onset_list{sub_num};
    sub_dur_list = dur_list{sub_num};
    sub_heat_level = heat_level{sub_num};

    onsets = {};
    duration = {};
    names = {};
    rating_onsets = [];
    rating_dur = [];
    conditions_per_run = [];
    prev_condition = 0;
    
    k = 1;
    for run_n = 2:9
        
        if run_n == 1 || run_n == 10
            continue
        end
        
        is_incomplete = strcmp(incompltes(:,1), sprintf('sub-%02d', sub_num)) & strcmp(incompltes(:,2), sprintf('run-%02d', run_n));
        if sum(is_incomplete) > 0
            continue
        end
        
        conditions= 0;
        idx = strcmp(sub_event_name, 'Heat') & sub_run_num == run_n & ~isnan(sub_onset_list);
        if ~isempty(sub_onset_list(idx))
            onsets{k} = sub_onset_list(idx)';
            duration{k} = sub_dur_list(idx)';
            names{k} = sprintf('sub-%02d_run-%02d_event-heat', sub_num, run_n);
            k = k+1;
            conditions = conditions+1;
        end
        
        idx = strcmp(sub_event_name, 'Rating') & sub_run_num == run_n & ~isnan(sub_onset_list);
        if ~isempty(sub_onset_list(idx))
            onsets{k} = sub_onset_list(idx)';
            duration{k} = sub_dur_list(idx)';
            names{k} = sprintf('sub-%02d_run-%02d_event-rating', sub_num, run_n);
            k = k+1;
            conditions = conditions+1;
        end
        
        idx = strcmp(sub_event_name, 'Prestate') & sub_run_num == run_n & ~isnan(sub_onset_list);
        if ~isempty(sub_onset_list(idx))
            onsets{k} = sub_onset_list(idx)';
            duration{k} = sub_dur_list(idx)';
            names{k} = sprintf('sub-%02d_run-%02d_event-Prestate', sub_num, run_n);
            k = k+1;
            conditions = conditions+1;
        end

        idx = strcmp(sub_event_name, 'Movie') & sub_run_num == run_n & ~isnan(sub_onset_list);
        if ~isempty(sub_onset_list(idx))
            onsets{k} = sub_onset_list(idx)';
            duration{k} = sub_dur_list(idx)';
            names{k} = sprintf('sub-%02d_run-%02d_event-Movie', sub_num, run_n);
            k = k+1;
            conditions = conditions+1;
        end

        conditions_per_run = [conditions_per_run conditions];
    end
    

    %% first-level model job
    matlabbatch = canlab_spm_fmri_model_job(subj_outputdir, TR, hpfilterlen, images_by_run, conditions_per_run, onsets, duration, names, multi_nuisance_matfilenames, 'is4d', 'notimemod');
  
    if ~exist(subj_outputdir, 'dir'), mkdir(subj_outputdir); end
    save(fullfile(subj_outputdir, 'spm_model_spec_estimate_job.mat'), 'matlabbatch');
    spm_jobman('run', matlabbatch);
    %%
%     
%     cd(subj_outputdir);
%     out = scn_spm_design_check(subj_outputdir, 'events_only');
%     
%     savename = fullfile(subj_outputdir, 'vifs.mat');
%     save(savename, 'out');
    
    %% delete unneccessary files and make a symbolic links for later use
     load(fullfile(subj_outputdir, 'SPM.mat'));
     bimgs=dir(fullfile(subj_outputdir, 'beta_*nii'));
     betaimgs = filenames(fullfile(subj_outputdir, 'beta_*nii'));
    
     delete_file_idx = [find(contains(SPM.xX.name, 'R'))';find(contains(SPM.xX.name, 'constant'))'];
     for z = 1:numel(delete_file_idx)
         delete(fullfile(subj_outputdir,bimgs(delete_file_idx(z)).name));
         delete(betaimgs{delete_file_idx(z)});
     end
end


%% make link 

%%
%% Check Variance Infalation Factors
% clear V I
% iiiiii = [1:16, 18:59];
% %vifss(59)=NaN;
% clc
% ther=[2.5,5]; %threshold
% for i=1:2
% disp(['========== Threshold level: ' num2str(ther(i)) ' ==================']);
% for sub_i = iiiiii
% 
%  subject_id = D.Subj_Level.id{sub_i};
%  subj_dir = fullfile(img_dir, subject_id);
%  subj_outputdir = fullfile(modeldir, subject_id);
%  cd(subj_dir);
% 
%  vifdir = fullfile(subj_outputdir,'vifs.mat');
%  load(vifdir, 'out');
%  vifss(sub_i,:)=out.allvifs;
%  [I{sub_i}, ro{sub_i}, V{sub_i} ] = find(vifss(sub_i,:)' >=ther(i));
%  if ~isempty(I{sub_i})
%  %disp([':::::::::::::::::::::::::::::::::::::::::::::::::']);
%  disp([':::::::::::::::SUBJECT NUMBER: ' num2str(sub_i) ' :::::::::::::::']);
%  %disp([':::::::::::::::::::::::::::::::::::::::::::::::::']);
%  disp(['VIF value Trial Number  Name'])
%  disp([vifss(sub_i,I{sub_i})' I{sub_i} string(vif_names(I{sub_i}')')])
%  %tbl = table(repmat(sub_i,length(I{sub_i}),1), vifss(sub_i,I{sub_i})', I{sub_i}, char(vif_names(I{sub_i}')'));
%  %disp([char(vif_names{I{sub_i}'})]);
%  %disp([num2str(vifss(sub_i,I{sub_i})')]);
%  % disp(num2str(V{sub_i}));
%  VIF_SEMIC_SINGLE_PAIN_TRIAL.vifs{sub_i} = [vifss(sub_i,I{sub_i})' I{sub_i}];
%  end
%  vif_names = out.name;
% 
% end
% end
% %% Histogram
% bins = 20;
% subplot (1,2,1);
% histogram(vifss,bins);
% set(gca, 'ylim', [0 20]);
% %set(gca, 'xlim', [0.8 10]);
% title('Histogram of vifs (ylim = 0-20) ');
% subplot (1,2,2);
% histogram(vifss,bins);
% % set(gca, 'ylim', [0 20]);
% %set(gca, 'xlim', [0.8 10]);
% title('Histogram of vifs (no ylim)');
% %% Plot
% subplot(3,1,1);
% plot(vifss); title('plot of vifs (no ylim)');
% subplot(3,1,2);
% plot(vifss); title('plot of vifs (ylim=[1,7])');
% set(gca, 'ylim', [1 7]);
% subplot(3,1,3);
% errorbar(1:59,mean(vifss'),std(vifss')); title('errorbar of each participant''s vifs');
% set(gca, 'ylim', [1 7]);


%end