%% Probabilistic & Statistical Modelling (II) Final Project - DCM
% Done by: Ezgi Damla Hakbilir & Tiantian Li
% Topic: Multi-model, Multivariate Analysis of Tactile Mental Imagery in Primary Somatosensory Cortex


data_path='/Users/ttli/Dropbox/FreieU/shared_data';
spmPath='/Users/ttli/Documents/spm12';

% specify sub numbers
subNums=[1,2,6,7,8,10,12,13,14,16]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first change the paths in all SPM.mat files
for s=1:length(subNums)
    sub=subNums(s);
    if sub<10
        subFolder=['/sub-00',num2str(sub)];
    else
        subFolder=['/sub-0',num2str(sub)];
    end
    subPath=[data_path,subFolder,'/1st_level_good_bad_Imag'];
    cd(subPath)
    spm_changepath('SPM.mat','C:\Users\saraw\Desktop\BA\EXPRA2019_HIVR\Data\sub','/Users/ttli/Dropbox/FreieU/shared_data/sub-')
    spm_changepath('SPM.mat','\run0','\run-0')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%loop through subjects to extract VOI time series:

for s=1:length(subNums)
    clear matlabbatch
    sub=subNums(s);
    if sub<10
        subFolder=['/sub-00',num2str(sub)];
    else
        subFolder=['/sub-0',num2str(sub)];
    end

    % EXTRACTING TIME SERIES: BA2(S1)
    %--------------------------------------------------------------------------

    matlabbatch{1}.spm.util.voi.spmmat = cellstr(fullfile(data_path,subFolder,'1st_level_good_bad_Imag','SPM.mat'));
    matlabbatch{1}.spm.util.voi.adjust = 1;  % "effects of interest" F-contrast
    matlabbatch{1}.spm.util.voi.session = 1; % session 1
    matlabbatch{1}.spm.util.voi.name = 'BA2';
    matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
    matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = [1,2,3,4,5,6];
    matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
    matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = [44 -40 60];
    matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = 15;
    matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{1}.spm.util.voi.expression = 'i1 & i2';

    % EXTRACTING TIME SERIES: S2
    %--------------------------------------------------------------------------
    matlabbatch{2}.spm.util.voi.spmmat = cellstr(fullfile(data_path,subFolder,'1st_level_good_bad_Imag','SPM.mat'));
    matlabbatch{2}.spm.util.voi.adjust = 1;  % "effects of interest" F-contrast
    matlabbatch{2}.spm.util.voi.session = 1; % session 1
    matlabbatch{2}.spm.util.voi.name = 'S2';
    matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
    matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = [1,2,3];
    matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;
    matlabbatch{2}.spm.util.voi.roi{2}.sphere.centre = [54 -16 20];
    matlabbatch{2}.spm.util.voi.roi{2}.sphere.radius = 15;
    matlabbatch{2}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
    matlabbatch{2}.spm.util.voi.expression = 'i1 & i2';

    spm_jobman('run',matlabbatch);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% then specify all DCM models using SPM GUI (command: spm fmri)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compare all models within individuals:

for s=1:length(subNums)
    clear matlabbatch
    sub=subNums(s);
    if sub<10
        subFolder=['/sub-00',num2str(sub)];
    else
        subFolder=['/sub-0',num2str(sub)];
    end
    
    pathN=['/Users/ttli/Dropbox/FreieU/shared_data',subFolder,'/1st_level_good_bad_Imag'];
    
    pathM1=[pathN,'/DCM_all_models_m0001.mat'];
    pathM2=[pathN,'/DCM_all_models_m0002.mat'];
    pathM3=[pathN,'/DCM_all_models_m0003.mat'];
    pathM4=[pathN,'/DCM_all_models_m0004.mat'];
    pathM5=[pathN,'/DCM_all_models_m0005.mat'];
    pathM6=[pathN,'/DCM_all_models_m0006.mat'];

    matlabbatch{1}.spm.dcm.bms.inference.dir = {pathN};
    matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{1}.dcmmat = {
        pathM1
        pathM2
        pathM3
        pathM4
        pathM5
        pathM6
        };
    matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
    matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
    matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
    matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
    matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
    matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% after specifying all models for one subjects, replicate across all subs
% using batch script below:

clear matlabbatch

matlabbatch{1}.spm.dcm.spec.fmri.group.output.dir = {'/Users/ttli/Dropbox/FreieU/shared_data/analysis'};
matlabbatch{1}.spm.dcm.spec.fmri.group.output.name = 'all_models';
matlabbatch{1}.spm.dcm.spec.fmri.group.template.fulldcm = {'/Users/ttli/Dropbox/FreieU/shared_data/sub-016/1st_level_good_bad_Imag/DCM_fullModel.mat'};
matlabbatch{1}.spm.dcm.spec.fmri.group.template.altdcm = {
                                                          '/Users/ttli/Dropbox/FreieU/shared_data/sub-016/1st_level_good_bad_Imag/DCM_FirstModel.mat'
                                                          '/Users/ttli/Dropbox/FreieU/shared_data/sub-016/1st_level_good_bad_Imag/DCM_SecondModel.mat'
                                                          '/Users/ttli/Dropbox/FreieU/shared_data/sub-016/1st_level_good_bad_Imag/DCM_ThirdModel.mat'
                                                          '/Users/ttli/Dropbox/FreieU/shared_data/sub-016/1st_level_good_bad_Imag/DCM_FourthModel.mat'
                                                          '/Users/ttli/Dropbox/FreieU/shared_data/sub-016/1st_level_good_bad_Imag/DCM_FifthModel.mat'
                                                          };
%%
matlabbatch{1}.spm.dcm.spec.fmri.group.data.spmmats = {
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-001/1st_level_good_bad_Imag/SPM.mat'
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-002/1st_level_good_bad_Imag/SPM.mat'
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-006/1st_level_good_bad_Imag/SPM.mat'
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-007/1st_level_good_bad_Imag/SPM.mat'
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-008/1st_level_good_bad_Imag/SPM.mat'
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-010/1st_level_good_bad_Imag/SPM.mat'
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-012/1st_level_good_bad_Imag/SPM.mat'
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-013/1st_level_good_bad_Imag/SPM.mat'
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-014/1st_level_good_bad_Imag/SPM.mat'
                                                       '/Users/ttli/Dropbox/FreieU/shared_data/sub-016/1st_level_good_bad_Imag/SPM.mat'
                                                       };
%%
matlabbatch{1}.spm.dcm.spec.fmri.group.data.session = 1;
%%
matlabbatch{1}.spm.dcm.spec.fmri.group.data.region = {
                                                      {
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-001/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-002/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-006/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-007/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-008/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-010/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-012/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-013/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-014/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-016/1st_level_good_bad_Imag/VOI_BA2_1.mat'
                                                      }
                                                      {
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-001/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-002/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-006/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-007/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-008/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-010/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-012/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-013/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-014/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      '/Users/ttli/Dropbox/FreieU/shared_data/sub-016/1st_level_good_bad_Imag/VOI_S2_1.mat'
                                                      }
                                                      }';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimate all models acorss all subjects to get the GCM:

matlabbatch{1}.spm.dcm.estimate.dcms.gcmmat = {'/Users/ttli/Dropbox/FreieU/shared_data/analysis/GCM_all_models.mat'};
matlabbatch{1}.spm.dcm.estimate.output.separate = struct([]);
matlabbatch{1}.spm.dcm.estimate.est_type = 1;
matlabbatch{1}.spm.dcm.estimate.fmri.analysis = 'time';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify PEB and perform BMC

matlabbatch{1}.spm.dcm.peb.specify.name = 'B';
matlabbatch{1}.spm.dcm.peb.specify.model_space_mat = {'/Users/ttli/Dropbox/FreieU/shared_data/analysis/GCM_all_models.mat'};
matlabbatch{1}.spm.dcm.peb.specify.dcm.index = 1;
matlabbatch{1}.spm.dcm.peb.specify.cov.design_mtx.cov_design = [1
                                                                1
                                                                1
                                                                1
                                                                1
                                                                1
                                                                1
                                                                1
                                                                1
                                                                1];
matlabbatch{1}.spm.dcm.peb.specify.cov.design_mtx.name = {'Mean'};
matlabbatch{1}.spm.dcm.peb.specify.fields.custom = {'B'};
matlabbatch{1}.spm.dcm.peb.specify.priors_between.components = 'All';
matlabbatch{1}.spm.dcm.peb.specify.priors_between.ratio = 16;
matlabbatch{1}.spm.dcm.peb.specify.priors_between.expectation = 0;
matlabbatch{1}.spm.dcm.peb.specify.priors_between.var = 0;
matlabbatch{1}.spm.dcm.peb.specify.priors_glm.group_ratio = 1;
matlabbatch{1}.spm.dcm.peb.specify.estimation.maxit = 256;
matlabbatch{1}.spm.dcm.peb.specify.show_review = 0;





