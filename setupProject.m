function setupProject()
%SETUPPROJECT Add source folders to the MATLAB path and create result folders.
%
% Run this once after opening/cloning the repository. Example scripts also call
% it themselves so they remain reproducible when launched directly.

    projectRoot = fileparts(mfilename('fullpath'));
    addpath(genpath(fullfile(projectRoot, 'src')));

    resultFolders = { ...
        fullfile(projectRoot,'results','nominal'), ...
        fullfile(projectRoot,'results','controllers'), ...
        fullfile(projectRoot,'results','robustness')};
    for k = 1:numel(resultFolders)
        if ~isfolder(resultFolders{k})
            mkdir(resultFolders{k});
        end
    end
end
