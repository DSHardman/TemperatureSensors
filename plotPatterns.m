dataobj = l_cross1_3;

samples = 12;

patterninp = zeros(dataobj.n, 16*samples);
patterntarget = [dataobj.positions dataobj.temps];

for i = 1:dataobj.n
    for j = 1:16
        patterninp(i,(j-1)*samples+1:j*samples) = dataobj.responses(i,[50:2:60 260:4:280],j);

        % Try TVD Singles
        %[x(1,:,1), ~] = pwc_tvdrobust(dataobj.responses(i,:,j), 15, 0);
        %patterninp(i,j) = (2*mean(x(70:250)) - x(1) - x(end))/(x(1)+x(end));
    end
end

patterninp = (patterninp-mean(extractedinp))./std(extractedinp);
patternpred = predict(net, patterninp);

patternpred(:,1) = patternpred(:,1).*50;
patternpred(:,2) = patternpred(:,2).*50;
% patternpred(:,3) = patternpred(:,3).*3 + 1;
% patternpred(:,4) = patternpred(:,4).*80 + 20;

figure();
scatter(patternpred(:,1), patternpred(:,2), 'filled');
hold on
scatter(patterntarget(:,1), patterntarget(:,2), 'filled');

quiver(patterntarget(:,1), patterntarget(:,2),...
    patternpred(:,1)-patterntarget(:,1), patternpred(:,2)-patterntarget(:,2), 'off', 'color', 'k');