function coarse_grain_data (param)
% Coarse-graining procedure of high-resolution (HR) data using a sharp 
% spectral (low-pass) filter.
%
% Written by Long Li - 2020/12/01.
%

disp('************************************')
disp('Coarse-graining procedure of HR data')
disp('************************************')
disp(' ')

%% Init.

% Get param.
id0 = param.id0;
id1 = param.id1;
ratio = param.ratio;
nspot = id1-id0+1;

% Make output folders (if not exist)
output = param.dir_out;
if ~ (exist(output,'dir')==7)
    mkdir(output);
end 
if param.check_spec
    output = fullfile(output,'spectrum');
    if ~ (exist(output,'dir')==7)
        mkdir(output);
    end
end

% Reading dimensions
file1 = fullfile(param.dir_in, sprintf('%d.mat',id0));
load(file1,'model');
MX_HR = model.grid.MX;
dX_HR = model.grid.dX; clear model
MX_LR = MX_HR./ratio;
dX_LR = dX_HR.*ratio;

% Low-pass bounds
cut0 = MX_LR./2 + 1;
cut1 = (MX_HR-1) - MX_HR./2 + 1;

% Wavenumbers for spectra
if param.check_spec
    wave_HR = spectrum_init(MX_HR, dX_HR);
    wave_LR = spectrum_init(MX_LR, dX_LR);
    ax(1) = wave_HR.k1(2);
    ax(2) = wave_HR.k1(end) + wave_HR.k1(2) - wave_HR.k1(1);
end

%% Coarse-grain

U = zeros([MX_LR 2 nspot]);
for i = 1:nspot
    id = id0+i-1;
    fprintf(1,sprintf('Snapshot number = %d \n',id));
    file1 = fullfile(param.dir_in,sprintf('%d.mat',id));
    % Reading snapshot and computing FFT
    load(file1,'w');
    ftw = fft2(w); clear w
    % Computing energy spectra
    if param.check_spec
        psd_HR = spectrum_out(wave_HR, ftw);
    end
    % Low-pass filtering
    ftw(cut0(1):cut1(1),:,:) = 0.;
    ftw(:,cut0(2):cut1(2),:) = 0.;
    % Subsampling
    tmp = real(ifft2(ftw)); clear ftw
    tmp = tmp(1:ratio:end,1:ratio:end,:);
    % Comparing energy spectra
    if param.check_spec
        ftw = fft2(tmp);
        psd_LR = spectrum_out(wave_LR, ftw); clear ftw
        if (i==1)
           ax(3) = min(psd_HR(2:end)); 
           ax(4) = max([max(psd_LR),max(psd_HR)]);
        end
        fig = figure(1); clf;
        set(fig,'Units','inches','Position',[2 2 4 3],'PaperPositionMode','auto');
        loglog(wave_HR.k1(2:end), psd_HR(2:end), ...
               wave_LR.k1(2:end), psd_LR(2:end),'LineWidth',1.0);
        grid minor; axis(ax); 
        legend({'HR','LR'},'Interpreter','latex','FontSize',11);
        xlabel('Wavenumbers','Interpreter','latex');
        ylabel('Power spectral density','Interpreter','latex');
        title(sprintf('Snapshot number = %d \n',id),'Interpreter','latex');
        set(gca,'FontSize',11);
        output = fullfile(param.dir_out,'spectrum',num2str(i));
        print(fig,output,sprintf('-d%s','png'),sprintf('-r%d',200));
    end
    % Collecting snapshots
    U(:,:,:,i) = tmp; clear tmp
end
disp(' ')

disp('Saving output snapshots')
save(fullfile(param.dir_out,'spot'),'U');

disp('End')
disp(' ')

end
