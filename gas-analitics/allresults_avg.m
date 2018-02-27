function aalr = allresults()
places = {'bathroom','bedroom','kitchen','livingroom','office'};
aalr = '';
addpath('cad-gas','svm-knn')
metrics = {'precision','recall','accuracy'};
while(1)
    [aa, pathname] = uigetfile('*.mat','MultiSelect','on');
    if ~iscell(aa)&&length(aa)==1&&aa==0
        break
    end
    if iscell(aa)
        forend = length(aa);
        a = aa;
    else
        forend = 1;
        a{1} = aa;
    end
    for i = 1:forend
        thisplace = '';
        for j = 1:length(places)
            if strfind(a{i},places{j})
                thisplace = places{j};
                break
            end
        end
        
        %disp(thisplace)
        for ik = 1:length(metrics)
            aalr.(thisplace).(metrics{ik}) = [];
            aalr.(thisplace).data.(metrics{ik}) = [];
        end
        aalr.(thisplace).trialspecsname = erase(a{i},places{i});
        loadedfile = load([pathname a{i}]);
        
        aalr.(thisplace).cm= confmeasures(loadedfile.a);
        %%% I will remove unnecessary fields so that I can visualize this
        %%% better
        for j = 1:size(aalr.(thisplace).cm,2)
            aalr.(thisplace).ccm(j) = remove_fields_cmm(aalr.(thisplace).cm(j),{'errorRate','precisionM','recallM','fscoreM','precisionMi','recallMi','fscoreMi','accuracy','errorRate','fscore'});
        end
        acts = fieldnames(aalr.(thisplace).ccm(1)); %fieldnames shouldn't change.
        
        %%% need to stretch this array before I assign things to it, so
        aalr.(thisplace).data(size(aalr.(thisplace).ccm,2)).(metrics{1}) = [];
        
        
        for k = 1:size(aalr.(thisplace).ccm,2)
            for j = 1:length(acts)
                if ~strcmp(acts{j},'data')
                    for ik = 1:length(metrics)
                    aalr.(thisplace).data(k).(metrics{ik}) = cat(2,aalr.(thisplace).data(k).(metrics{ik}),aalr.(thisplace).ccm(k).(acts{j}).data.(metrics{ik}));
                    end
                end
            end
                    for ik = 1:length(metrics)
            aalr.(thisplace) = setfield(aalr.(thisplace),{1},(metrics{ik}),{k,:}, make4ms(aalr.(thisplace).data(k).(metrics{ik})));
            %aalr.(thisplace).recall(k,:) = make4ms(aalr.(thisplace).data(k).recall);
                    end
        end
    end
    
end

for ik = 1:length(metrics)
    aalr.(metrics{ik}) = [];
    aalr.data.(metrics{ik}) = [];
end

allplaces = fieldnames(aalr);
for i = 1:length(allplaces)
    %%%stretching
    if ~strcmp(allplaces{i},'data')&&~strcmp(allplaces{i},'precision')&&~strcmp(allplaces{i},'recall')&&~strcmp(allplaces{i},'accuracy')
        aalr.data(size(aalr.(allplaces{i}).data,2)).precision = [];
        for j = 1:size(aalr.(allplaces{i}).data,2)
            for ik = 1:length(metrics)
            aalr.data(j).(metrics{ik}) = cat(2,aalr.(allplaces{i}).data(j).precision,aalr.data(j).(metrics{ik}));
            aalr = setfield(aalr,{1},(metrics{ik}),{j,:}, make4ms(aalr.data(j).precision);

            end
        end
    end
end

aalrshow = remove_fields_cmm(aalr,{'data','cm'});
display_str(aalrshow)


end
function fa= make4ms(a)
fa(1) = mean(a);
fa(2) = std(a);
fa(3) = min(a);
fa(4) = max(a);
end
function cmm =  remove_fields_cmm(cmm,fields)
allfields = fieldnames(cmm);

if length(cmm)>1
    for i = 1:length(cmm)
        a(i) = remove_fields_cmm(cmm(i),fields);
    end
    cmm = a;
else
    
    for i =1:length(allfields)
        if isfield(cmm,allfields{i})&&isstruct(cmm.(allfields{i}))
            cmm.(allfields{i}) = remove_fields_cmm(cmm.(allfields{i}),fields);
        else
            %%% remove the general fields we dont like
            cmm = rmfieldfield(cmm,fields);
        end
    end
end
end
function cmm = rmfieldfield(cmm,fields)
for i = 1:length(fields)
    if isfield(cmm,fields{i})
        cmm = rmfield(cmm, fields{i});
    end
end
end