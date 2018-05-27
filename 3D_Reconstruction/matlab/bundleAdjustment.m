function [M2, P] = bundleAdjustment(K1, M1, p1, K2, M2_init, p2, P_init)
% bundleAdjustment:
% Inputs:
%   K1 - 3x3 camera calibration matrix 1
%   M1 - 3x4 projection matrix 1
%   p1 - Nx2 matrix of (x, y) coordinates
%   K2 - 3x3 camera calibration matrix 2
%   M2_init - 3x4 projection matrix 2
%   p2 - Nx2 matrix of (x, y) coordinates
%   P_init: Nx3 matrix of 3D coordinates
%
% Outputs:
%   M2 - 3x4 refined from M2_init
%   P - Nx3 refined from P_init

% x - (3N + 6)x1 flattened concatenation of P, r_2 and t_2
r_2 = invRodrigues(M2_init(1:3,1:3));
t_2 = M2_init(:,end);
N = size(p1,1);
P_init = P_init';
X0 = [P_init(:);r_2;t_2];
options = optimoptions('lsqnonlin','Display','iter');%,'Algorithm','levenberg-marquardt');

X = lsqnonlin(@(x) rodriguesResidual(K1,M1,p1,K2,p2,x), X0, [], [], options);
P = X(1:3*N,:);
r_2 = X(3*N+1:3*N+3,:);
t_r = X(3*N+4:end,:);
M2 = [rodrigues(r_2) t_r];
P = reshape(P, [3 N]);
P = P';
end
