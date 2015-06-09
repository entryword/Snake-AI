function [ field ] = generatefieldarray( gameState )

field = gameState.wall;
for i = 1 : length(gameState.snake)
    for j = 1 : length(gameState.snake(i).pos)
        field(gameState.snake(i).pos(j,1),gameState.snake(i).pos(j,2)) = 2*i+10;
        if j==1
            field(gameState.snake(i).pos(j,1),gameState.snake(i).pos(j,2)) = 2*i+9;
        end
    end
end
for i = 1 : length(gameState.food)
    field(gameState.food(i,1),gameState.food(i,2)) = 5;
end    

end

