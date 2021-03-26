function wave = spectrum_init(MX, dX) 
% Calculate 1D wavenumbers from 2D regular mesh.
%
% Copyright (c) 2016 Valentin Resseguier.
% 
% Modified by Long Li - 2020/12/01.
%

if any(mod(MX,2)~=0)
    error('Number of grid points by axis need to be even');
end
PX = MX/2;

% 2D wavevector
kx = [0:(PX(1)-1) 0 (1-PX(1)):-1]; 
ky = [0:(PX(2)-1) 0 (1-PX(2)):-1];
kx = (2*pi/dX(1)/MX(1)).*kx;
ky = (2*pi/dX(2)/MX(2)).*ky;
[kx,ky] = ndgrid(kx,ky);
k2 = sqrt(kx.^2 + ky.^2);
k2(PX(1)+1,:) = inf;
k2(:,PX(2)+1) = inf;
k2 = k2(:);

% 1D wavenumber
Mk1 = min(MX);
Pk1 = Mk1/2;
dk1 = max(1./dX);
k1 = 0:(Pk1-1);
k1 = (2*pi*dk1/Mk1).*k1;

% Masks associated with the rings of iso-wavenumber
dk1 = k1(2) - k1(1);
idk = sparse( bsxfun(@le,k1,k2) );
idk = idk & sparse( bsxfun(@lt,k2,[k1(2:end) k1(end)+dk1]) );

% Output
wave = [];
wave.k1 = k1;
wave.k2 = k2;
wave.idk = idk;

end