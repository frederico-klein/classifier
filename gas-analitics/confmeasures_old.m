function [mmsd, measures] = confmeasures(cm)
%=======================================================
% You probably want to run analyze_outcomes like, e. g.:
%
% > [~, outcomes.b.b] = analyze_outcomes(aaa);
%
% and then run this command 
%
% > confmeasures(outcomes.b)

%%% wrapper for other types of input
if isstruct(cm)
    %%%okay will hope I am measuring outcomes
    if isfield(cm, 'b')
        for i=1:length(cm)
            for j=1:size(cm(i).b,3)
                measures(i,j) = cmeasures(cm(i).b(:,:,j));
            end
        end
    else
        error('Unexpected structure type!')
    end
elseif isa(cm,'Simvar')
    tcm = maketensor_cm(cm.metrics);
    for j=1:size(tcm,3)
        measures(j) = cmeasures(tcm(:,:,j));
    end
else
    for j=1:size(cm,3)
        measures(j) = cmeasures(cm(:,:,j));
    end
end
mmsd = mmsdg(measures);
end
function tcm = maketensor_cm(at)
%disp('Hello!')
tcm = zeros([size(at(1).val),length(at)]);
for i =1:length(at)
    tcm(:,:,i) = at(i).val;
end
end
function mmsd = mmsdg(measures)
allfields = fieldnames(measures);
mmsd(size(measures,2)) = struct;
for i = 1:length(allfields)
    if ~isstruct(measures(1,1).(allfields{i}))
        for j =1:size(measures,2)
            mmsd(j).(allfields{i}) = [];
            mmsd(j) = setfield(mmsd(j), (allfields{i}),{1},mean([measures(:,j).(allfields{i})]));
            mmsd(j) = setfield(mmsd(j), (allfields{i}),{2},max([measures(:,j).(allfields{i})]));
            mmsd(j) = setfield(mmsd(j), (allfields{i}),{3},std([measures(:,j).(allfields{i})]));
        end
    else
        for j = 1:size(measures,2) %%% this is not debuggable. if it ever breaks, rewrite.
            for k = 1:length(getfield(measures(1,1),allfields{i}))
                subfieldnames = fieldnames(getfield(measures(1,j),allfields{i},{k}));
                for m = 1:length(subfieldnames) %this might break
                    for l = 1:size(measures,1)                                                                       
                        a(l) = getfield(getfield(measures(l,j),allfields{i},{k}),subfieldnames{m});
                    end
                    mmsd(j).([allfields{i} num2str(k)]).(subfieldnames{m}) = [];
                    mmsd(j).([allfields{i} num2str(k)]) = setfield(mmsd(j).([allfields{i} num2str(k)]),(subfieldnames{m}),{1},mean(a));   
                    mmsd(j).([allfields{i} num2str(k)]) = setfield(mmsd(j).([allfields{i} num2str(k)]),(subfieldnames{m}),{2},max(a));   
                    mmsd(j).([allfields{i} num2str(k)]) = setfield(mmsd(j).([allfields{i} num2str(k)]),(subfieldnames{m}),{3},std(a));   
                end
            end
        end
    end
end

end
function measures = cmeasures(cm)
%check if cm is valid
l = size(cm,1);
if l~=size(cm,2)
    error('Confusion matrix must be square')
end

%initializes measures output
measures = struct;
measures.averageAccuracy = 0;
measures.errorRate = 0;
measures.precisionMi = 0;
measures.recallMi = 0;
measures.fscoreMi = 0;
measures.precisionM = 0;
measures.recallM = 0;
measures.fscoreM = 0;
measures.peraction(l) = struct;

pmid = 0;
pmin = 0;
rmin = 0;

for i =1:l
    tpi = cm(i,i); %this one is easy
    %tni = sum() %has 4 parts
    if i>1
        tni11 = sum(sum(cm(1:i-1,1:i-1)));
        %fn and fp have 2 parts
        fni1 = sum(cm(1:i-1,i));
        fpi1 = sum(cm(i,1:i-1));
    else
        tni11 = 0;
        fni1 = 0;
        fpi1 = 0;
    end
    if i+1<=l
        tni12 = sum(sum(cm(1:i-1,i+1:l)));
        tni21 = sum(sum(cm(i+1:l,1:i-1)));
        tni22 = sum(sum(cm(i+1:l,i+1:l)));
        fni2 = sum(cm(i+1:l,i));
        fpi2 = sum(cm(i,i+1:l));
    else
        tni12 = 0;
        tni21 = 0;
        tni22 = 0;
        fni2 = 0;
        fpi2 = 0;
    end
    tni = tni11 +tni12+tni21+tni22;
    fni = fni1 +fni2;
    fpi = fpi1+fpi2;
    
    % average accuracy
    measures.averageAccuracy = measures.averageAccuracy + (tpi+tni)/(tpi+fni+fpi+tni);
    measures.errorRate = measures.errorRate + (fpi+fni)/(tpi+fni+fpi+tni);% 1- accuracy?
    pmid = pmid + tpi; %
    pmin = pmin + tpi + fpi;
    rmin = rmin + tpi + fni;
    measures.precisionM = measures.precisionM + tpi/(tpi+fpi);
    measures.recallM = measures.recallM +tpi/(tpi+fni);
    measures.peraction(i).accuracy = (tpi+tni)/(tpi+fni+fpi+tni);
    measures.peraction(i).errorRate = (fpi+fni)/(tpi+fni+fpi+tni);
    measures.peraction(i).precision = tpi/(tpi+fpi);
    measures.peraction(i).recall = tpi/(tpi+fni);
    measures.peraction(i).fscore = fscore(1,measures.peraction(i).precision,measures.peraction(i).recall);
end
measures.averageAccuracy = measures.averageAccuracy/l;
measures.errorRate = measures.errorRate/l;
measures.precisionM = measures.precisionM/l;
measures.recallM = measures.recallM/l;
measures.precisionMi = pmid/pmin;
measures.recallMi = pmid/rmin;
measures.fscoreMi = fscore(1,measures.precisionMi,measures.recallMi);% sorry, it should be, f1 score...
measures.fscoreM = fscore(1,measures.precisionM,measures.recallM);% sorry, it should be, f1 score...
end
function f = fscore(beta, p,r)
f= (beta^2+1)*p*r/(beta^2*p+r);
if p==0&&r==0
    f = 0;
end
end

%%%%%
% 
% function [mmsd, measures] = confmeasures(cm)
% %%% wrapper for other types of input
% if isstruct(cm)
%     %%%okay will hope I am measuring outcomes
%     if isfield(cm, 'b')
%         for i=1:length(cm)
%             for j=1:size(cm(i).b,3)
%                 measures(i,j) = cmeasures(cm(i).b(:,:,j));
%             end
%         end
%     end
% else
%     for j=1:size(cm,3)
%         measures(j) = cmeasures(cm(:,:,j));
%     end
% end
% mmsd = mmsdg(measures);
% end
% function mmsd = mmsdg(measures)
% allfields = fieldnames(measures);
% mmsd = struct;
% for i = 1:length(allfields)
%     if ~isstruct(measures(1,1).(allfields{i}))
%         for j =1:size(measures,2)
%             mmsd(j).(['mean' allfields{i}]) = mean([measures(:,j).(allfields{i})]);
%             mmsd(j).(['max' allfields{i}]) = max([measures(:,j).(allfields{i})]);
%             mmsd(j).(['std' allfields{i}]) = std([measures(:,j).(allfields{i})]);
%         end
%     else
%         for j = 1:size(measures,2) %%% this is not debuggable. if it ever breaks, rewrite.
%             for k = 1:length(getfield(measures(1,1),allfields{i}))
%                 subfieldnames = fieldnames(getfield(measures(1,j),allfields{i},{k}));
%                 for m = 1:length(subfieldnames) %this might break
%                     for l = 1:size(measures,1)                                                                       
%                         a(l) = getfield(getfield(measures(l,j),allfields{i},{k}),subfieldnames{m});
%                     end
%                     mmsd(j).([allfields{i} num2str(k)]).(['mean' subfieldnames{m}]) = mean(a);
%                     mmsd(j).([allfields{i} num2str(k)]).(['max' subfieldnames{m}]) = max(a);
%                     mmsd(j).([allfields{i} num2str(k)]).(['std' subfieldnames{m}]) = std(a);
%                 end
%             end
%         end
%     end
% end
% 
% end
% function measures = cmeasures(cm)
% %check if cm is valid
% l = size(cm,1);
% if l~=size(cm,2)
%     error('Confusion matrix must be square')
% end
% 
% %initializes measures output
% measures = struct;
% measures.averageAccuracy = 0;
% measures.errorRate = 0;
% measures.precisionMi = 0;
% measures.recallMi = 0;
% measures.fscoreMi = 0;
% measures.precisionM = 0;
% measures.recallM = 0;
% measures.fscoreM = 0;
% measures.peraction(l) = struct;
% 
% pmid = 0;
% pmin = 0;
% rmin = 0;
% 
% for i =1:l
%     tpi = cm(i,i); %this one is easy
%     %tni = sum() %has 4 parts
%     if i>1
%         tni11 = sum(sum(cm(1:i-1,1:i-1)));
%         %fn and fp have 2 parts
%         fni1 = sum(cm(1:i-1,i));
%         fpi1 = sum(cm(i,1:i-1));
%     else
%         tni11 = 0;
%         fni1 = 0;
%         fpi1 = 0;
%     end
%     if i+1<=l
%         tni12 = sum(sum(cm(1:i-1,i+1:l)));
%         tni21 = sum(sum(cm(i+1:l,1:i-1)));
%         tni22 = sum(sum(cm(i+1:l,i+1:l)));
%         fni2 = sum(cm(i+1:l,i));
%         fpi2 = sum(cm(i,i+1:l));
%     else
%         tni12 = 0;
%         tni21 = 0;
%         tni22 = 0;
%         fni2 = 0;
%         fpi2 = 0;
%     end
%     tni = tni11 +tni12+tni21+tni22;
%     fni = fni1 +fni2;
%     fpi = fpi1+fpi2;
%     
%     % average accuracy
%     measures.averageAccuracy = measures.averageAccuracy + (tpi+tni)/(tpi+fni+fpi+tni);
%     measures.errorRate = measures.errorRate + (fpi+fni)/(tpi+fni+fpi+tni);% 1- accuracy?
%     pmid = pmid + tpi; %
%     pmin = pmin + tpi + fpi;
%     rmin = rmin + tpi + fni;
%     measures.precisionM = measures.precisionM + tpi/(tpi+fpi);
%     measures.recallM = measures.recallM +tpi/(tpi+fni);
%     measures.peraction(i).accuracy = (tpi+tni)/(tpi+fni+fpi+tni);
%     measures.peraction(i).errorRate = (fpi+fni)/(tpi+fni+fpi+tni);
%     measures.peraction(i).precision = tpi/(tpi+fpi);
%     measures.peraction(i).recall = tpi/(tpi+fni);
%     measures.peraction(i).fscore = fscore(1,measures.peraction(i).precision,measures.peraction(i).recall);
% end
% measures.averageAccuracy = measures.averageAccuracy/l;
% measures.errorRate = measures.errorRate/l;
% measures.precisionM = measures.precisionM/l;
% measures.recallM = measures.recallM/l;
% measures.precisionMi = pmid/pmin;
% measures.recallMi = pmid/rmin;
% measures.fscoreMi = fscore(1,measures.precisionMi,measures.recallMi);% sorry, it should be, f1 score...
% measures.fscoreM = fscore(1,measures.precisionM,measures.recallM);% sorry, it should be, f1 score...
% end
% function f = fscore(beta, p,r)
% f= (beta^2+1)*p*r/(beta^2*p+r);
% if p==0&&r==0
%     f = 0;
% end
% end
% 
% %%%%%

