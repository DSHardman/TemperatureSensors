%% Training everything together: both inputs and outputs

%% Small

dataobj = s_osc;
extractedout = [dataobj.positions dataobj.temps];

% Try 3 naive inputs
s_3 = extractandtrain(dataobj, 3, extractedout, 's');

% Try 6 naive inputs
s_6 = extractandtrain(dataobj, 6, extractedout, 's');

% Try 12 naive inputs
s_12 = extractandtrain(dataobj, 12, extractedout, 's');

% Try 3 TVD inputs
s_tvd = extractandtrain(dataobj, 0, extractedout, 's');

%% Medium

dataobj = m_osc;
extractedout = [dataobj.positions dataobj.temps];

% Try 3 naive inputs
m_3 = extractandtrain(dataobj, 3, extractedout, 'm');

% Try 6 naive inputs
m_6 = extractandtrain(dataobj, 6, extractedout, 'm');

% Try 12 naive inputs
m_12 = extractandtrain(dataobj, 12, extractedout, 'm');

% Try 3 TVD inputs
m_tvd = extractandtrain(dataobj, 0, extractedout, 'm');

%% Large

dataobj = l_osc;
extractedout = [dataobj.positions dataobj.temps];

% Try 3 naive inputs
l_3 = extractandtrain(dataobj, 3, extractedout, 'l');

% Try 6 naive inputs
l_6 = extractandtrain(dataobj, 6, extractedout, 'l');

% Try 12 naive inputs
l_12 = extractandtrain(dataobj, 12, extractedout, 'l');

% Try 3 TVD inputs
l_tvd = extractandtrain(dataobj, 0, extractedout, 'l');

function errormat = extractandtrain(dataobj, n, extractedout, sens_size)
    errormat = zeros(4, 3);
    
    samples = n;
    switch samples
        case 3
            inds = [40 70 250];
        case 6
            inds = [40 54 80 250 263 290];
        case 12
            inds = [50:2:60 260:4:280];
        case 0
            % tvd
        otherwise
            % do nothing
    end

    if samples ~= 0
        extractedinp = zeros(dataobj.n, 16*samples);
        for i = 1:dataobj.n
            for j = 1:16
                extractedinp(i,(j-1)*samples+1:j*samples) = dataobj.responses(i,inds,j);
            end
        end
    else
        extractedinp = dataobj.tvdresponses;
    end
    
    % test 4 different architectures
    errormat(1,:) = sensorTrain(extractedinp, extractedout, sens_size,...
        'b', [1 1 1], [100], 1, [0.8 0.1 0.1], 0);

    errormat(2,:) = sensorTrain(extractedinp, extractedout, sens_size,...
        'b', [1 1 1], [100 50], 1, [0.8 0.1 0.1], 0);

    errormat(3,:) = sensorTrain(extractedinp, extractedout, sens_size,...
        'b', [1 1 1], [200 50], 1, [0.8 0.1 0.1], 0);

    errormat(4,:) = sensorTrain(extractedinp, extractedout, sens_size,...
        'b', [1 1 1], [200 50 20], 1, [0.8 0.1 0.1], 0);
end