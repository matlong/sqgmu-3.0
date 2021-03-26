function [mdist2, dist2, traj] = dispersion (model)
% Off-line computation for the trajectories of N pairs of particles from 
% a set of snapshots, then compute the squared distances bewteen each pair
% of particles in time, finally take the expectation of squared distances
% over all the pairs.
%

% Get model infomations
x = model.grid.x;
y = model.grid.y;
dx = model.grid.dX(1);
dy = model.grid.dX(2);
Nsamples = model.Nsamples;  
IDspots = model.IDspots;
Nt = length(IDspots);

%% Samplings of initial points

eps = 2;  % index to avoid touch the boundary of domain at the beginning
x0 = x(eps:end-eps); 
y0 = y(eps:end-eps);
[xx0,yy0] = meshgrid(x0,y0);
coord0 = [xx0(:) yy0(:)]; 
rand_id0 = randperm(size(coord0,1),Nsamples); % choose randomly indices
coord_samples = coord0(rand_id0,:); % find the sampling point correspondant

% Choose randomly one of four neighbors of each sample :
for i = 1:size(coord_samples,1)
   % for each sample, construct its 4 neighbors :
   coord_samples_neighbors = [ coord_samples(i,1)-dx coord_samples(i,2); 
                               coord_samples(i,1)+dx coord_samples(i,2);
                               coord_samples(i,1) coord_samples(i,2)-dy;
                               coord_samples(i,1) coord_samples(i,2)+dy ];
   rand_pick = randi([1,4]); % random number from 1 to 4
   coord_samples_bis(i,:) = coord_samples_neighbors(rand_pick,:);
end

%% Simulation of particle trajectories along time   

coord = zeros(2,Nt,Nsamples);
coord_bis = zeros(2,Nt,Nsamples);
coord(:,1,:) = coord_samples';
coord_bis(:,1,:) = coord_samples_bis';
for i = 1:(Nt-1)
   coord(:,i+1,:) = traj_part_RK4(model,squeeze(coord(:,i,:)),IDspots(i)); 
%    coord(:,i+1,:) = traj_part_EM(model,squeeze(coord(:,i,:)),IDspots(i));
   coord_bis(:,i+1,:) = traj_part_RK4(model,squeeze(coord_bis(:,i,:)),IDspots(i));   
%    coord_bis(:,i+1,:) = traj_part_EM(model,squeeze(coord_bis(:,i,:)),IDspots(i));
   pause(0.05);        
   prcdone(i,Nt,'particle trajectories',10);
end

%% Deduce the squared distances and mean value

dist2 = squeeze( (coord(1,:,:)-coord_bis(1,:,:)).^2 ...
                +(coord(2,:,:)-coord_bis(2,:,:)).^2 );
traj(:,:,:,1) = coord; 
traj(:,:,:,2) = coord_bis;            
mdist2 = mean(dist2,2); 

end