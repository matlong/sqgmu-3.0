function X = traj_part_EM (model, Xold, t)
% Estimate the particle trajectory using Euler-Maruyama scheme for
% stochastic flow.
%

x = model.grid.x;
y = model.grid.y;
[xx,yy] = meshgrid(x,y);
dt = model.dt;

% Coordinates corresponding to the periodic domain
xtmp = mod(Xold(1,:), x(end)); 
ytmp = mod(Xold(2,:), y(end)); 

% Interpolation of velocity
load(sprintf([model.datdir filesep '%d.mat'],t),'w','sigma_dBt_over_dt'); 
u = w(:,:,1)';  v = w(:,:,2)'; % large-scale
sB1 = sigma_dBt_over_dt(:,:,1)'; % samll-scale 
sB2 = sigma_dBt_over_dt(:,:,2)'; 
clear w sigma_dBt_over_dt

% bicubic interpolation :
W = [ interp2(xx,yy,u,xtmp,ytmp,'cubic');
      interp2(xx,yy,v,xtmp,ytmp,'cubic') ];
SB = [ interp2(xx,yy,sB1,xtmp,ytmp,'cubic');
       interp2(xx,yy,sB2,xtmp,ytmp,'cubic') ];

% position of the particle at next time :   
X = Xold + (W+SB)*dt;

end