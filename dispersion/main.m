% Main program to test the off-line procedure for computation of relative
% dispersions from a set of snapshots.
%

clear all; close all; clc;

%% Inputs

datdir = '$YOUR_DATA_PATH_HERE/Data512/Vortices/POD/files'; % update dir of data
step_spot = 2; % must be an even number
Nsamples = 1e3; % number of pairs of particles

%% Fullfile model

disp('Set model')

datlen = length(dir(fullfile(datdir,'*.mat'))); % Count number of shapshots

% Read model
file1 = fullfile(datdir,'0.mat');
load(file1,'model');

% Complete model
model.datdir = datdir;
model.Nsamples = Nsamples;
model.step_spot = step_spot;
model.IDspots = 0:step_spot:datlen-1;

% Find time step according to step_out
file1 = fullfile(datdir,sprintf('%d.mat',step_spot));
load(file1,'t');
model.dt = model.advection.dt_adv*t;

disp(' ')

%% Run dispersion

disp('Compute relative dispersion')

[mdist2,dist2,traj] = dispersion(model);

disp('Done')

% Simple plot
t = model.dt.*model.IDspots;
figure, loglog(t,mdist2-mdist2(1));
