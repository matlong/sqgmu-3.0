function include_wavelab()
% To run the 'WavHypervis' model, one need to attach the 'Wavelab' package 
% on the Matlab parallel tool.
%
% Written by L. LI 2017-12-10

WavePath;

% Optional: if use parallel computing, then do the following

poolobj = gcp;

% Select the exist path of the file 'Wavelab850'
dir1 = '/Applications/MATLAB_R2020b.app/toolbox/Wavelab850'; % Update here your path

addAttachedFiles(poolobj,dir1);

end
