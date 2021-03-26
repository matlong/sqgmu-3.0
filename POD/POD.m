function POD (param)
% Proper orthogonal decomposition (POD) procedure of off-line data.
%
% Written by Long Li - 2020/12/01.
%

disp('***********************************************')
disp('Proper orthogonal decomposition (POD) procedure')
disp('***********************************************')
disp(' ')

%% Input

disp('Reading snapshots')
file1 = fullfile(param.dir_out, 'spot.mat');
load(file1, 'U');
[nx,ny,nc,nt] = size(U); % dim. of [x-axis, y-axis, vect-comp, time]
np = nx*ny*nc;
nm = nt; % dim. of modes

disp('Removing mean flow')
mean_flow = mean(U,4);
U = U - mean_flow;

%% POD

disp('Building temporal correlation matrix')
U = reshape(U, [np,nt]);
S = speye(np)./(2*nx*ny); % weight for KE density
C = inner_product(U, U, S); % L2-inner product associated with S
C = C./nt; % time-mean

disp('Solving eigen problem')
[V, D] = eig(C);
[eval_cov, ind_sort] = sort(diag(D), 'descend');
temp_mode = V(:,ind_sort)';
clear C D V

disp('Scaling temporal modes')
for i = 1:nm
   temp_mode(i,:) = temp_mode(i,:).*sqrt(nt*max(eval_cov(i), 0.0));
end

disp('Building spatial modes')
spat_mode = zeros(np,nm);
for j = 1:nm
   spat_mode(:,j) = (U*temp_mode(j,:)')./(nt*eval_cov(j));
end

%% Output

disp('Ploting eigenvalues')
fig = figure;
set(fig,'Units','inches','Position',[2 2 5 5],'PaperPositionMode','auto');
subplot(2,1,1);
idm = 1:floor(nm/4);
plot(idm,eval_cov(idm),'-o','LineWidth',1.0,'MarkerSize',2.5); 
grid minor; axis tight; 
ylabel('Eigenvalues','Interpreter','latex');
set(gca,'FontSize',11);
subplot(2,1,2);
RIC = cumsum(eval_cov)./sum(eval_cov);
plot(idm,RIC(idm),'-o','LineWidth',1.0,'MarkerSize',2.5); 
grid minor; axis tight; 
xlabel('Index of modes','Interpreter','latex'); 
ylabel('Energy proportion','Interpreter','latex');
set(gca,'FontSize',11);
output = fullfile(param.dir_out,'eval');
print(fig,output,sprintf('-d%s','png'),sprintf('-r%d',200));

if param.check_mode 
    disp('Checking orthonormality of spatial modes')
    approx = inner_product(spat_mode, spat_mode, S);
    figure, imagesc(approx'); colorbar; 
    title('Orthonormality of spatial modes');    
    tmp = eye(nm);
    tmp(end,end) = 0.;
    err = approx - tmp; clear approx tmp
    fprintf(1,sprintf('Max of absolute error = %d \n',max(abs(err(:)))));    
    disp('Reconstruction of original flow')
    approx = spat_mode(:,1:nm)*temp_mode(1:nm,:);
    err = U - approx; clear approx
    fprintf(1,sprintf('Max of absolute error = %d \n',max(abs(err(:)))));
end

disp('Saving EOF data')
output = fullfile(param.dir_out,'EOF_data');
save(output,'eval_cov','spat_mode','temp_mode','mean_flow','-v7.3');

disp('End')
disp(' ')

end