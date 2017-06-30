function [maxa, maxi] = filterouts(varargin)
aaa = varargin{1};
if nargin == 1
    maxfiltersize = 300;
else
    maxfiltersize = varargin{2};
end

ava = zeros(5,1,maxfiltersize);
for i = 1:maxfiltersize
    a(i) = plotconf_better(mtmodefilter(aaa.trial.metrics,i, false),false);
    if ~isempty(a(i).val)
        ava(:,:,i) = a(i).val;
    end
end
[maxa, maxi] = max(ava,[],3);
plot(squeeze(ava)')
end