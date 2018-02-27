function [maxedout,act,A, actions] = bestcombine(outcomes, method)
%act = [];
%method = 'winnertakesall'; % 'lastlayer'
numgas = size(outcomes.b.b,3);
%maxedout = zeros(numgas,1);
matsize = size(outcomes.b.b,1);
thisout = zeros(numgas,matsize,matsize);

if ~isempty(outcomes.hash)
    %actions = {'brushing teeth','cooking (chopping)'	,'cooking (stirring)'	,'drinking water','opening pill container'	,'random','relaxing on couch','rinsing mouth with water'	,'still'	,'talking on couch'	,'talking on the phone'	,'wearing contact lenses'	,'working on computer'	,'writing on whiteboard'};
    actions = {'brushing teeth','cooking (chopping)'	,'cooking (stirring)'	,'drinking water','opening pill container'	,'relaxing on couch','rinsing mouth with water'	,'talking on couch'	,'talking on the phone'	,'wearing contact lenses'	,'working on computer'	,'writing on whiteboard'};

    %actions = num2cell(1:matsize);
elseif isfield(outcomes.b, 'actions')
    actions = outcomes.b.actions;
end

for j = 1:matsize
    for i =1:matsize
        if i==j
            break
        end
            [thisA, ~] = combA(outcomes.b.b, actions,i,j);
            thisoutcomes.b = thisA;
            thisout(:,i,j) = analyze_outcomes(thisoutcomes);
    end
end
[maxedout,whichlayer] = max(max(thisout,[],2),[],3);
%disp(whichlayer)
for i =1:numgas
    %[lact(i), cact(i)] = find(squeeze(thisout(i,:,:) == maxedout(i)));
    [aaa, bbb] = find(squeeze(thisout(i,:,:) == maxedout(i)));
    if length(aaa)>1
        disp('multiple merges give a same result. will use only the first one.')
        lact(i) = aaa(1);
        cact(i) = bbb(1);
    else
        lact(i) = aaa;
        cact(i) = bbb;
    end
end
act = [lact' cact'];
switch method
    case 'winnertakesall'
        [maxa, ii ]= max(maxedout);
    case 'lastlayer'
        ii = 5;
        maxa = maxedout(5);
end
disp(['using method to merge:' method ])
disp(['layer with results to be used by after merge: ' num2str(ii)])
disp(['maximum accuracy ' num2str(100*maxa) ' % occurs when we merge:' ])
disp(actions(lact(ii)))
disp(' with:' )
disp(actions(cact(ii)))
[A, actions] = combA(outcomes.b.b,actions, lact(ii),cact(ii));