function [ direction ] = searchAgent( gameState, idx, info )
% % 
% gameState.snake : Array of struct represents snakes
% - gameState.snake(i).pos : Array of (row,col) represents our snake's body position
%   - gameState.snake(i).pos(1) is the head position
% - gameState.snake(i).dir : String {'up','down','left','right'} represents
%       snake's direction
% - gameState.snake(i).life : Integer represents our life
% - gameState.snake(i).win : Integer value represent whether is win
% - gameState.snake(i).lose : Integer value represent whether is lose
% gameState.food : Array of (row,col) represents foods position
% gameState.wall : Array of (row,col) represents wall position
% gameState.size : (row,col) represents field size
% gameState.time : Integer represents game time
% info.method : String {'miniMax','alphaBeta'}
% info.depth : Integer represents tree depth
% info.growTime : Integer represent the time interval snake grow up
% % 

if ~exist('info','var'), info = struct; end
if ~isfield(info,'method'), info.method = 'miniMax'; end
if ~isfield(info,'depth'), info.depth = 5; end
switch info.method
    case 'miniMax'
        result = maxValue(gameState, idx, info, 0);
    case 'alphaBeta'
        result = maxValueAB(gameState, idx, info, 0, -inf, inf);
end
direction = result.action;

end

function result = maxValue (gameState, idx, info, depth)

if depth == info.depth
    result = struct('value', evaluationFunction(gameState,idx), 'action', gameState.snake(idx).dir);
    return 
end
switch gameState.snake(idx).dir
    case 'up'
        actions = {'up' 'left' 'right'};
    case 'down'
        actions = {'down' 'left' 'right'};
    case 'left'
        actions = {'up' 'down' 'left'};
    case 'right'
        actions = {'up' 'down' 'right'};
end
val = -inf;
act = gameState.snake(idx).dir;
snakeAction = cell(1,length(gameState.snake));
for i = 1 : length(gameState.snake)
    snakeAction{i} = gameState.snake(i).dir;
end
nextAgentNo = mod(idx,length(gameState.snake))+1;
for i = 1 : 3
    snakeAction{idx} = actions{i};
    mState = generateSuccessor(gameState, snakeAction, info);
    minVal = minValue(mState, idx, info, depth, nextAgentNo);
    tVal = minVal.value;
    if val < tVal
        val = tVal;
        act = actions{i};
    end
end
result = struct('value', val, 'action', act);
end

function result = minValue (gameState, idx, info, depth, agentNo)

switch gameState.snake(agentNo).dir
    case 'up'
        actions = {'up' 'left' 'right'};
    case 'down'
        actions = {'down' 'left' 'right'};
    case 'left'
        actions = {'up' 'down' 'left'};
    case 'right'
        actions = {'up' 'down' 'right'};
end
val = inf;
snakeAction = cell(1,length(gameState.snake));
for i = 1 : length(gameState.snake)
    snakeAction{i} = gameState.snake(i).dir;
end
nextAgentNo = mod(agentNo,length(gameState.snake))+1;
for i = 1 : 3
    snakeAction{agentNo} = actions{i};
    mState = generateSuccessor(gameState, snakeAction, info);
    if agentNo == idx
        maxVal = maxValue(mState, idx, info, depth+1);
        tVal = maxVal.value;
    else
        minVal = minValue(mState, idx, info, depth, nextAgentNo);
        tVal = minVal.value;
    end
    if val > tVal
        val = tVal;
    end
end
result = struct('value', val, 'action', '');

end

function result = maxValueAB (gameState, idx, info, depth, alpha, beta)

if depth == info.depth
    result = struct('value', evaluationFunction(gameState,idx), 'action', gameState.snake(idx).dir);
    return 
end
switch gameState.snake(idx).dir
    case 'up'
        actions = {'up' 'left' 'right'};
    case 'down'
        actions = {'down' 'left' 'right'};
    case 'left'
        actions = {'up' 'down' 'left'};
    case 'right'
        actions = {'up' 'down' 'right'};
end
val = -inf;
act = gameState.snake(idx).dir;
snakeAction = cell(1,length(gameState.snake));
for i = 1 : length(gameState.snake)
    snakeAction{i} = gameState.snake(i).dir;
end
nextAgentNo = mod(idx,length(gameState.snake))+1;
for i = 1 : 3
    snakeAction{idx} = actions{i};
    mState = generateSuccessor(gameState, snakeAction, info);
    minVal = minValueAB(mState, idx, info, depth, nextAgentNo, alpha, beta);
    tVal = minVal.value;
    if val < tVal
        val = tVal;
        act = actions{i};
    end
    if val > beta
        result = struct('value',val,'action',act);
        return
    end
    alpha = max(alpha, val);
end
result = struct('value', val, 'action', act);

end

function result = minValueAB (gameState, idx, info, depth, agentNo, alpha, beta)

switch gameState.snake(agentNo).dir
    case 'up'
        actions = {'up' 'left' 'right'};
    case 'down'
        actions = {'down' 'left' 'right'};
    case 'left'
        actions = {'up' 'down' 'left'};
    case 'right'
        actions = {'up' 'down' 'right'};
end
val = inf;
snakeAction = cell(1,length(gameState.snake));
for i = 1 : length(gameState.snake)
    snakeAction{i} = gameState.snake(i).dir;
end
nextAgentNo = mod(agentNo,length(gameState.snake))+1;
for i = 1 : 3
    snakeAction{agentNo} = actions{i};
    mState = generateSuccessor(gameState, snakeAction, info);
    if nextAgentNo == idx
        maxVal = maxValueAB(mState, idx, info, depth+1, alpha, beta);
        tVal = maxVal.value;
    else
        minVal = minValueAB(mState, idx, info, depth, nextAgentNo, alpha, beta);
        tVal = minVal.value;
    end
    if val > tVal
        val = tVal;
    end
    if val < alpha
        result = struct('value',val,'action','');
        return
    end
    beta = min(beta, val);
end
result = struct('value', val, 'action', '');

end

function value = evaluationFunction(gameState, idx)
% % 
% Return the score of game state of now

if gameState.snake(idx).lose, value = -inf;
elseif gameState.snake(idx).win, value = inf;
else
    value = 0;
    for i = 1 : length(gameState.snake)
        if i==idx, continue; end
        for j = 1 : length(gameState.snake(i).pos)
            x = gameState.snake(idx).pos(1,2)-gameState.snake(i).pos(j,2);
            y = gameState.snake(idx).pos(1,1)-gameState.snake(i).pos(j,1);
            dist2 = x*x+y*y;
            value = value-1/dist2;
        end
    end
    for i = 1 : size(gameState.food,1)
        x = gameState.snake(idx).pos(1,2)-gameState.food(i,2);
        y = gameState.snake(idx).pos(1,1)-gameState.food(i,1);
        dist2 = x*x+y*y;
        value = value+100/dist2;
    end
end

end


