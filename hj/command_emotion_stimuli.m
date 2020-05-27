%% copy/paste target stimuli file

stim = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/emotion_stimuli/movie';
music = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates/exp_stimuli/video_stimuli';
movie = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates/movie/candidates_video';
source = fullfile(stim, 'mp4_noname/');

fnames.pain_again = {'2080.mp4', '1181.mp4', '1768.mp4', '1596.mp4', ...
    '1185.mp4', '0089.mp4', '1792.mp4', '2109.mp4'};

fnames.anxiety = {'0604.mp4', '1313.mp4', '0615.mp4', '1629.mp4', '0385.mp4', ...
    '1701.mp4', '0377.mp4', '0046.mp4', '0489.mp4', '0395.mp4'};

fnames.anxiety30 = {'1657.mp4', '0419.mp4', '0190.mp4', '2121.mp4', '0372.mp4', ...
'0097.mp4', '0045.mp4', '1219.mp4', '0853.mp4', '0598.mp4', '0370.mp4', '1284.mp4', ...
'1955.mp4', '1283.mp4', '2091.mp4', '1654.mp4', '0374.mp4', '1679.mp4', '0025.mp4', '0460.mp4'};

fnames.fear = {'1375.mp4', '1422.mp4', '0395.mp4', '0025.mp4', '1964.mp4', '0137.mp4', ...
    '1779.mp4', '0687.mp4', '0190.mp4', '1172.mp4'};

fnames.fear30 = {'0504.mp4','1931.mp4','0889.mp4', '0564.mp4', '1440.mp4', ...
    '1219.mp4', '1283.mp4', '2091.mp4', '0374.mp4', '0379.mp4', '0517.mp4', '1212.mp4', ...
    '1599.mp4', '1615.mp4','2121.mp4', '1361.mp4', '1042.mp4', '1373.mp4', ...
    '0377.mp4','0706.mp4'};

fnames.horror = {'0606.mp4', '1705.mp4', '0234.mp4', '1922.mp4', '1830.mp4', '0699.mp4', '1650.mp4', ...
    '1868.mp4', '1226.mp4', '1214.mp4'};

fnames.horror30 = {'1126.mp4', '1111.mp4', '1339.mp4', '0866.mp4', '1434.mp4', '1165.mp4', ...
'0565.mp4', '1601.mp4', '1014.mp4', '1605.mp4', '0062.mp4', '0406.mp4', '0481.mp4', ...
'1184.mp4', '1292.mp4', '1026.mp4', '0674.mp4', '0887.mp4', '0790.mp4', '0782.mp4'};

fnames.amusement = {'0910.mp4', '1801.mp4', '0074.mp4', '0080.mp4', '0578.mp4', ...
    '0574.mp4', '1697.mp4', '1043.mp4', '0258.mp4','0741.mp4'};

fnames.amusement30 = {'1411.mp4', '0656.mp4', '1145.mp4', '2179.mp4', ...
'1874.mp4', '0361.mp4', '2072.mp4', '2083.mp4', '1891.mp4', '1564.mp4', '0820.mp4', '0296.mp4', ...
'0715.mp4', '1606.mp4', '1647.mp4', '0066.mp4', '1328.mp4', '1696.mp4', '2061.mp4', '1710.mp4'};

fnames.adoration = {'1282.mp4', '0344.mp4', '1935.mp4', '0366.mp4', '0035.mp4', ...
    '1157.mp4', '1311.mp4', '1683.mp4', '1692.mp4','1285.mp4'};

fnames.adoration30 = {'1924.mp4', '0483.mp4', '1667.mp4', '1666.mp4', '1660.mp4', ...
'0413.mp4', '0573.mp4', '0584.mp4', '2102.mp4', '1465.mp4', '1127.mp4', '1300.mp4', '0918.mp4', ...
'0392.mp4', '0098.mp4', '1418.mp4', '1748.mp4', '1961.mp4', '0403.mp4', '0521.mp4'};

fnames.joy = {'1032.mp4', '0688.mp4', '1034.mp4', '2034.mp4', '1938.mp4', '0380.mp4', ...
    '1953.mp4', '0593.mp4',  '1712.mp4', '1363.mp4'};

fnames.joy30 = {'1267.mp4', '0165.mp4', '0035.mp4', '0043.mp4', '2013.mp4', '0605.mp4', ...
    '1093.mp4', '1965.mp4', '0361.mp4', '0597.mp4', '0087.mp4', '1683.mp4', '1328.mp4', '1249.mp4', ...
    '0666.mp4', '1245.mp4', '1349.mp4', '0915.mp4', '1745.mp4', '0650.mp4'};

fnames.romance = {'1424.mp4', '0204.mp4','0116.mp4','1911.mp4', '0369.mp4', ...
    '2129.mp4', '1468.mp4', '1056.mp4', '0036.mp4', '0044.mp4'};

fnames.romance30 = {'1444.mp4', '1938.mp4', '0795.mp4', '0560.mp4', '1435.mp4', '1978.mp4', '1551.mp4', ...
    '1622.mp4', '1975.mp4', '0711.mp4', '0964.mp4', '1909.mp4', '1807.mp4', '0456.mp4',  ...
    '0400.mp4', '1460.mp4','1341.mp4', '1054.mp4', '0507.mp4', '0902.mp4'};

fnames.sexual_desire = {'0922.mp4', '0878.mp4', '1917.mp4', '1248.mp4', '1307.mp4', ...
    '1008.mp4', '1610.mp4', '0556.mp4', '1385.mp4', '1247.mp4', '1377.mp4', '1894.mp4', ...
    '2063.mp4', '2074.mp4'};

fnames.sexual_desire30 = {'0954.mp4', '0162.mp4','0337.mp4', ...
    '0309.mp4', '0641.mp4', '0997.mp4', '1539.mp4', '0010.mp4', '2089.mp4', '0376.mp4', ...
    '1645.mp4', '2167.mp4', '1684.mp4', '2015.mp4', '2053.mp4', '0501.mp4'};

fnames.craving30 = {'0458.mp4', '0830.mp4', '0883.mp4', '0896.mp4', '1740.mp4', ...
    '0898.mp4', '1968.mp4', '0780.mp4', '1449.mp4', '1270.mp4', '1498.mp4', ...
    '0110.mp4', '0880.mp4', '1936.mp4', '0818.mp4', '1814.mp4', '0893.mp4', ...
    '0919.mp4', '1852.mp4', '0531.mp4', '1826.mp4', '1205.mp4', '2149.mp4', ...
    '1053.mp4', '1078.mp4', '1138.mp4', '2107.mp4', '0365.mp4', '1993.mp4'};

fnames.surprise30 =  {'0509.mp4', '0976.mp4', '1277.mp4', '1433.mp4', '1436.mp4', '0468.mp4', ...
    '0602.mp4', '1002.mp4', '1276.mp4', '1899.mp4', '1234.mp4', '1690.mp4', ...
    '0906.mp4', '1430.mp4', '0295.mp4', '0451.mp4', '0452.mp4', '0491.mp4', ...
    '0582.mp4', '0598.mp4', '0607.mp4', '0856.mp4', '1264.mp4', '1269.mp4', ...
    '1635.mp4', '1636.mp4', '1819.mp4', '2006.mp4', '2156.mp4', '0157.mp4'};

fnames.sadness30 = {'1959.mp4', '0756.mp4', '1259.mp4', '0975.mp4', '1786.mp4', ...
    '0051.mp4', '0059.mp4', '0067.mp4', '0226.mp4', '1164.mp4', '1587.mp4', '1478.mp4', ...
    '0611.mp4', '0673.mp4', '0181.mp4', '1485.mp4', '0860.mp4', '0803.mp4', '1169.mp4', ...
    '1703.mp4', '0009.mp4', '1004.mp4','1101.mp4', ...
    '1933.mp4', '0736.mp4', '0208.mp4', '0777.mp4', '1238.mp4', '1691.mp4'};

fnames.anger30 = {'1310.mp4', '0218.mp4', '1703.mp4', '1339.mp4', '0681.mp4', ...
    '1478.mp4', '0733.mp4', '0414.mp4', '0971.mp4', '1922.mp4', '0450.mp4', ...
    '1844.mp4', '0595.mp4', '1259.mp4', '1691.mp4', '1260.mp4', '1026.mp4', '2123.mp4', ...
    '2066.mp4' , '0197.mp4', '1174.mp4', '0406.mp4', '0606.mp4',  '0836.mp4', '1901.mp4', ...
    '1885.mp4', '2012.mp4', '0914.mp4', '0054.mp4', '0948.mp4'};

fnames.pain30 = {'1752.mp4', '1768.mp4', '0313.mp4', '1991.mp4', '1613.mp4', ...
    '1403.mp4', '0736.mp4', '0154.mp4', '0522.mp4', '0278.mp4', '2109.mp4', ...
    '1632.mp4', '2080.mp4', '0211.mp4', '0216.mp4', '1181.mp4', '1185.mp4', '1304.mp4', ...
    '1788.mp4', '0646.mp4', '1706.mp4', '1792.mp4', '0218.mp4', '0383.mp4', '0259.mp4', ...
    '0746.mp4', '1464.mp4', '0790.mp4', '2148.mp4', '1990.mp4'};

fnames.disgust30 = {'2010.mp4', '1441.mp4', '1685.mp4', '0187.mp4', '0876.mp4', ...
    '0929.mp4', '1044.mp4', '0713.mp4', '1425.mp4', '1940.mp4', '1194.mp4', ...
    '0235.mp4', '1907.mp4', '2018.mp4', '2147.mp4', '1471.mp4', '0355.mp4',  ...
    '0551.mp4', '1423.mp4', '1275.mp4', '0271.mp4', '1598.mp4', '1813.mp4',  ...
    '0865.mp4', '0048.mp4', '1519.mp4', '2004.mp4', '2152.mp4', ...
    '2012.mp4','2020.mp4'};

%%
command = [];

dest = fullfile(music, '/v12_disgust');
target = fnames.disgust30;

for i = 1:numel(target)
    command = [command 'cp ' source target{i} ' ' dest ' &'];
end

command
clipboard('copy', command)


%% music


fnames.amusing = {'KcSzSpWdpwE_1.mp3', 'l4t2mWbXgCI_1.mp3', 'mnipB_8Br8U_16.mp3', 'LI_mwl3QcYA_0.mp3', ...
    'Y_IS_ccjkZE_260.mp3', 'woPff-Tpkns_0.mp3','Bk2oy5NQY5I_35.mp3', 'Dw20ZkMwI10_0.mp3', ...
    '8QLGlbJA7C0_15.mp3'}; % , 'Betty Davis - Anti Love Song (1973)_fxKBnR_8LIM_1.mp3'

fnames.anxious = {'D7BoKuu0MNk_1.mp3', '1qKS51qh4OY_403.mp3', 'R3WwcsjWPIQ_23.mp3', ...
    'nHRqTSgKJGg_2193.mp3' , 'S7OCzDNeENg_3961.mp3', 'OZK7rAyzGi4_135.mp3', '105.m4a.mp3', ...
    '6vtsKGzGVK4_4.mp3', '9f0l4djubOM_0.mp3'}; % 'Four Seasons ~ Vivaldi-GRxofEmo3HA&1.mp3'

fnames.beautiful = {'4w8PCYlzlmg_163.mp3', '2470.m4a.mp3', 'lv1uZj7MzBE_23.mp3', ...
    'mz66bnRWQJM_139.mp3', 'rCljeHfhhrc_2.mp3', 'HSOtku1j600_23.mp3', '696.m4a.mp3', ...
    'BiyCkSOF1pc_0.mp3', 'S1GQTuvLids_70.mp3', 'Shire_fa_Reborn_short.mp3'};

fnames.erotic = {'467.m4a.mp3', 'S8QOaaoiT9U_12.mp3', 'aJ2xXmqZUK4_16.mp3', 'gNDYBPCJPqU_17.mp3', ...
    'QBvOKbXEXJk_101.mp3', 'U0zcGaHE4-A_3601.mp3', 'idio2GUWRWg_44.mp3'}; % 'Snails and Barry White_VMEJMjGgeus_1.mp3', 'The Weeknd - The Morning_5TAko3RH0bk_3.mp3'

fnames.fear = {'cWjOaZFXo3s_25.mp3', 'DM-Aleatoric_Singing_short.mp3', 'QSYwG-1GAXQ_0.mp3', ...
    'uVNzb9GPwnY_13.mp3', '6TUeUL7EW9M_1.mp3', 'Eegs84CdzTc_450.mp3', 'uV0D5h17Yzk_110.mp3', ...
    'yEktSBG6SO8_0.mp3', 'W_X5Ibu2Xno_2.mp3', '4S-5ihzUkM4_121.mp3'};

fnames.joyful = {'MK6TXMsvgQg_3.mp3', '6wlbB1PTzJU_0.mp3', 'H7bvnjQMgq4_14.mp3', ...
    'QPzjHgMENrc_22.mp3','hEWGq6RoKs8_5.mp3', 'NEkXCYrQUAg_80.mp3', ...
    'bs66ORnV5jU_1.mp3', 'l4t2mWbXgCI_1.mp3', 'tIYURcd4WB4_39.mp3', 'vFe5N7bvXXI_10.mp3'};

fnames.sadness_music = {'pUZeSYsU0Uk_85.mp3', 'pcaqVYEG7Dw_0.mp3', 'xTs83Ej5nS8_180.mp3', ...
    '7LEmer7wwHI_2285.mp3', 'aWIE0PX1uXk_190.mp3', 'aWIE0PX1uXk_46.mp3', '502.m4a.mp3', ...
    'xTs83Ej5nS8_226.mp3','DQPpREz4now_30.mp3','4DrtIYxEnps_20.mp3'};


%% get fnames

stim_dir = '/Users/hongji/Dropbox/Cocoan_lab/Collab/7T_HCP_emotion/stimuli_candidates';

% movie
dir.movie = fullfile(stim_dir, 'movie', 'candidates_video');
type.movie = {'adoration', 'amusement', 'anxiety', 'fear', ...
    'horror', 'joy', 'romance', 'sexual_desire'};
type_i.movie = 3; 
target_dir.movie = filenames(fullfile(dir.movie, ['*', type.movie{type_i.movie}, '*sorted']), 'char');

% music
dir.music = fullfile(stim_dir, 'music', 'candidates_music');
type.music = {'amusing', 'anxious', 'beautiful', 'erotic', 'fear', 'joyful'};
type_i.music = 3; 
target_dir.music = filenames(fullfile(dir.music, ['*', type.music{type_i.music}]), 'char');

