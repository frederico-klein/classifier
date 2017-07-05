function measures = confmeasures(cm)
%check if cm is valid
l = size(cm,1);
if l~=size(cm,2)
    error('Confusion matrix must be square')
end

%initializes measures output
measures = struct;
measures.averageAccuracy = 0;
measures.errorRate = 0;
measures.precisionMi = 0;
measures.recallMi = 0;
measures.fscoreMi = 0;
measures.precisionM = 0;
measures.recallM = 0;
measures.fscoreM = 0;
measures.peraction(l) = struct; 

pmid = 0;
pmin = 0;
rmin = 0;

for i =1:l
    tpi = cm(i,i); %this one is easy
    %tni = sum() %has 4 parts
    if i>1
        tni11 = sum(sum(cm(1:i-1,1:i-1)));
        %fn and fp have 2 parts
        fni1 = sum(cm(1:i-1,i));
        fpi1 = sum(cm(i,1:i-1));
    else
        tni11 = 0;
        fni1 = 0;
        fpi1 = 0;
    end
    if i+1<=l
        tni12 = sum(sum(cm(1:i-1,i+1:l)));
        tni21 = sum(sum(cm(i+1:l,1:i-1)));
        tni22 = sum(sum(cm(i+1:l,i+1:l)));
        fni2 = sum(cm(i+1:l,i));
        fpi2 = sum(cm(i,i+1:l));
    else
        tni12 = 0;
        tni21 = 0;
        tni22 = 0;
        fni2 = 0;
        fpi2 = 0;
    end
    tni = tni11 +tni12+tni21+tni22;
    fni = fni1 +fni2;
    fpi = fpi1+fpi2;
    
    % average accuracy
    measures.averageAccuracy = measures.averageAccuracy + (tpi+tni)/(tpi+fni+fpi+tni);
    measures.errorRate = measures.errorRate + (fpi+fni)/(tpi+fni+fpi+tni);% 1- accuracy?
    pmid = pmid + tpi; % 
    pmin = pmin + tpi + fpi;
    rmin = rmin + tpi + fni;
    measures.precisionM = measures.precisionM + tpi/(tpi+fpi);
    measures.recallM = measures.recallM +tpi/(tpi+fni);
    measures.peraction(i).accuracy = (tpi+tni)/(tpi+fni+fpi+tni);
    measures.peraction(i).errorRate = (fpi+fni)/(tpi+fni+fpi+tni);
    measures.peraction(i).precision = tpi/(tpi+fpi);
    measures.peraction(i).recall = tpi/(tpi+fni);
    measures.peraction(i).fscore = fscore(1,measures.peraction(i).precision,measures.peraction(i).recall);
end
measures.averageAccuracy = measures.averageAccuracy/l;
measures.errorRate = measures.errorRate/l;
measures.precisionM = measures.precisionM/l;
measures.recallM = measures.recallM/l;
measures.precisionMi = pmid/pmin;
measures.recallMi = pmid/rmin;
measures.fscoreMi = fscore(1,measures.precisionMi,measures.recallMi);% sorry, it should be, f1 score...
measures.fscoreM = fscore(1,measures.precisionM,measures.recallM);% sorry, it should be, f1 score...
end
function f = fscore(beta, p,r)
f= (beta^2+1)*p*r/(beta^2*p+r);
end