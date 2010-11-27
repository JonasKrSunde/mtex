function E = CristoffelTensor(C,n)
% Cristoffel tensor of an elasticity tensor for a given direction
%
%% Desription
% Formular: E_jk = C_ijkl n_j n_l
%
%% Input
%  C - elatic stiffness @tensor
%  x - list of @vector3d
%
%% Output
%  E - Cristoffel @tensor
%
%% See also
% tensor/quadric tensor/rotate

% compute tensor products
E = EinsteinSum(C,[1 -1 2 -2],n,-1,n,-2);

C.name = 'Cristoffel';