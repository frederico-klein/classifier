function showclassresults(aaa)
m = 1:12;
for M =1:4  
    figure(M)
    t = logical(aaa.trials.metrics(M).conffig{1, 5}');
    for i =1:size(t,1), k(i) = m(t(i,:)); end
    a = logical(aaa.trials.metrics(M).conffig{1, 4}');
    for i =1:size(a,1), j(i) = m(a(i,:)); end
    plot(k)
    hold on
    plot(j)
    clear t a k j 
end