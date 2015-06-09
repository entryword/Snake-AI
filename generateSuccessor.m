function [ state ] = generateSuccessor( gameState, action, info )

if ~exist('info','var'), info = struct; end
if ~isfield(info,'growTime'), info.growTime = 5; end

state = gameState;
state.time = gameState.time+1;
for i = 1 : length(gameState.snake)
    if ~gameState.snake(i).lose
        state.snake(i).pos = move(gameState.snake(i).pos,action{i},gameState.size(1),gameState.size(2), ~mod(state.time,info.growTime));
        state.snake(i).dir = action{i};
    end
end 
for i = 1 : length(gameState.snake)
    if ~gameState.snake(i).lose && isCollideFood(gameState.field, gameState.snake(i).pos(1,:))
        for j = 1 : size(state.food,1)
            if sum(state.food(j,:)==state.snake(i).pos(1,:))==2
                state.food(j,:) = [];
                state.snake(i).life = state.snake(i).life+1;
                break
            end
        end
    end
end
for i = 1 : length(state.snake)
    if ~gameState.snake(i).lose && isCollideObstacle(gameState.field,state.snake(i).pos(1,:))
        state.snake(i).life = state.snake(i).life-1;
        if state.snake(i).life==0
            state.snake(i).lose = 1;
        end
    end
end
for i = 1 : length(state.snake)
    if ~state.snake(i).lose
        flag = 0;
        for j = 1 : length(state.snake)
            if j~=i && ~state.snake(j).lose
                flag = 1;
                break
            end
        end
        if ~flag, state.snake(i).win = 1; end
    end
end
state.field = generatefieldarray(state);

end

