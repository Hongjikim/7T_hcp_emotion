function drawFixationCross(wPtr, rect, crossLength, crossColor, crossWidth)
    crossLines = [-crossLength 0;crossLength 0;0 -crossLength;0 crossLength];
    crossLines = transpose(crossLines);
    
    xCenter = rect(3)/2;
    yCenter = rect(4)/2;
    
    Screen('DrawLines', wPtr, crossLines, crossWidth, crossColor, [xCenter yCenter]);
end