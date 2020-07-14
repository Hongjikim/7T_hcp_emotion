function output = device_check(whichcomp, mri)

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height];
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

black = 0;
white = 255;
red = [190 0 0];
bgcolor = 50;
fontsize = 60;

device(1).product = 'Magic Keyboard with Numeric Keypad'; % Experimenter
device(1).vendorID= 76;
device(2).product = '932'; % participants
device(2).vendorID= 6171;
device(3).product = 'KeyWarrior8 Flex'; % scanner
device(3).vendorID= 1984;

if whichcomp == 1
    Experimenter = IDKeyboards(device(1));
    Participant = IDKeyboards(device(2));
    Scanner = IDKeyboards(device(3));
else
    Experimenter =[]; Scanner = []; Participant =[];
end

% keyboard
KbName('UnifyKeyNames');
sync = KbName('s');
Abort = KbName('q');
Space = KbName('space');
K1 = KbName('1!');
K2 = KbName('2@');
Z = KbName('z');
X = KbName('x');

while mri
    [keyisdown, ~, keycode] = KbCheck(Scanner);
    if keyisdown
        if keycode(sync)
            break;
        end
    end
end

[theWindow, ~] = Screen('OpenWindow', window_num, bgcolor, window_rect);

Screen('TextSize', theWindow, fontsize);
fixation_point = double('+') ;
DrawFormattedText(theWindow, fixation_point, 'center', 'center', white);
Screen('Flip', theWindow);

ch = [];
while 1
    [keyisdown,~,keycode,~] = KbCheck;
    if keyisdown
        if keycode(X)
            break
        else
            ch = [ch KbName(keycode)];
            if length(ch) > 31
                x = ch(end-30:end);
            else
                x = ch;
            end
            DrawFormattedText(theWindow, x, 'center', 'center', white);
            Screen(theWindow,'Flip');
        end
    end
end

Screen('CloseAll');
output = ch;

end