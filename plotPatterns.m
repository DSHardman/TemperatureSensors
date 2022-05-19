dataobj = l_circ4_1;

samples = 6;

patterninp = zeros(dataobj.n, 16*samples);
patterntarget = [dataobj.positions dataobj.temps];

for i = 1:dataobj.n
    for j = 1:16
        patterninp(i,(j-1)*samples+1:j*samples) = dataobj.responses(i,[40 54 80 250 263 290],j);

        % Try TVD Singles
        %[x(1,:,1), ~] = pwc_tvdrobust(dataobj.responses(i,:,j), 15, 0);
        %patterninp(i,j) = (2*mean(x(70:250)) - x(1) - x(end))/(x(1)+x(end));
    end
end

patterninp = (patterninp-mean(extractedinp))./std(extractedinp);

%% this section if only strain input
temporary_inp = zeros(size(patterninp,1), samples*8);
for i = 1:8
    temporary_inp(:,(i-1)*samples+1:i*samples) = patterninp(:,(2*i-1)*samples+1:(2*i)*samples);
end
patterninp = temporary_inp;

%%
patternpred = predict(net, patterninp);

patternpred(:,1) = patternpred(:,1).*50;
patternpred(:,2) = patternpred(:,2).*50;
% patternpred(:,3) = patternpred(:,3).*3 + 1;
% patternpred(:,4) = patternpred(:,4).*80 + 20;

errors = patternpred(:,1:2) - patterntarget(:,1:2);
discrep = double(sum(rssq(errors).'));

figure();
line([0 50 50 0 0], [0 0 50 50 0], 'color', 'k')
hold on
scatter(patternpred(:,1), patternpred(:,2), 'filled');
scatter(patterntarget(:,1), patterntarget(:,2), 'filled');

quiver(patterntarget(:,1), patterntarget(:,2),...
    patternpred(:,1)-patterntarget(:,1), patternpred(:,2)-patterntarget(:,2), 'off', 'color', 'k');