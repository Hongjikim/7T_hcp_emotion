#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 26 10:07:52 2020

@author: hun
"""
import numpy as np
import sys
sys.path.append('/home/hun/Downloads/experiments/series/')
from stim_func import flatten_listINlist, series_finder, calc_number3
# Series Completion
period = [1,2] # stimuli periodicity
answer = [0,1] # True or False
TF = [(answer[0],'False'),(answer[1],'True')]
operator = ['+','-']
step = 9

Ntrials = 12
condvec = [np.ones(int(np.floor(Ntrials/len(period))))*period[j] for j in range(len(period))]
condvec = flatten_listINlist(condvec,[])
ansvec = np.ones(Ntrials) - answer*(int(Ntrials/len(answer)))

easy_list = []
hard_list = []
easy_ans = []
hard_ans = []
easy_calc = []
hard_calc = []
for trl in range(len(condvec)):
    cp = int(condvec[trl])
    (series,ops) = series_finder(5,cp,step,operator,ansvec[trl])
    if cp == 1:
        easy_list.append(series)
        easy_ans.append(TF[int(ansvec[trl])][1])
    if cp == 2:
        hard_list.append(series)
        hard_ans.append(TF[int(ansvec[trl])][1])
    ### For calculation ###
    ((n1,flag1),(n2,flag2)) = calc_number3(series[0:-1],ansvec[trl])
    easy_calc.append((n1,flag1))
    hard_calc.append((n2,flag2))
    
    
from stim_func import make_series
stim_dict = {}
stim_dict['easy_series'] = easy_list
stim_dict['easy_ans'] = easy_ans
stim_dict['hard_series'] = hard_list
stim_dict['hard_ans'] = hard_ans
(ansc_idx1,not_used) = make_series(int(Ntrials/2),['+1','+3'],0)
(ansc_idx2,not_used) = make_series(int(Ntrials/2),['+1','+3'],2)
stim_dict['easy_calc'] = [easy_calc[ansc_idx1[i]][0] for i in range(len(ansc_idx1))]
stim_dict['easy_ansc'] = [easy_calc[ansc_idx1[i]][1] for i in range(len(ansc_idx1))]
stim_dict['hard_calc'] = [hard_calc[ansc_idx2[i]][0] for i in range(len(ansc_idx2))]
stim_dict['hard_ansc'] = [hard_calc[ansc_idx2[i]][1] for i in range(len(ansc_idx2))]
#iidx = list_shuffler([x for x in range(1,Ntrials,2)])

import pandas as pd
odir = '/home/hun/Downloads/experiments/'
fname = 'Maths_stimuli_prac.csv'
stimuli = pd.DataFrame(stim_dict)
stimuli.to_csv(odir+fname)
# Arithmetic calculation

