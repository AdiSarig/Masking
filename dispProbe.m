function xy_loc = dispProbe(session, xy_loc)

% [xCenter, yCenter] = RectCenter(session.windowRect);
dotColor = [1 0 0];
dotSizePix = 8;

if isempty(xy_loc)
    screenXpixels = session.stim.location(3) - session.stim.location(1) - dotSizePix;
    screenYpixels = session.stim.location(4) - session.stim.location(2) - dotSizePix;
    rand('seed', sum(100 * clock));
    
    dotXpos = rand * screenXpixels + session.stim.location(1);
    dotYpos = rand * screenYpixels + session.stim.location(2);
    xy_loc = [dotXpos dotYpos] + dotSizePix/2;
end

Screen('DrawDots', session.window, xy_loc, dotSizePix, dotColor, [], 2);

end
