function dispProbe(session)

    % [xCenter, yCenter] = RectCenter(session.windowRect);
    dotColor = [1 0 0];
    
    screenXpixels = session.windowRect(3) - session.windowRect(1);
    screenYpixels = session.windowRect(4) - session.windowRect(2);
    rand('seed', sum(100 * clock));
dotSizePix = 20;

    dotXpos = rand * screenXpixels;
    dotYpos = rand * screenYpixels;

    Screen('DrawDots', session.window, [dotXpos dotYpos], dotSizePix, dotColor, [], 2);

end
