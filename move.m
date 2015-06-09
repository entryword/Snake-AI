function result = move(pos, dir, h, w, grow)
if grow
    result = [[0 0];pos];
else
    result = [[0 0];pos(1:end-1,:)];
end
switch dir
    case 'up'
        result(1,:) = pos(1,:)+[1 0];
    case 'down'
        result(1,:) = pos(1,:)-[1 0];
    case 'left'
        result(1,:) = pos(1,:)-[0 1];
    case 'right'
        result(1,:) = pos(1,:)+[0 1];
end
result(1,1) = mod(result(1,1)-1,h)+1;
result(1,2) = mod(result(1,2)-1,w)+1;

end