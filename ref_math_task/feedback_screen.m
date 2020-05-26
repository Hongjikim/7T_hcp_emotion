function feedback_screen(w,response,selection,cnum,init)

Screen('TextSize', w, init.txtsize1);
stim_loc = init.stim_loc; ans_loc = init.ans_loc; stim_mpoint = init.stim_mpoint; keys = init.keys;
correct_color = init.correct_color; wrong_color = init.wrong_color; base_color = [255 255 255];
switch response
    case 1
        %Screen('FrameRect',w,[0 220 0],stim_loc{end},10); ii = 1;
%         ii = 1;
%         while ii <= length(stim_loc)
%             if ii == length(stim_loc)
%                 %DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), correct_color);
%                 DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), base_color);
%             else
%                 %DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), [255 255 255]);
%                 DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), correct_color);
%             end
%             ii = ii + 1;
%         end
        ii = 1;
        while ii<= length(stim_loc)
            DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), correct_color);
            ii = ii+1;
        end
        %DrawFormattedText(w, 'Is      correct?', stim_mpoint(3), stim_mpoint(4), [255 255 255]);
        %DrawFormattedText(w, ['    ' cnum{end}], stim_mpoint(3), stim_mpoint(4), correct_color);
%         DrawFormattedText(w, 'Is      correct?', stim_mpoint(3), stim_mpoint(4), correct_color);
%         DrawFormattedText(w, ['    ' cnum{end}], stim_mpoint(3), stim_mpoint(4), base_color);
        DrawFormattedText(w, ['Is ' cnum{end} ' correct?'], stim_mpoint(3), stim_mpoint(4), correct_color);
        Screen('TextSize', w, init.txtsize3);
        if selection == keys(1)
            %DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), correct_color);
            %DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), [255 255 255]);
            DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), base_color);
            DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), correct_color);
        else
            %DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), [255 255 255]);
            %DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), correct_color);
            DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), correct_color);
            DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), base_color);
        end
    case 0
        %Screen('FrameRect',w,[250 0 0],stim_loc{end},10); ii = 1;
%         ii = 1;
%         while ii <= length(stim_loc)
%             if ii == length(stim_loc)
%                 %DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), wrong_color);
%                 DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), [255 255 255]);
%             else
%                 %DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), [255 255 255]);
%                 DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), wrong_color);
%             end
%             ii = ii + 1;
%         end
        ii = 1;
        while ii<= length(stim_loc)
            DrawFormattedText(w, cnum{ii}, stim_loc{ii}(3), stim_loc{ii}(4), correct_color);
            ii = ii+1;
        end
        %DrawFormattedText(w, 'Is      correct?', stim_mpoint(3), stim_mpoint(4), [255 255 255]);
        %DrawFormattedText(w, ['    ' cnum{end}], stim_mpoint(3), stim_mpoint(4), wrong_color);
        %DrawFormattedText(w, 'Is      correct?', stim_mpoint(3), stim_mpoint(4), wrong_color);
        %DrawFormattedText(w, ['    ' cnum{end}], stim_mpoint(3), stim_mpoint(4), [255 255 255]);        
        DrawFormattedText(w, ['Is ' cnum{end} ' correct?'], stim_mpoint(3), stim_mpoint(4), correct_color);
        Screen('TextSize', w, init.txtsize3);
        if ~isempty(selection)
            if selection == keys(1)
                %DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), wrong_color);
                %DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), [255 255 255]);
                DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), base_color);
                DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), wrong_color);
            elseif selection == keys(2)
                %DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), [255 255 255]);
                %DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), wrong_color);
                DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), wrong_color);
                DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), base_color);
            end
        else
            DrawFormattedText(w, 'O', ans_loc{1}(3), ans_loc{1}(4), wrong_color);
            DrawFormattedText(w, 'X', ans_loc{2}(3), ans_loc{2}(4), wrong_color);
        end
end