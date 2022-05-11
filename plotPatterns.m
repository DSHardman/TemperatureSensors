dataobj = l_cross4_3;

patterninp = zeros(dataobj.n, 48);
patterntarget = [dataobj.positions dataobj.temps];

for i = 1:dataobj.n
    for j = 1:16
        patterninp(i,(j-1)*3+1:j*3) = dataobj.responses(i,[40 70 250],j);
    end
end

patternpred = predict(net, (patterninp-mean(extractedinp))./std(extractedinp));

patternpred(:,1) = patternpred(:,1).*50;
patternpred(:,2) = patternpred(:,2).*50;
patternpred(:,3) = patternpred(:,3).*3 + 1;
patternpred(:,4) = patternpred(:,4).*80 + 20;