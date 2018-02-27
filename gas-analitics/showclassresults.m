function concordance = showclassresults(aaa)
concordance = 0;

if 0
    fg = 2;
    sg = 1;
else
    fg = 5;
    sg = 4;
end
for M =1:length(aaa.datavar)  %%% might break if datavar is ever not a vector. 
    m = 1:length(aaa.datavar.labels_names);%1:12;
    figure(M)
    t = logical(aaa.trials.metrics(M).conffig{1, fg}');
    a = logical(aaa.trials.metrics(M).conffig{1, sg}');
    for i =1:size(t,1)
        k(i) = m(t(i,:)); 
        j(i) = m(a(i,:));
        l(i) = 0;
        if k(i)==j(i)
            l(i) = 1;
        end
    end
    plot(k)
    hold on
    plot(j)
    clear t a k j 
end
concordance = l;