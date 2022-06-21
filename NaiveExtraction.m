dataobj = s_osc;

% Solely taking fixed indices of sampled data: no prior filtering

% resistances = [1e6 1.6e3 5.6e6 6.18e3 2.7e6 5.1e3 630e3 2.2e3 2.7e6...
%     3.3e3 5.6e6 2.4e3 2.2e6 2.4e3 3.9e6 3.3e3];

samples = 6;

extractedinp = zeros(dataobj.n, 16*samples);
extractedout = [dataobj.positions dataobj.temps];

for i = 1:dataobj.n
    for j = 1:16
        % before touch, just after touch, just before release
        extractedinp(i,(j-1)*samples+1:j*samples) = dataobj.responses(i,[40 54 80 250 263 290],j);
        % 3: [40 70 250]
        %6: [40 54 80 250 263 290]
        % 12: [50:2:60 260:4:280]
    end
end

%extractedinp = 5./extractedinp - 1;

%     for j = 1:16
%         extractedinp(i,(j-1)*samples+1:j*samples) = extractedinp(i,(j-1)*samples+1:j*samples)./extractedinp(i,(j-1)*samples+1);
%     end
% end