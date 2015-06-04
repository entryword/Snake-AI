function [ direction ] = searchAgent( gameState, info )
% % 
% gameState.snake.pos : Array of (row,col) represents our snake's body position,
%   gameState.snake.pos(1) is the head position
% gameState.snake.dir : String {'up','down','left','right'} represents our snake
%   direction
% gameState.snake.win : Boolean value represent whether is win
% gameState.snake.lose : Boolean value represent whether is lose
% gameState.rival : Array of structure includes all rival snake information
% - gameState.rival(i).pos
% - gameState.rival(i).dir
% - gameState.rival(i).win
% - gameState.rival(i).lose
% gameState.food : Array of structure represents foods
% - gameState.food(i).pos
% info.method : String {'miniMax','alphaBeta'}
% % 

if ~isfield(info,'method'), info.method = 'BFS'; end
switch info.method
    case 'miniMax'
        
    case 'alphaBeta'
end

end

function getLegalActions(gameState, info, idx)

end

function maxValue (gameState, depth)
    actions = getLegalActions(gameState,1);
    if depth == 
end

function minValue ()
end

