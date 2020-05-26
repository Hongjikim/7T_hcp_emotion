[windowPtr,rect] = Screen('OpenWindow', 0, [255 255 255], [0 0 2560/2 1440/2]);
rectOne = [100 100 250 400];
rectTwo = [250 400 300 450];
bothRects = [rectOne', rectTwo'];

%Screen('FillRect',windowPtr,[255 0 0],[100 100 500 500]);
Screen('FillRect', windowPtr, [255 0 0], [100 100 500 500]);
Screen('Flip', windowPtr);
WaitSecs(5);

Screen('Flip', windowPtr);
WaitSecs(5);
Screen('FillRect', windowPtr, [255 0 0], bothRects);
Screen('Flip', windowPtr);
WaitSecs(5);

clear Screen;