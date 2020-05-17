[w,rect] = Screen('OpenWindow',0); % open a window
[xCenter,yCenter] = RectCenter(rect); % get the centre coordinates
Screen('TextSize',w,50) % Set text size to 50
Screen('TextStyle',w,1) % Set the text to BOLD
DrawFormattedText(w,'Hello Human!','center','center')
Screen('Closeall')