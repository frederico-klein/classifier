function [maxa, maxi] = filterouts(varargin)
aaa = varargin{1};
filterstep = 10;
if nargin == 1
    maxfiltersize = 300;
else
    maxfiltersize = varargin{2};
end
maxa = zeros(size(aaa.trial.allconn,2),size(aaa.trial.metrics,1));
maxi = maxa;
for j=1:size(aaa.trial.metrics,1)
    ava = zeros(size(aaa.trial.allconn,2),1,ceil(maxfiltersize/filterstep)); %%% this might break!
    for i = 1:ceil(maxfiltersize/filterstep)
        a(i) = plotconf_better(mtmodefilter(aaa.trial.metrics(j,:),i*filterstep, false),false);
        if ~isempty(a(i).val)
            ava(:,:,i) = a(i).val;
        end
    end
    [maxa(:,j), maxi(:,j)] = max(ava,[],3);
    plot(squeeze(ava)')
    hold on
end
hold off
end