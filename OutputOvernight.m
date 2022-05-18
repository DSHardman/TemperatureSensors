
%% Small
dataobj = s_osc;
extractedout = [dataobj.positions dataobj.temps];

samples = 6;
inds = [40 54 80 250 263 290];
extractedinp = zeros(dataobj.n, 16*samples);
for i = 1:dataobj.n
    for j = 1:16
        extractedinp(i,(j-1)*samples+1:j*samples) = dataobj.responses(i,inds,j);
    end
end

[s_xy, s_depth, s_temp] = performreps(extractedinp, extractedout, 's');

%% Medium
dataobj = m_osc;
extractedout = [dataobj.positions dataobj.temps];

extractedinp = zeros(dataobj.n, 16*samples);
for i = 1:dataobj.n
    for j = 1:16
        extractedinp(i,(j-1)*samples+1:j*samples) = dataobj.responses(i,inds,j);
    end
end

[m_xy, m_depth, m_temp] = performreps(extractedinp, extractedout, 'm');

%% Large
dataobj = l_osc;
extractedout = [dataobj.positions dataobj.temps];

extractedinp = zeros(dataobj.n, 16*samples);
for i = 1:dataobj.n
    for j = 1:16
        extractedinp(i,(j-1)*samples+1:j*samples) = dataobj.responses(i,inds,j);
    end
end

[l_xy, l_depth, l_temp] = performreps(extractedinp, extractedout, 'l');


%% Underlying function
function [rep_xy, rep_depth, rep_temp] = performreps(extractedinp, extractedout, sens_size)
    rep_xy = zeros(5,2);
    rep_depth = zeros(5,2);
    rep_temp = zeros(5,2);

    for i = 1:5
        [~, ~, means] = sensorTrain(extractedinp, extractedout, sens_size,...
            'b', [1 0 0], [200 50 20], 1, [0.8 0.1 0.1], 0);
        rep_xy(i,1) = means(1);
        [~, ~, means] = sensorTrain(extractedinp, extractedout, sens_size,...
            'b', [0 1 0], [200 50 20], 1, [0.8 0.1 0.1], 0);
        rep_depth(i,1) = means(1);
        [~, ~, means] = sensorTrain(extractedinp, extractedout, sens_size,...
            'b', [0 0 1], [200 50 20], 1, [0.8 0.1 0.1], 0);
        rep_temp(i,1) = means(1);

        [~, ~, means] = sensorTrain(extractedinp, extractedout, sens_size,...
            'b', [1 1 1], [200 50 20], 1, [0.8 0.1 0.1], 0);
        rep_xy(i,2) = means(1);
        rep_depth(i,2) = means(2);
        rep_temp(i,2) = means(3);
    end
end