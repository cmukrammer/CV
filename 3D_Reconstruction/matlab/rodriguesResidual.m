function residuals = rodriguesResidual(K1, M1, p1, K2, p2, x)
% rodriguesResidual:
% Inputs:
%   K1 - 3x3 camera calibration matrix 1
%   M1 - 3x4 projection matrix 1
%   p1 - Nx2 matrix of (x, y) coordinates
%   K2 - 3x3 camera calibration matrix 2
%   p2 - Nx2 matrix of (x, y) coordinates
%   x - (3N + 6)x1 flattened concatenation of P, r_2 and t_2

% Output:
%   residuals - 4Nx1 vector

P = x(1:end-6, :);
N = size(P, 1);
N = N/3;
r_2 = x(end-5:end-3, :);
t_2 = x(end-2:end,:);
M2 = [rodrigues(r_2) t_2];
C1 = K1*M1;
C2 = K2*M2;
newP = reshape(P, [3 N]);
newP = [newP;ones([1 N])];
newP1 = C1*newP;
newP1 = newP1./newP1(3,:);
newP1 = newP1(1:2,:);
newP2 = C2*newP;
newP2 = newP2./newP2(3,:);
newP2 = newP2(1:2,:);
error1 = p1' - newP1;
error2 = p2' - newP2;
residuals = [error1(:);error2(:)];
end
