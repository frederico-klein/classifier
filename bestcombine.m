function [maxedout,act,A, actions] = bestcombine(outcomes)
%act = [];

numgas = size(outcomes.b.b,3);
%maxedout = zeros(numgas,1);
matsize = size(outcomes.b.b,1);
thisout = zeros(numgas,matsize,matsize);

if ~isempty(outcomes.hash)
    actions = {'brushing teeth','cooking (chopping)'	,'cooking (stirring)'	,'drinking water','opening pill container'	,'random','relaxing on couch','rinsing mouth with water'	,'still'	,'talking on couch'	,'talking on the phone'	,'wearing contact lenses'	,'working on computer'	,'writing on whiteboard'};
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
maxedout = max(max(thisout,[],2),[],3);
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
[maxa, ii ]= max(maxedout);
disp(['maximum accuracy ' num2str(maxa) ' % occurs when we merge:' ])
disp(actions(lact(ii)))
disp(' with:' )
disp(actions(cact(ii)))
[A, actions] = combA(outcomes.b.b,actions, lact(ii),cact(ii));