function [ result ] = isCollideFood( field, headPos )

result = field(headPos(1),headPos(2))==5;

end

