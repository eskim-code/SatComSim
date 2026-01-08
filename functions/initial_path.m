function Settings = initial_path_r10(varargin)
    Settings = []; 
     

    
    if iscell(varargin{1})
        varargin = varargin{1}; % This assumes X is passed as {X}
    end
 % psystem_config = {folder_name, sampling_time, sim_period, primary_policy, secondary_policy, ho_freq, cell_grouping_policy}; 
  
    Settings.ScenarioFolder = fullfile('../SatComSim', varargin{1});
    [~, ScenarioFolderName] = fileparts(Settings.ScenarioFolder);



    filepath = fullfile(Settings.ScenarioFolder);
    Settings.ConstellationFolder = fullfile(filepath, sprintf('sampling-%ds-%dm',...
       varargin{2}, varargin{3}));
   
    if ~exist(Settings.ConstellationFolder, 'dir')
       mkdir(Settings.ConstellationFolder);
       if ~isdeployed()
           addpath(genpath(Settings.ConstellationFolder));
       end
    else 
       addpath(genpath(Settings.ConstellationFolder));
    end


    if ~isempty(varargin{8})     
         Settings.DataFolder = fullfile(Settings.ConstellationFolder,...
             sprintf('%s_%s-handover-%dsec-%s-nbeams-%d',...
             varargin{4}, varargin{5},varargin{6}, varargin{7}, varargin{8}));
         Settings.ResultsFolder = fullfile(Settings.ConstellationFolder,...
             sprintf('%s_%s-handover-%dsec-%s-nbeams-%d',...
        varargin{4}, varargin{5}, varargin{6}, varargin{7},varargin{8}));

    else 
        Settings.DataFolder = fullfile(Settings.ConstellationFolder,...
            sprintf('%s_%s-handover-%dsec-%s',...
            varargin{4}, varargin{5},varargin{6}, varargin{7}));

        Settings.ResultsFolder = fullfile(Settings.ConstellationFolder,sprintf('%s_%s-handover-%dsec-%s',...
        varargin{4}, varargin{5}, varargin{6}, varargin{7}));
    end



    data_filepath = fullfile(Settings.DataFolder);
    Settings.DataFolder = fullfile(data_filepath, 'data'); 

    if ~exist(Settings.DataFolder, 'dir')
       mkdir(Settings.DataFolder);
       if ~isdeployed()
           addpath(genpath(Settings.DataFolder));
       end
    else 
       addpath(genpath(Settings.DataFolder));
    end

    results_filepath = fullfile(Settings.ResultsFolder);
    Settings.ResultsFolder = fullfile(results_filepath, 'results');
    if ~exist(Settings.ResultsFolder, 'dir')
       mkdir(Settings.ResultsFolder);
       if ~isdeployed()
           addpath(genpath(Settings.ResultsFolder));
       end
    else 
       addpath(genpath(Settings.ResultsFolder));
    end

end


