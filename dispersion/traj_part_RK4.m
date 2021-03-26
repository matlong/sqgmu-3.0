function coord = traj_part_RK4 (model, coord_old, idt)
% Estimate the particle trajectory using 4th order Runge-Kutta scheme for
% deterministic flow.
%

step = model.step_spot;
dt = model.dt;

k1 = velocity_fitting(model, coord_old, idt); k1 = k1*dt;
k2 = velocity_fitting(model, coord_old+.5*k1, idt+step/2); k2 = k2*dt;
k3 = velocity_fitting(model, coord_old+.5*k2, idt+step/2); k3 = k3*dt;
k4 = velocity_fitting(model, coord_old+k3, idt+step); k4 = k4*dt;

coord = coord_old + (k1 + 2*k2 + 2*k3 + k4)/6;

end
