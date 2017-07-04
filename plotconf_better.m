function confmat = plotconf_better(mt,plotplot)
warning('Do not use this function. this was done in a hurry and it is messy.')
if size(mt,1)~=1
    error('cannot deal well with multiply dimensions. What do you want me to do?')
end
try 
    evalin('base', 'crashedalready;');    
catch
    assignin('base', 'crashedalready', false);
end
al = size(mt,2);
if isfield(mt(1).conffig, 'val')&&~isempty(mt(1).conffig.val)
    figset = cell(6*al,1);
    for i = 1:al
        figset((i*6-5):i*6) = [mt(i).conffig.val mt(i).conffig.train];
    end
else
    figset = cell(3*al,1);
    for i = 1:al
        figset((i*3-2):i*3) = mt(i).conffig.train;
    end
    
end
if plotplot
    plotconfusion(figset{:})
end
confusions.a = zeros(size(figset{1},1), size(figset{1},1),size(mt,2));
confusions.b = confusions.a;
for i=1:size(figset,1)/6
    index = (i-1)*6 +1;
    [~, confusions.a(:,:,i)] = confusion(figset{index}, figset{index+1});
    try
        [~, confusions.b(:,:,i)] = confusion(figset{index+3}, figset{index+4});
    catch
        if ~evalin('base', 'crashedalready')
        disp('oops')
        assignin('base', 'crashedalready', true);
        end
    end
end
cc.b = confusions.a;
%disp('validation')
confmat.val = analyze_outcomes(cc);
%disp('training')
try
confmat.train = analyze_outcomes(confusions);
catch
    if ~crashedalready
        disp('oops again!')
        crashedalready = true;
    end
end
end