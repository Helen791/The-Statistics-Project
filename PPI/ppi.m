

%% First-level analysis was performed using GUI SPM without coding. It included extraction of VOI using the region of interest (using the mask for S1 region), creation of PPI-variable and defining PPI GLM. 

%% Second-level analysis

%% Concatenation of PPI

% Specify the base directory where PPI files are located
cd ('C:\Users\snile\Downloads\project');
dir = 'C:\Users\snile\Downloads\project';

% List of subjects (the original numeration of subjects was restored in order to perform VOI extraction
subjects = {'sub-001','sub-002','sub-006','sub-007','sub-008','sub-010','sub-012','sub-013','sub-014','sub-016'};

% Loop over each subject
for sub_index = 1:length(subjects)
    sub_id = subjects{sub_index};
    
    concat_PPI_ppi = [];
    concat_PPI_Y = [];
    concat_PPI_P = [];

    % Load PPI data
    ppi_name = 'PPI_BA2_1x(Perc-Imag).mat';
    ppi_path = fullfile(dir, sub_id, '1st_level_good_bad_Imag', ppi_name);
    load(ppi_path, 'PPI');
    ppi_ppi = PPI.ppi;
    ppi_Y = PPI.Y;
    ppi_P = PPI.P;

    % Concatenate PPI data
    concat_PPI_ppi = [concat_PPI_ppi; ppi_ppi];
    concat_PPI_Y = [concat_PPI_Y; ppi_Y];
    concat_PPI_P = [concat_PPI_P; ppi_P];
    
    % Save concatenated PPI data

 %directory = fullfile(dir);

    save(fullfile(dir, 'Concatenated_PPI.mat'), 'concat_PPI_ppi', 'concat_PPI_Y', 'concat_PPI_P');
end

%% Testing for the significance on the group level - one-sample t-test (batch-script)

spm fmri;

% Start the SPM job manager
spm_jobman('initcfg');

% Create a new batch job structure
matlabbatch = {};

% Choose a directory for the analysis
matlabbatch{1}.spm.stats.factorial_design.dir = {'C:\Users\snile\Downloads\project'};
%%
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
                                                          'C:\Users\snile\Downloads\project\sub-001\PPI\con_0001.nii,1'
                                                          'C:\Users\snile\Downloads\project\sub-002\PPI\con_0001.nii,1'
                                                          'C:\Users\snile\Downloads\project\sub-006\PPI\con_0001.nii,1'
                                                          'C:\Users\snile\Downloads\project\sub-007\PPI\con_0001.nii,1'
                                                          'C:\Users\snile\Downloads\project\sub-008\PPI\con_0001.nii,1'
                                                          'C:\Users\snile\Downloads\project\sub-010\PPI\con_0001.nii,1'
                                                          'C:\Users\snile\Downloads\project\sub-012\PPI\con_0001.nii,1'
                                                          'C:\Users\snile\Downloads\project\sub-013\PPI\con_0001.nii,1'
                                                          'C:\Users\snile\Downloads\project\sub-014\PPI\con_0001.nii,1'
                                                          'C:\Users\snile\Downloads\project\sub-016\PPI\con_0001.nii,1'
                                                          };
%%
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'PPI-Group_Interaction';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;




% Run the batch job
spm_jobman('run', matlabbatch);




