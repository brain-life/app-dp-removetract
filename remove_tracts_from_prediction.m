function [] = remove_tracts_from_prediction()

if ~isdeployed
    addpath(genpath('/N/u/brlife/git/encode-dp'));
    addpath(genpath('/N/u/brlife/git/vistasoft'));
    addpath(genpath('/N/u/brlife/git/jsonlab'));
end

%following is needed to tell mcc compiler that we need to include sptensor even though we
%don't reference it anywhere in the code
%# function sptensor

config = loadjson('config.json')

if isfield(config,'dtiinit')
    disp('using dtiinit aligned dwi')
    dt6 = loadjson(fullfile(config.dtiinit, 'dt6.json'))
    dwi = fullfile(config.dtiinit, dt6.files.alignedDwRaw)
end

if isfield(config,'dwi')
    disp('using dwi')
    dwi = config.dwi
end

bvecsFile = strcat(dwi(1:end-6),'bvecs');
bvalsFile = strcat(dwi(1:end-6),'bvals');    
copyfile(bvecsFile, 'dwi.bvecs');
copyfile(bvalsFile, 'dwi.bvals');

info = struct;
info.segmentation_type = 'AFQ'; % In the future we could use a more complete segmentation (more than 20 major tracts)
info.input = struct;
info.input.dwi_path = dwi;
info.input.classification_path = config.afq;
info.input.optimal = config.optimal;
info.input.profile = config.profile;
% Tracts to remove
tracts = {'ARC_L', 'SLF_L', 'ARC_R', 'SLF_R'} ;

Gen_niftis_remove_tracts(info, tracts)

end
