function pixelTrigger = dispPixelTrigger(session, pixelTrigger)

global GL

% Draw pixel trigger
pixelTrigger = double(pixelTrigger);
glRasterPos2d(session.center(1), session.center(2)-300);
glDrawPixels(size(pixelTrigger, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(pixelTrigger));


end

