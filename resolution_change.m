%% directory
category_dir = filenames(fullfile('/Users/hyebinkim/Dropbox/Cocoanlab/7T_HCP/stimuli_candidates/exp_stimuli/video_stimuli','*'));

c = dir(pwd);
c = {c.name}';
c = c(3:end);

%% create new resolution

area = 480000;
for i = 1:numel(category_dir)
    video_dir = filenames(fullfile(category_dir{i}, '*'));
    video_resolution{i} = zeros(numel(video_dir), 2);
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

%% create ffmpeg code
%
%     {'/Users/hyebinkim/Documents/video_stimuli/v01_amusement'    } new_resolution{1,1}
%     {'/Users/hyebinkim/Documents/video_stimuli/v02_joy'          } new_resolution{1,2}
%     {'/Users/hyebinkim/Documents/video_stimuli/v03_romance'      } 3
%     {'/Users/hyebinkim/Documents/video_stimuli/v04_sexual_desire'} 4
%     {'/Users/hyebinkim/Documents/video_stimuli/v05_surprise'     } 5
%     {'/Users/hyebinkim/Documents/video_stimuli/v06_craving'      } 
%     {'/Users/hyebinkim/Documents/video_stimuli/v07_anxiety'      }
%     {'/Users/hyebinkim/Documents/video_stimuli/v08_horror'       }
%     {'/Users/hyebinkim/Documents/video_stimuli/v09_sadness'      }
%     {'/Users/hyebinkim/Documents/video_stimuli/v10_anger'        }
%     {'/Users/hyebinkim/Documents/video_stimuli/v11_pain'         }
%     {'/Users/hyebinkim/Documents/video_stimuli/v12_disgust'      }
%     {'/Users/hyebinkim/Documents/video_stimuli/v13_neutral'      }

% 사이즈 변경할 비디오 이름 가져오기    
cd /Users/hyebinkim/Documents/video_stimuli/v13_neutral
mkdir new % 현재 위치에서 바꾼 비디오 저장할 폴더 만들기
video_name = dir(pwd);
video_name = {video_name.name}';
video_name = video_name(4:end-1);

% 3. 터미널에 붙여넣을 코드 생성
% ffmpeg -i 0074.mp4 -vf scale=800:600 new/0074.mp4

for i = 1:8
    text = strcat("ffmpeg -i ", string(video_name{i})," -vf scale=", string(new_resolution{1,13}(i,1)), ":", string(new_resolution{1,13}(i,2)), " new/", string(video_name{i}), "\n");
    fprintf(text)
end



