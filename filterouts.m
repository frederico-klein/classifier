function [maxa, maxi, myline] = filterouts(varargin)
aaatrial = varargin{1};
filterstep = 10;
if nargin == 1
    maxfiltersize = 300;
else
    maxfiltersize = varargin{2};
end
maxa = zeros(size(aaatrial.allconn,2),size(aaatrial.metrics,1));
maxi = maxa;
for j=1:size(aaatrial.metrics,1)
    ava = zeros(size(aaatrial.allconn,2),1,ceil(maxfiltersize/filterstep)); %%% this might break!
    for i = 1:ceil(maxfiltersize/filterstep)
        a(i) = plotconf_better(mtmodefilter(aaatrial.metrics(j,:),i*filterstep, false),false);
        if ~isempty(a(i).val)
            ava(:,:,i) = a(i).val;
        end
    end
    [maxa(:,j), maxi(:,j)] = max(ava,[],3);
    myline = squeeze(ava)';
    plot(myline)
    hold on
end
hold off
end