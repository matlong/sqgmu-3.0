function model = SVDdata_init(model)
% Intialize the 'SVDdata' noise model by trucating the spatial modes 
% weighted by the associated eigenvalues, and then derive the staionary
% variance tensor of the noise. 
%
% Written by Long Li - 2020/12/01.
%
% [TODO] Scaling amptitude by 'k_c'?
%

% Get dimensions
MX = model.grid.MX;
np = prod(MX); % number of points 
nm = model.sigma.N_mod; % number of modes
id1 = model.sigma.ID_mod1; % 1st mode index

% Read spatial modes associated with the eigenvalues (of covariance matrix)
load(model.sigma.file_mod,'spat_mode','eval_cov');

% Trucate basis
U = zeros(np*2,nm); % '2' for 2D vector field
for j = 1:nm
   U(:,j) = spat_mode(:,j+id1-1).*sqrt(eval_cov(j+id1-1)); 
end
clear spat_mode eval_cov
model.sigma.base_phi = reshape(U,[MX,2,nm]);

% Derive variance tensor
a_xx_yy = sum(U.^2, 2); % diagonal components
a_xy = sum(U(1:np,:).*U(np+1:end,:), 2); % cross component
model.sigma.A_over_dt = reshape([a_xx_yy; a_xy], [MX, 3]); clear a_xx_yy a_xy

end