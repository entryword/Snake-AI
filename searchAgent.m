function [ direction ] = searchAgent( snakepos, snakedir, foodpos )

direction = snakedir;
minDis = inf;
for i = 1 : size(foodpos,1)
    dist = norm(snakepos(1,:)-foodpos(i,:), 1);
    if dist<minDis
        minDis = dist;
        minDisIdx = i;
    end
end

if foodpos(minDisIdx,1)-snakepos(1,1)>0
    if ~strcmp(snakedir,'down')
        direction = 'up';
        return
    end
elseif foodpos(minDisIdx,1)-snakepos(1,1)<0
    if ~strcmp(snakedir,'up')
        direction = 'down';
        return
    end
end

if foodpos(minDisIdx,2)-snakepos(1,2)>0
    if ~strcmp(snakedir,'left')
        direction = 'right';
    end
elseif foodpos(minDisIdx,2)-snakepos(1,2)<0
    if ~strcmp(snakedir,'right')
        direction = 'left';
    end
end


end

