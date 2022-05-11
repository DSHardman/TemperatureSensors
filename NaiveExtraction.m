dataobj = l_osc;

% Solely taking fixed indices of sampled data: no prior filtering

extractedinp = zeros(dataobj.n, 16*3);
extractedout = [dataobj.positions dataobj.temps];

for i = 1:dataobj.n
    for j = 1:16
        % before touch, just after touch, just before release
        extractedinp(i,(j-1)*3+1:j*3) = dataobj.responses(i,[40 70 250],j);
    end
end