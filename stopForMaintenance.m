function stopForMaintenance(session)

Screen('DrawTexture',session.window, session.instructions.maintenanceTex);
Screen('Flip',session.window);
KbWait([],2);

end