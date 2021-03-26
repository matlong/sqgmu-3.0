function psd = spectrum_out(wave, ft)
% Calculate the power spectral density (PSD) of 'ft'. 
%
% Copyright (c) 2016 Valentin Resseguier.
% 
% Modified by Long Li - 2020/12/01.
%

% Get dimension
MX = size(ft(:,:,1));
PX = MX./2;

% Square modulus of FFT
ft = abs(ft).^2; % scalar field
if numel(size(ft))>2 % vector field
    ft = sum(ft,3);
end

% Remove aliasing
ft(PX(1),:) = 0.;
ft(:,PX(2)) = 0.;

% Integration over the rings of iso wave number
psd = wave.idk'*ft(:);

% Division by prod(MX) because of the Parseval theorem for FFT;
% Division by prod(MX) again for the integration of spectrum over the 
% wavenumber yields the energy of the variable averaged 
% (not just integrated) over the space.
psd = psd./(prod(MX)^2);

% Division by the wavenumber step
dk1 = wave.k1(2) - wave.k1(1);
psd = psd./(dk1/2);

end