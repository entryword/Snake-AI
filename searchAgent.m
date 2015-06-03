function [ direction ] = searchAgent( gameState, info )
% % 
% gameState.self.pos : Array of (row,col) represents our snake's body position,
%   gameState.self.pos(1) is the head position
% gameState.self.dir : String {'up','down','left','right'} represents our snake
%   direction
% gameState.self.win : Boolean value represent whether is win
% gameState.self.lose : Boolean value represent whether is lose
% gameState.rival : Array of structure includes all rival snake information
% - gameState.rival(i).pos
% - gameState.rival(i).dir
% - gameState.rival(i).win
% - gameState.rival(i).lose
% gameState.food : Array of structure represents foods
% - gameState.food(i).pos
% gameState.wall : Array of structure represents wall
% - gameState.wall(i).pos
% info.method : String {'miniMax','alphaBeta'}
% info.depth : Integer represents tree depth
% % 

if ~exist('info','var'), info = struct; end
if ~isfield(info,'method'), info.method = 'miniMax'; end
if ~isfield(info,'depth'), info.depth = 5; end
switch info.method
    case 'miniMax'
        result = maxValue(gameState, info, 0);
    case 'alphaBeta'
end
direction = result.action;

end

function result = maxValue (gameState, info, depth)
actions = getLegalActions(gameState,1);
if depth == info.depth || isempty(actions)
    result = struct('value', evaluationFunction(gameState), 'action', gameState.self.dir);
    return 
end
val = -inf;
act = gameState.self.dir;
for i = 1 : length(actions)
    action = actions{i};
    mState = generateSuccessor(gameState, 1, action);
    minVal = minValue(mState, info, depth, 2);
    tVal = minVal.value;
    if val < tVal
        val = tVal;
        act = action;
    end
end
result = struct('value', val, 'action', act);
end

function result = minValue (gameState, info, depth, agentNo)
actions = getLegalActions(gameState, agentNo);
if isempty(actions)
    result = struct('value', evaluationFunction(gameState), 'action', '');
    return
end
val = inf;
for i = 1 : length(actions)
    action = actions{i};
    mState = generateSuccessor(gameState, agentNo, action);
    if agentNo == getNumAgents(gameState)
        maxVal = maxValue(mState, info, depth+1);
        tVal = maxVal.value;
    else
        minVal = minValue(mState, info, depth, agentNo+1);
        tVal = minVal.value;
    end
    if val > tVal
        val = tVal;
    end
end
result = struct('value', val, 'action', '');
end

function result = maxValueAB (gameState, info, depth, alpha, beta)
actions = getLegalActions(gameState,1);
if depth == info.depth || isempty(actions)
    result = struct('value', evaluationFunction(gameState), 'action', gameState.self.dir);
    return 
end
val = -inf;
act = gameState.self.dir;
for i = 1 : length(actions)
    action = actions{i};
    mState = generateSuccessor(gameState, 1, action);
    minVal = minValueAB(mState, info, depth, 2);
    tVal = minVal.value;
    if val < tVal
        val = tVal;
        act = action;
    end
    if val > beta
        result = struct('value',val,'action',act);
        return
    end
    alpha = max(alpha, val);
end
result = struct('value', val, 'action', act);
end

function result = minValueAB (gameState, info, depth, agentNo, alpha, beta)
actions = getLegalActions(gameState, agentNo);
if isempty(actions)
    result = struct('value', evaluationFunction(gameState), 'action', '');
    return
end
val = inf;
for i = 1 : length(actions)
    action = actions{i};
    mState = generateSuccessor(gameState, agentNo, action);
    if agentNo == getNumAgents(gameState)
        maxVal = maxValueAB(mState, info, depth+1);
        tVal = maxVal.value;
    else
        minVal = minValueAB(mState, info, depth, agentNo+1);
        tVal = minVal.value;
    end
    if val > tVal
        val = tVal;
    end
    if val < alpha
        result = struct('vaule',val,'action','');
        return
    end
    beta = min(beta, val);
end
result = struct('value', val, 'action', '');
end

function actions = getLegalActions(gameState, info, agentIndex)
% % 
% Return array of cells include string {'up','down','left','right'}

end

function value = evaluationFunction(gameState)
% % 
% Return the score of game state of now
value = -inf;

end

function state = generateSuccessor(gameState, agentIndex, action)
% % 
% Return the result of game state that after taking action 'action'

end

function numAgents = getNumAgents(gameState)
% % 
% Return the number of agents
numAgents = length(gameState.rival)+1;

end

