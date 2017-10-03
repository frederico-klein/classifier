function combtrial = combinetrials(trials)
%% I will assume that these trials are all a part of the same classifier, that just have some funny validation strategy and represent the same classifier.
% If this is not true, the results of this function are meaningless and rubbish.
combtrial = trials(1);
fieldf = fieldnames(trials(1));

for i = 1:length(fieldf)
    if ~isstruct(combtrial.(fieldf{i}))
        combtrial.(fieldf{i}) = {combtrial.(fieldf{i})};
    end
end

if length(trials)>1
    for j = 2:length(trials)
        for i = 1:length(fieldf)
            if ~isstruct(combtrial.(fieldf{i}))
                combtrial.(fieldf{i}) = [combtrial.(fieldf{i}) {trials(j).(fieldf{i})}];
            end
        end
    end
end

ordstruc = cat(1,trials(1:length(trials)).metrics);
for j =1:5
    combtrial.metrics(j).val = sum(cat(3, ordstruc(:,j).val),3);
    combtrial.metrics(j).train = sum(cat(3, ordstruc(:,1).train),3);
    ordstruc1 = ordstruc(:,j);
    wtf = [ordstruc1.conffig];
    wth = cat(1,wtf.train);
    a = wth(:,1);
    cellula{1} = cat(2,a{:});
    b = wth(:,2);
    cellula{2} = cat(2,b{:});
    cellula{3} = wth(1,3);
    combtrial.metrics(j).conffig.train = cellula;
    wth = cat(1,wtf.val);
    a = wth(:,1);
    cellula{1} = cat(2,a{:});
    b = wth(:,2);
    cellula{2} = cat(2,b{:});
    cellula{3} = wth(1,3);
    combtrial.metrics(j).conffig.val = cellula;
end

%%%% remove cells when they are all the same. why? because i hate life and
%%%% want to spend more time doing this.

for i = 1:length(fieldf)
    allthesame = 1;
    if iscell(combtrial.(fieldf{i}))
        a = combtrial.(fieldf{i}){1};
        %if iscell(a)
            for j = 2:length(trials)
                if ~isequal(a, combtrial.(fieldf{i}){j})
                    allthesame = 0;
                end
            end
            if allthesame
                combtrial.(fieldf{i}) = a;
            end
        %end
    end
end


end
%
% ordstruc1 = ordstruc(:,1);
% wtf = [ordstruc1.conffig];
% wth = cat(1,wtf.train);
% a = wth(:,1);
% cellula{1} = cat(2,a{:});
% b = wth(:,2);
% cellula{2} = cat(2,b{:});
% cellula{3} = wth(1,3);