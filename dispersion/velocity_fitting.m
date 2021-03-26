function W = velocity_fitting (model, X, t)
% Filtting velocity field at the particle position.
%

x = model.grid.x;
y = model.grid.y;
[xx,yy] = meshgrid(x,y);

%% Coordinates corresponding to the periodic domain

xtmp = mod(X(1,:), x(end)); 
ytmp = mod(X(2,:), y(end)); 

%% Interpolation of velocity

load(sprintf([model.datdir filesep '%d.mat'],t),'w'); % velocity in ndgrid
u = w(:,:,1)';  v = w(:,:,2)'; % velocity in meshgrid

% Bicubic interpolation
W = [ interp2(xx,yy,u,xtmp,ytmp,'cubic');
      interp2(xx,yy,v,xtmp,ytmp,'cubic') ];

end
