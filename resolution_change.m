category_dir = filenames(fullfile('/Users/7t_mri/Documents/Shimlab_localizer/Emotion/exp_stimuli/video_stimuli/','*'));

c = dir(pwd);
c = {c.name}';
c = c(3:end);

area = 480000;
for i = 1:numel(category_dir)
    video_dir = filenames(fullfile(category_dir{i}, '*'));
    video_resolution{i} = zeros(numel(video_dir, 2));
    for j = 1:numel(video_dir)
        vidObj = VideoReader(video_dir{j});
       video_resolution{i}(j,1) = vidObj.Width; 
       video_resolution{i}(j,2) = vidObj.Height;
    end
    
    ratio = repmat(sqrt(area./[video_resolution{i}(:,1) .* video_resolution{i}(:,2)]),1,2);
    temp = round(video_resolution{i} .* ratio);    
    temp(logical(mod(temp,2))) = temp(logical(mod(temp,2)))  + 1;
    new_resolution{i} = temp;
end



% PATH = getenv('ffmpeg');
% setenv('ffmpeg', [PATH ':/usr/local/Cellar/ffmpeg/4.3.1']);
% system('ffmpeg -i /Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/exp_stimuli/video_stimuli/v01_amusement/0074.mp4 -vf scale=1024:-1 /Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/exp_stimuli/video_stimuli/revised/0074_1024.mp4');
% 
% input = '/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/exp_stimuli/video_stimuli/v01_amusement/0074.mp4'};
% output = {'/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/exp_stimuli/video_stimuli/revised/0074_1024.avi'};
% ffmpegtranscode(input, output, 'VideoScale', '2');
% ffmpegtranscode('0074.mp4', 'new.avi','AudioCodec','aac','VideoCodec','x264');
