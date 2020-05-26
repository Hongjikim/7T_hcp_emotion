#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 26 09:31:20 2020

@author: hun
"""

import numpy as np
import random
def flatten_listINlist(hyposet,flatset): #e.g. hyposet = [['a',['b']],'c'] -> ['a','b','c']; flatset =[]
    for hype in hyposet:
        if type(hype) is list:
            flatset = flatten_listINlist(hype,flatset)
        elif type(hype) is np.ndarray:
            flatset = flatten_listINlist(list(hype),flatset)
        else:
            flatset.append(hype)
            
    return flatset

def operator_clip(operator,step):
    co = operator[random.randint(1,len(operator))-1]
    cs = random.randint(1,step)
    return [co,str(cs)]


def make_series(sl,op,start_n,ans=[]):
    ### Find alternating indices ###
    idx = [[x for x in range(len(op))] for i in range(sl)]
    idx = flatten_listINlist(idx,[])
    idx = idx[0:sl]
    #################################
    ops = [op[idx[i]] for i in idx]
    series = [start_n]
    for s in range(len(ops)):
        if s == len(ops)-1: # before the loop ends
            end_n1 = eval(''.join([str(start_n), ops[s]]))
            if len(op) > 1:
                end_n2 = eval(''.join([str(start_n), ops[s-1]]))
            else:
                temp_op = ['+','-']
                random.shuffle(temp_op)
                end_n2 = eval(''.join([str(end_n1),temp_op[0],'1']))
            ## This section will output the true and false answers together in a random order ##
            #end_n = [end_n1,end_n2]
            #random.shuffle(end_n)
            #series.append(end_n)
            if ans == 0:
                series.append(end_n2)
            elif ans == 1:
                series.append(end_n1)
        else:
            start_n = eval(''.join([str(start_n), ops[s]]))
            series.append(start_n)
    
    return (series,ops)

def series_finder(sl,cp,step,operator,ans):
    if sl/2 > cp:
        while True:
            start_n = random.randint(10,90)
            ## setting rule(s)
            while True:
                op = []
                for p in range(cp):
                    op.append(''.join(operator_clip(operator,step)))
                if len(op) > 1:
                    if eval(''.join([op[0],'+',op[0]])) != 0 and eval(''.join([op[0],'-',op[1]])) != 0:
                        break
                else:
                    break
            
            (series,ops) = make_series(sl,op,start_n,ans)
            idx = [i for i in flatten_listINlist(series,[]) if i < 0 or i > 100]
            if not idx and str(series[-2])[-1] != '0':
                if series[-2] < 80 and series[-2] > 20:
                    break
    else:
        return "series length TOO SMALL for the given period"
    return (series,ops)
        
#def series_finder(sl,co,cs):
#    while True:
#        start_n = random.randint(10,90)
#        if co == '+':
#            seriess = [x for x in range(start_n,99,cs)] # don't go above 99
#        elif co == '-':
#            seriess = [x for x in range(start_n,1,cs*-1)]
#        else:
#            return 'unrecognized operator'
#        series = [seriess[s] for s in range(len(seriess)) if s < sl]
#        if len(series)==sl:
#            break
#    return series

def find_operator(sl,op):
    operators = [op[random.randint(1,len(op))-1] for x in range(sl-1)]
    return operators

def calc_numbers(series,operator):
    while True:
        op = find_operator(5,operator)
        calc = [None]*(len(series)+len(op))
        strseries = [str(x) for x in series]
        calc[::2] = strseries
        calc[1::2] = op
        calcstr = ''.join(calc)
        output = eval(calcstr)
        if output > 0 and output < 100:
            ### Compute a wrong answer to present ###
            temp_op = ['+','-']
            random.shuffle(temp_op)
            filler = eval(''.join([str(output),temp_op[0],'1']))
            answers = [output,filler]
            random.shuffle(answers)
            
            calc.append('=')
            calc.append(str(output))
            eq = ''.join(calc)
            break
    return (eq,answers)


def calc_numbers2(series,strNum):
    calc1 = eval(''.join([str(series[-1]),strNum]))
    ### flip the sign (+,-) depending on the last number of a given digit ###
    if str(series[-1])[-1] == '1':
        opc = '-'
    elif str(series[-1])[-1] == '9':
        opc = '+'
    else:
        opc = strNum[0]
        
    while True:
        start_n = random.randint(10,90)
        calc2 = eval(''.join([str(series[-1]),opc,str(start_n)]))
        cond = eval(''.join([str(series[-1])[-1],opc,str(start_n)[-1]]))
        if cond < 0 or cond > 10:
            if calc2 > 0 and calc2 < 100:
                break
            
    temp_op = ['+','-']
    random.shuffle(temp_op)
    temp_n = ['1','10']
    random.shuffle(temp_n)
    
    filler1 = eval(''.join([str(calc1),temp_op[0],temp_n[0]]))
    filler2 = eval(''.join([str(calc2),temp_op[1],temp_n[1]]))
    
    TF = random.randint(0,1)
    if TF == 0:
        flag1 = ''.join([str(series[-1]),strNum,'=',str(calc1)])
        flag2 = ''.join([str(series[-1]),strNum[0],str(start_n),'=',str(filler2)])
        return ((flag1,'True'),(flag2,'False'))
    elif TF == 1:
        flag1 = ''.join([str(series[-1]),strNum,'=',str(filler1)])
        flag2 = ''.join([str(series[-1]),opc,str(start_n),'=',str(calc2)])
        return ((flag1,'False'),(flag2,'True'))

## Use the last digit in the series but not necessarily using the same operator here!!
def calc_number3(series,answer,operators1=['+','-'],operators2=['+','-']):
    ## For easy condition ###
    while True:
        random.shuffle(operators1)
        start_n = random.randint(1,9)
        cond = eval(''.join([str(series[-1])[-1],operators1[0],str(start_n)]))
        if cond > 0 and cond < 10:
            calc1 = eval(''.join([str(series[-1]),operators1[0],str(start_n)]))
            if calc1 > 0 and calc1 < 100:
                last_n1 = start_n
                break
    ## For difficult condition ###
    while True:
        random.shuffle(operators2)
        start_n = random.randint(10,90)
        cond = eval(''.join([str(series[-1])[-1],operators2[0],str(start_n)[-1]]))
        if cond < 0 or cond > 10:
            calc2 = eval(''.join([str(series[-1]),operators2[0],str(start_n)]))
            if calc2 > 0 and calc2 < 100:
                last_n2 = start_n
                break
    
    while True:
        temp_op = ['+','-']
        random.shuffle(temp_op)
        temp_n = ['1','10']
        random.shuffle(temp_n)
        
        filler1 = eval(''.join([str(calc1),temp_op[0],temp_n[0]]))
        filler2 = eval(''.join([str(calc2),temp_op[1],temp_n[1]]))
        if answer == 0:
            if filler2 < 100 and filler2 > 0:
                break
        elif answer == 1:
            if filler1 < 100 and filler1 > 0:
                break
    
    #answer = random.randint(0,1)
    if answer == 0:
        flag1 = ''.join([str(series[-1]),operators1[0],str(last_n1),'=',str(calc1)])
        flag2 = ''.join([str(series[-1]),operators2[0],str(last_n2),'=',str(filler2)])
        return ((flag1,'True'),(flag2,'False'))
    elif answer == 1:
        flag1 = ''.join([str(series[-1]),operators1[0],str(last_n1),'=',str(filler1)])
        flag2 = ''.join([str(series[-1]),operators2[0],str(last_n2),'=',str(calc2)])
        return ((flag1,'False'),(flag2,'True'))
   
            
def list_shuffler(series):
    a = series[0:int(len(series)/2)]
    b = series[int(len(series)/2):len(series)]
    ### Manipulation: Comment out if not needed ###
    a = np.subtract(a,1)
    ###############################################
    shuf = [None]*(len(a)+len(b))
    shuf[::2] = a
    shuf[1::2] = b
    return shuf