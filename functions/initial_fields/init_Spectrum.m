function buoy_init = init_Spectrum(model, varargin)
% function buoy_init = init_Spectrum(model [, k0, alpha])
% Generate a buoyancy field from a spectrum
%
% Arguments:
%   - model: the simulation model, see set_model.m 
%   - [optional] k0: the max wavenumber of the spectrum.
%   - [optional] alpha: an initial field of buoyancy, to adjust the
%   spectrum level.
%
% Modified by P. DERIAN 2016-11-14%
%   - added optional k0 parameter.


%% Get parameters
% from model
slope = model.init.slope_b_ini;
if nargin < 2
    slope = - 5/3;
end
odg_b = model.odg_b;
MX=model.grid.MX;
dX=model.grid.dX;
PX=MX/2;

%% Wave vector
if any( mod(MX,2)~=0)
    error('the number of grid points by axis need to be even');
end
kxref=1/(model.grid.MX(1))*[ 0:(PX(1)-1) 0 (1-PX(1)):-1];
kyref=1/(model.grid.MX(2))*[ 0:(PX(2)-1) 0 (1-PX(2)):-1];
kxref=2*pi/model.grid.dX(1)*kxref;
kyref=2*pi/model.grid.dX(2)*kyref;
[kxref,kyref]=ndgrid(kxref,kyref);
kref=sqrt(kxref.^2+kyref.^2);
kref(PX(1)+1,:)=inf;
kref(:,PX(2)+1)=inf;
kref=kref(:);

%% Wave number
M_kappa=min(MX);
P_kappa= M_kappa/2;
d_kappa = max(1./dX);
kidx=1/(M_kappa)* (0:(P_kappa-1)) ;
kidx=2*pi*d_kappa*kidx;

%% 1D Spectrum

% Largest wave number (optionally set by user)
% [TODO] enable as a ratio k0/kmin?
if ~isempty(varargin)
    % check it makes sense
    if numel(varargin)>2 || ~isscalar(varargin{1})
        % error
        error('sqgmu:init_Spectrum():InputError', 'expecting at most 2 optional parameters, first one (k0) is to be a scalar.');
    end
    k0 = varargin{1};
    k_inf = kidx(end);
else
   % use largest available 
   k0 = kidx(1);
   % Smallest wave number
    k_inf = kidx(end)/2;
end

% Spectrum
Gamma_buoy = kidx(2:end) .^ slope ;

% Band-pass filter
idx1 = (kidx(2:end) <= k0);
idx3 = (kidx(2:end) > k_inf);
idx2 = ~ (idx1 | idx3);
unit_approx = fct_unity_approx_(sum(idx2));
Gamma_buoy(idx1 | idx3)=0;
Gamma_buoy(idx2) = Gamma_buoy(idx2) .* unit_approx;

nrj_b = ( 1/prod(model.grid.MX) )^2 * sum(Gamma_buoy);
% The come from the discrete form of parseval theorem and from the
% spatial averaging
Gamma_buoy = Gamma_buoy * (odg_b)^2 / nrj_b;
% [TODO] clean
if numel(varargin)>1 && numel(varargin)<3
    alpha = varargin{2};
    Gamma_buoy = Gamma_buoy.*alpha;
end



%% 2D Fourier transform modulus

% From omnidirectional spectrum to Fourier tranform square modulus
% Division by k^(d-1) in dimension d
f_buoy = Gamma_buoy ./ ( kidx(2:end)) ;
% From square modulus to modulus
f_buoy = sqrt( f_buoy );
 % Wave number step / (2 pi) to gives the step of integration
d_kappa = 1/(2*pi) * ( kidx(2)-kidx(1) ) ;
% Influence of the discretisation
f_buoy = f_buoy * 1/ sqrt(prod(MX.*dX)*d_kappa); 

% From 1D function to 2D function
f_buoy = interp1(kidx,[0 f_buoy],kref);

% Cleaning
f_buoy(kref<=k0)=0;
f_buoy(kref>k_inf)=0;
f_buoy=reshape(f_buoy,MX);

% Antialiasing
f_buoy(PX(1)+1,:)=0;
f_buoy(:,PX(2)+1)=0;

% Influence of the complex brownian variance
f_buoy = 1/sqrt(prod(MX))*f_buoy;

%% Sampling
noise = fft2(randn(model.grid.MX));
fft_buoy = bsxfun(@times,f_buoy,noise);
buoy_init = real(ifft2(fft_buoy));
end

function t = fct_unity_approx_(N_t)
% [TODO] fix different cases
%Approximation of unity

sslop=2;
t=ones(1,N_t);
t(end-sslop+1:end)=(-tanh(-3 + 6/(sslop-1)*(0:(sslop-1)) ) +1)/2;

% sslop=8;
% t=ones(1,N_t);
% t(1:sslop)=(tanh(-3 + 6/(sslop-1)*(0:(sslop-1)) )+1)/2;
% t(end-sslop+1:end)=(-tanh(-3 + 6/(sslop-1)*(0:(sslop-1)) ) +1)/2;

end

    