function [ direction ] = searchAgent( gameState, info )
% % 
% gameState.self.pos : Array of (row,col) represents our snake's body position,
%   gameState.self.pos(1) is the head position
% gameState.self.dir : String {'up','down','left','right'} represents our
%   snake's direction
% gameState.self.life : Integer represents our life
% gameState.self.win : Boolean value represent whether is win
% gameState.self.lose : Boolean value represent whether is lose
% gameState.rival : Array of structure includes all rival snake information
% - gameState.rival(i).pos
% - gameState.rival(i).dir
% - gameState.rival(i).life
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
        result = maxValueAB(gameState, info, 0, -inf, inf);
end
% disp('finish')
% pause
direction = result.action;

end

function result = maxValue (gameState, info, depth)
% disp('maxV')
% depth
% pause
if depth == info.depth
    result = struct('value', evaluationFunction(gameState), 'action', gameState.self.dir);
    return 
end
switch gameState.self.dir
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
act = gameState.self.dir;
for i = 1 : 3
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
% disp('minV')
% agentNo
% pause
switch gameState.rival(agentNo-1).dir
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
for i = 1 : 3
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

if depth == info.depth
    result = struct('value', evaluationFunction(gameState), 'action', gameState.self.dir);
    return 
end
switch gameState.self.dir
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
act = gameState.self.dir;
for i = 1 : 3
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

switch gameState.rival(agentNo-1).dir
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
for i = 1 : 3
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

% function actions = getLegalActions(gameState, info, agentIndex)
% % % 
% % Return array of cells include string {'up','down','left','right'}
% if agentIndex == 1 
%     snakehead=gameState.self.pos(1,:);
% else
%     snakehead=gameState.rival(agentIndex-1).pos(1,:);
% end
% x=snakehead(1);
% y=snakehead(2);
% up_x=mod(x-2,28)+1;
% up_y=y;
% num_dir=0;
% if(gameState.field(up_x,up_y)==0)
%     num_dir=num_dir+1;
%     actions{num_dir}='up';
% end
% down_x=mod(x,28)+1;
% down_y=y;
% if(gameState.field(down_x,down_y)==0)
%     num_dir=num_dir+1;
%     actions{num_dir}='down';
% end
% left_x=x;
% left_y=mod(y-2,28)+1;
% if(gameState.field(left_x,left_y)==0)
%     num_dir=num_dir+1;
%     actions{num_dir}='left';
% end
% right_x=x;
% right_y=mod(y,28)+1;
% if(gameState.field(right_x,right_y)==0)
%     num_dir=num_dir+1;
%     actions{num_dir}='right';
% end
% 
% end

function value = evaluationFunction(gameState)
% % 
% Return the score of game state of now
% disp('eva')
if gameState.self.lose, value = -inf;
elseif gameState.self.win, value = inf;
else
    value = 0;
    for i = 1 : length(gameState.rival)
        for j = 1 : length(gameState.rival(i).pos)
            x = gameState.self.pos(1,2)-gameState.rival(i).pos(j,2);
            y = gameState.self.pos(1,1)-gameState.rival(i).pos(j,1);
            dist2 = x*x+y*y;
            value = value-1/dist2;
        end
    end
    for i = 1 : length(gameState.food)
        x = gameState.self.pos(1,2)-gameState.food(i).pos(2);
        y = gameState.self.pos(1,1)-gameState.food(i).pos(1);
        dist2 = x*x+y*y;
        value = value+1/dist2;
    end
end

end

function state = generateSuccessor(gameState, agentIndex, action)
% % 
% Return the result of game state that after taking action 'action'
% disp('gen')
% pause
state = gameState;
if agentIndex==1
    state.self.pos = move(gameState.self.pos, action, gameState.size(1), gameState.size(2));
    state.self.dir = action;
else
    state.rival(agentIndex-1).pos = move(gameState.rival(agentIndex-1).pos, action, gameState.size(1), gameState.size(2));
    state.rival(agentIndex-1).dir = action;
end

for i = 1 : length(state.rival)
% %     Self touch rival
    if ~state.rival(i).lose, continue; end 
    touch = 0;
    for j = 1 : size(state.rival(i).pos,1)
        if sum(state.self.pos(1,:)==state.rival(i).pos(j,:))==2
            state.self.life = state.self.life-1;
            if state.self.life==0, state.self.lose = 1; end
            touch = 1;
            break
        end
    end
    if touch, break; end
end

for i = 1 : length(state.rival)
% %     Rival touch self
    touch = 0;
    for j = 1 : size(state.self.pos,1)
        if sum(state.rival(i).pos(1,:)==state.self.pos(j,:))==2
            state.rival(i).life = state.rival(i).life-1;
            if state.rival(i).life==0, state.rival(i).lose = 1; end
            touch = 1;
            break
        end
    end
    if ~touch
% %         Rival touch rival
        for j = 1 : length(state.rival)
            if i~=j
                touch = 0;
                for k = 1 : size(state.rival(j).pos,1)
                    if sum(state.rival(i).pos(1,:)==state.rival(j).pos(k,:))==2
                        state.rival(i).life = state.rival(i).life-1;
                        if state.rival(i).life==0, state.rival(i).lose = 1; end
                        touch = 1;
                        break
                    end
                end
            end
            if touch, break; end
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
% %     Rival not lose
    for j = 1 : length(state.rival)
        if i~=j && ~state.rival(j).lose
            state.rival(i).win = 0;
            break
        end
    end
end
state.food = [];
for i = 1 : size(gameState.food,1)
%     If self eat the food, this food doesn't be added to the array
    if sum(state.self.pos(1,:)==gameState.food(i).pos(1,:))==2
        continue
    end
    flag = 0;
%     If rival eat food
    for j = 1 : length(state.rival)
        if sum(state.rival(j).pos(1,:)==gameState.food(i).pos(1,:))==2
            flag = 1;
            break
        end
    end
%     No one eat food
    if ~flag
        state.food = [state.food gameState.food(i)];
    end
end

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
result(1,1) = mod(result(1,1)-1,h)+1;
result(1,2) = mod(result(1,2)-1,w)+1;

end

function numAgents = getNumAgents(gameState)
% % 
% Return the number of agents
numAgents = length(gameState.rival)+1;

end

