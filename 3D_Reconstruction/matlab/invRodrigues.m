function r = invRodrigues(R)
% invRodrigues
% Input:
%   R: 3x3 rotation matrix
% Output:
%   r: 3x1 vector

x = atan2(R(3,2), R(3,3));
y = atan2(-R(3,1), sqrt(R(3,2)*R(3,2) + R(3,3)*R(3,3)));
z = atan2(R(2,1), R(1,1));
r = [x y z]';

end
