function [pos, dir] = snakeInitTable( idx )

pos = zeros(8,2);
switch idx
    case 1
        pos(:,1) = 25;
        pos(:,2) = 15:-1:8;
        dir = 'right';
    case 2
        pos(:,1) = 3; 
        pos(:,2) =  18:1:25;
        dir = 'left';
    case 3
        pos(:,1) = [12,11,10,9,9,10,11,12]; 
        pos(:,2) =  [3,3,3,3,2,2,2,2];
        dir = 'right';
    case 4
        pos(:,1) = [18,17,16,15,15,16,17,18]; 
        pos(:,2) =  [3,3,3,3,2,2,2,2];
        dir = 'right';
    case 5
        pos(:,1) = [15,14,13,12,12,13,14,15]; 
        pos(:,2) =  [26,26,26,26,27,27,27,27];
        dir = 'left';
    case 6
        pos(:,1) = 27; 
        pos(:,2) = 24:-1:17;
        dir = 'right';
end

end

