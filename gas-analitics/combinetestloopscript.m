%combineloop
%load some outcomes first!
%will fail if 

outcomes = outcomes(1);
i = 2;
method = 'winnertakesall'; %'winnertakesall'; % 'lastlayer'
disp('====================================================================================================================')
disp('====================================================================================================================')
disp('====================================================================================================================')
disp('====================================================================================================================')
for i =2:size(outcomes.b.b,2)
    [outcomes(i).b.max,outcomes(i).b.merges,outcomes(i).b.b, outcomes(i).b.actions] = bestcombine(outcomes(i-1), method);
    disp('====================================================================================================================')
    
end
