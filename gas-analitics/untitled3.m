%%%timing script
figure
for i =1:size(aaa.trials,2)
[maxa, maxi] = filterouts(aaa.trials(i))
hold on
end
hold off