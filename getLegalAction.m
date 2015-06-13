function [ actions ] = getLegalAction( dir )

switch dir
    case 'up'
        actions = {'left' 'up' 'right'};
    case 'down'
        actions = {'right' 'down' 'left'};
    case 'left'
        actions = {'down' 'left' 'up'};
    case 'right'
        actions = {'up' 'right' 'down'};
end

end

