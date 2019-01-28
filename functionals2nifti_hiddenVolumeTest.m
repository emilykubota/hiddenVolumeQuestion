function functionals2nifti_hiddenVolumeTest(view)
%% functionals2nifti_hiddenVolumeTest(view)
%
%  view = 'hidden' (hidden volume view)
%  view = 'window' (3D volume view)
%
% For the test dataset, this function works for the 'window' view but not
% the 'hidden' view. It seems that there is a transform that happens in the
% 'window' view in the function nifti2mrVistaAnat, but this transform
% does not take place when the 'hidden' view is initialized. 

data_dir = '~/git/hiddenVolumeQuestion/data_dir';
anat_dir = '~/git/hiddenVolumeQuestion/anatomy_dir';
flag = 0;

% First, compute the word v. face contrast map. 
% This step assumes that the GLM has already been fit. 
cd(data_dir)
vw = initHiddenInplane('GLMs');

% If the data is from the old experiment (70VOL) flag = 1
% If the data is from the new experiment (106VOL) flag = 0

if flag == 0 
    active   = [1 2]; % words
    control  = [5 6]; % faces
elseif flag == 1 
    active = [1 2]; % words 
    control = [3 4]; % faces
end 

% save the contrast map
saveName = [];
vw       = computeContrastMap2(vw, active, control, saveName);
updateGlobal(vw);

% Load the parameter map
param_path = strcat(data_dir,'/Inplane/GLMs/wordwordVadultchild.mat');
vw = loadParameterMap(vw,param_path); 
vw= refreshScreen(vw); 

%% NOTE: this is the only difference (whether the volume view is hidden)
if strcmp(view,'hidden')
    k = initHiddenVolume('GLMs');
elseif strcmp(view,'window')
    k = open3ViewWindow('GLMs');
end 
%% 

% Interpolate the parameter map from the inplane to the volume. 
%vw = checkSelectedInplane; 
k = ip2volParMap(vw, k, 0, [], 'linear'); 
k = setDisplayMode(k, 'map'); 
k = refreshScreen(k, 1); clear ip;

cd(anat_dir)
functionals2nifti(k,1,'wordwordVadultchild.nii.gz')
clx