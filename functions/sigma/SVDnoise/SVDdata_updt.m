function [w, gamma] = SVDdata_updt(model)
% Draw velocity noise based on the Karhunen?Loeve (KL) decomposition.
%
% Written by Long Li - 2020/12/02.
%

nm = model.sigma.N_mod;
MX = model.grid.MX;
np = 2*prod(MX);

% Draw standard Gaussian variables
gamma = randn(nm,1);

% Build noise by KL decomposition
Ustat = reshape(model.sigma.base_phi,[np,nm]);
w = reshape(Ustat*gamma, [model.grid.MX, 2]);

end