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
% gameState.size : (row,col) represents field size
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
actions = getLegalActions(gameState,info,1);
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
actions = getLegalActions(gameState,info ,agentNo);
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
actions = getLegalActions(gameState,info,1);
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
actions = getLegalActions(gameState, info,agentNo);
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
if agentIndex == 1 
    snakehead=gameState.self.pos(1,:);
else
    snakehead=gameState.rival(agentIndex-1).pos(1,:);
end
x=snakehead(1);
y=snakehead(2);
up_x=mod(x-2,28)+1;
up_y=y;
num_dir=0;
if(gameState.field(up_x,up_y)==0)
    num_dir=num_dir+1;
    actions{num_dir}='up';
end
down_x=mod(x,28)+1;
down_y=y;
if(gameState.field(down_x,down_y)==0)
    num_dir=num_dir+1;
    actions{num_dir}='down';
end
left_x=x;
left_y=mod(y-2,28)+1;
if(gameState.field(left_x,left_y)==0)
    num_dir=num_dir+1;
    actions{num_dir}='left';
end
right_x=x;
right_y=mod(y,28)+1;
if(gameState.field(right_x,right_y)==0)
    num_dir=num_dir+1;
    actions{num_dir}='right';
end
end

function value = evaluationFunction(gameState)
% % 
% Return the score of game state of now
value = -inf;

end

function state = generateSuccessor(gameState, agentIndex,action)
% % 
% Return the result of game state that after taking action 'action'
state.field=gameState.field;
state.self.pos = move(gameState.self.pos, action, gameState.size(1), gameState.size(2));
state.self.dir = gameState.self.dir;
for i = 1 : length(gameState.rival)
    state.rival(i).pos = move(gameState.rival(i).pos, gameState.rival(i).dir, gameState.size(1), gameState.size(2));
    state.rival(i).dir = gameState.rival(i).dir;
end
state.self.lose = 0;
for i = 1 : length(gameState.rival)
% %     Self lose - self touch rival
    for j = 1 : size(gameState.rival(i).pos,1)
        if sum(gameState.self.pos(1,:)==gameState.rival(i).pos(j,:))==2
            state.self.lose = 1;
            break
        end
    end
    if state.self.lose == 1, break; end
end
% % Rival lose
for i = 1 : length(gameState.rival)
    state.rival(i).lose = 0;
% %     Rival touch self
    for j = 1 : size(gameState.self.pos,1)
        if sum(gameState.rival(i).pos(1,:)==gameState.self.pos(j,:))==2
            state.rival(i).lose = 1;
        end
    end
    if ~state.rival(i).lose
% %         Rival touch rival
        for j = 1 : size(gameState.rival,1)
            if i~=j
                for k = 1 : size(gameState.rival(j).pos,1)
                    if sum(gameState.rival(i).pos(1,:)==gameState.rival(j).pos(k,:))==2
                        state.rival(i).lose = 1;
                        break
                    end
                end
            end
            if state.rival(i).lose == 1, break; end
        end
    end
end
% % Self win
state.self.win = 1;
for i = 1 : length(state.rival)
    if ~state.rival(i).lose
        state.self.win = 0;
        break;
    end
end
% % Rival win
for i = 1 : length(state.rival)
    state.rival(i).win = 1;
% %     Self not lose
    if ~state.self.lose
        state.rival(i).win = 0;
        continue
    end
% %     Rival' not lose
    for j = 1 : length(state.rival)
        if i~=j && ~state.rival(j).lose
            state.rival(i).win = 0;
            break
        end
    end
end
state.food = [];
for i = 1 : size(gameState.food,1)
    if sum(state.self.pos(1,:)==gameState.food(i).pos(1,:))==2
        continue
    end
    flag = 0;
    for j = 1 : length(state.rival)
        if sum(state.rival(j).pos(1,:)==gameState.food(i).pos(1,:))==2
            flag = 1;
            break
        end
    end
    if ~flag
        state.food = [state.food gameState.food(i)];
    end
end

state.wall = gameState.wall;
state.size = gameState.size;

end

function result = move(pos, dir, h, w)
result = [[0 0];pos(1:end-1,:)];
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
result(1,1) = mod(result(1,1),h);
result(1,2) = mod(result(1,2),w);
end

function numAgents = getNumAgents(gameState)
% % 
% Return the number of agents
numAgents = length(gameState.rival)+1;

end

