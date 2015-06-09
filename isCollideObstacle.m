function [ result ] = isCollideObstacle( filed, nextHeadPos )

result = filed(nextHeadPos(1),nextHeadPos(2))~=0 && filed(nextHeadPos(1),nextHeadPos(2))~=5;

end

