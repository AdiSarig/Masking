function dispProbe(session, xy_loc)

% [xCenter, yCenter] = RectCenter(session.windowRect);
dotColor = [1 0 0];
dotSizePix = 8;

Screen('DrawDots', session.window, xy_loc, dotSizePix, dotColor, [], 2);

end
