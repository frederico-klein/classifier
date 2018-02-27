function allc = configs_d(varargin)
if nargin>0
    switch varargin{1}
        case 'optimizer'
            allc = allc_optimizer();
        case 'alsw'
            allc = alsw(varargin{2:end});
        case 'reset'
            allc = allconfigs_core(true);
    end
else
    allc = allconfigs_core(false);
end
end
function allc = allconfigs_core(reset)
persistent allc_store
if reset
   
    allc = [];
    clear allc_store
    disp('configs_d cleared')
    return
end
if isempty(allc_store)
    %% datavar
    
    allc.datavar.init = {'validationtype' 'type2all'};
    
    %starts the dataset and do the preconditioning and feature selection.
    
    allc.datavar.validationtype = 'type2all'; %'type2notrandom'; 'cluster' 'quarterset' 'type2' 'type2notrandom' 'type2all'
    
    allc.datavar.AllSubjects = [1 2 3 4];%2 %[1 2 3 4]; %%
    allc.datavar.disablesconformskel = 0;
    allc.datavar.generatenewdataset = true; %true;
    allc.datavar.datasettype = 'CAD60'; % datasettypes are 'CAD60', 'tstv2' and 'stickman'
    allc.datavar.activity_type = 'act_type'; %'act_type' or 'act'
    allc.datavar.prefilter = {'none', 15};%{'filter',10}; % 'filter', 'none', 'median?'
    allc.datavar.normrepair = false;
    allc.datavar.affinerepair = false;
    allc.datavar.affrepvel = false;
    allc.datavar.randSubjEachIteration = false; %%% must be set to false for systematic testing
    allc.datavar.extract = {'rand', 'wantvelocity','order'};
    allc.datavar.featuresall = 3;
    
    %% runpars

    allc.runpar.scene = {'or'};% {'bathroom'};% {'bathroom','bedroom','kitchen','livingroom','office'} ; %{'or'}; %{'all'};
    allc.runpar.precon = 'papb';%'oh'; % 'pap';%'pop';% 'cip';
 
    %% OS_VARS
    
    % In Windows, Mac and Unix, it expects the data to be in an external
    % harddrive, in my case Elements
    allc.osv.exthdname = 'Elements';
    allc.osv.drives_to_search = {'d', 'e', 'f', 'g', 'h'};
    
    allc.osv.path_to_data1 = 'fall_detection_datasets' ;
    allc.osv.path_to_data2 = 'TST Fall detection database ver. 2' ;
    
    %% aa-environment
    
    allc.aa.nameofcurrentrepo = 'cad-gas';
    
    allc.aa.mac.env.wheretosavestuff = '/Volumes/Elements/savesave';
    allc.aa.mac.env.homepath = ['~/matlabprogs/' allc.aa.nameofcurrentrepo];
    allc.aa.mac.env.allmatpath = '/Volumes/Elements/Dropbox/all.mat/'; %['~/Dropbox/all.mat/'];
    
    allc.aa.unix.env.wheretosavestuff = '/docs/savesave';
    allc.aa.unix.env.homepath = ['~/matlab/' allc.aa.nameofcurrentrepo];
    allc.aa.unix.env.allmatpath = ['~/Dropbox/all.mat/'];
    
    allc.aa.pc.env.wheretosavestuff = ':\savesave';
    allc.aa.pc.env.homepath = '\Documents\\GitHub\\';
    allc.aa.pc.env.allmatpath = '\Dropbox\all.mat\';
    allc.aa.pc.env.windowsdrive = 'C:\';
    allc_store = allc;
else
    allc = allc_store;
end

end