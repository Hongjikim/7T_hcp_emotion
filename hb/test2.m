[windowPtr,rect] = Screen('OpenWindow', 0, [255 255 255], [0 0 2560/2 1440/2]);
[xCenter,yCenter] = RectCenter(rect); % get the centre coordinates
Screen('TextSize',windowPtr,50) % Set text size to 50
Screen('TextStyle',windowPtr,1) % Set the text to BOLD
DrawFormattedText(windowPtr,'Hello Human!','center','center')
WaitSecs(5);
clear Screen;