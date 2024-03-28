function fcn_busyLamp(app,type,lamp_name)
switch type
    case 'busy'
        app.(lamp_name).Color      =  [1 0 0];
    case 'ready'
        app.(lamp_name).Color      =  [0 1 0];
end
end