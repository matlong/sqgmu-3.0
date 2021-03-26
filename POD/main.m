% Main program to perform the proper orthogonal decomposition (POD) of a
% set of 2D velocity snapshots. These snapshots are provided by a priori
% coarse-grained procedure of the high-resolution simulation data. Adapting
% to the periodic boundary conditions and spectral method used in the SQGMU
% project, a low-pass sharp spectral filter is adopted for the
% coarse-graining procedure.
%
% Written by Long Li - 2020/12/01. 
%

clear all; close all; clc;

%% Set parameters

param = [];

% I/O directory (HR snapshots)
param.dir_in = '$YOUR_DATA_DIR_HERE/Data512/Vortices/POD/files'; % replace path of data in '$YOUR_DATA_DIR_HERE'
param.dir_out = './data/vort128';

% Ratio between HR and LR
param.ratio = 4; % eg. 4 in the case from 512x512 to 128x128

% ID number of the first and last snapshot (to be coarse-grained)
param.id0 = 700; % This is for test case 'Vortice'
param.id1 = 1440; 
% param.id0 = 200; % This is for test case 'Spectral'
% param.id1 = 700; 

% Optional checkings
param.check_spec = 0; % energy spectra of snapshots
param.check_mode = 1; % orthogomality of spatial modes

disp(param)

%% Coarse-grianing procedure of high-resolution data

coarse_grain_data(param);

%% Proper orthogonal decomposition (POD)

POD(param);