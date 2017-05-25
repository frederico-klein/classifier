function [A, actions] = combA(A, actions,x,y)
%put 2 actions together and reconstruct a new matrix
%list which actions were put together in a cell

%A = somematrix;
if isempty(actions)
    actions = num2cell(1:length(A));
end

%combine 1 and 4
A(x,:,:) = A(x,:,:) + A(y,:,:);
A(y,:,:) = [];

%same for columns
A(:,x,:) = A(:,x,:) + A(:,y,:);
A(:,y,:) = [];

if iscell(actions{1})
    actions{x} = {actions{x}, actions{y}};
else
    actions{x} = [actions{x}, actions{y}];
end

actions(y) = [];