function TTL = setTrigger(session,isTypeA)

if isTypeA % conscious
    switch session.blocks(session.current.blockNum).trials(session.current.trialNum).stimulusType
        case 'face'
            TTL = session.triggers(1).C_face;
        case 'house'
            TTL = session.triggers(1).C_house;
        case 'noise'
            TTL = session.triggers(1).C_noise;
    end
else % unconscious
    switch session.blocks(session.current.blockNum).trials(session.current.trialNum).stimulusType
        case 'face'
            TTL = session.triggers(1).UC_face;
        case 'house'
            TTL = session.triggers(1).UC_house;
        case 'noise'
            TTL = session.triggers(1).UC_noise;
    end
end

end

