
%% Small
% dataobj = s_osc;
% extractedout = [dataobj.positions dataobj.temps];
% 
samples = 6;
inds = [40 54 80   250 263 290 295];
% inds = [30 40 45 50 55 60 65 70 80 240 245 250 255 260 265 275 285 295];
% extractedinp = zeros(dataobj.n, 16*samples);
% for i = 1:dataobj.n
%     for j = 1:16
%         extractedinp(i,(j-1)*samples+1:j*samples) = dataobj.responses(i,inds,j);
%     end
% end
% 
% [s_xy, s_depth, s_temp] = performreps(extractedinp, extractedout, 's');

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

%     Only use greater than 2.5mm depths
    %locs = find(extractedout(:,3)>2.5);

    %locs = randperm(4500, 2260);
%     extractedinp = extractedinp(locs,:);
%     extractedout = extractedout(locs,:);

    rep_xy = zeros(5,3);
    rep_depth = zeros(5,3);
    rep_temp = zeros(5,3);

    for i = 1:5
        [~, ~, means, ~, ~, ~, net] = sensorTrain(extractedinp, extractedout, sens_size,...
            's', [1 1 1], [200 50 20], 1, [0.8 0.1 0.1], 0);
        rep_xy(i,1) = means(1);
        rep_depth(i,1) = means(2);
        rep_temp(i,1) = means(3);
        save("eighteenall_net_s_"+string(i)+".mat", "net");

        [~, ~, means, ~, ~, ~, net] = sensorTrain(extractedinp, extractedout, sens_size,...
            't', [1 1 1], [200 50 20], 1, [0.8 0.1 0.1], 0);
        rep_xy(i,2) = means(1);
        rep_depth(i,2) = means(2);
        rep_temp(i,2) = means(3);
        save("eighteenall_net_t_"+string(i)+".mat", "net");

        [~, ~, means, ~, ~, ~, net] = sensorTrain(extractedinp, extractedout, sens_size,...
            'b', [1 1 1], [200 50 20], 1, [0.8 0.1 0.1], 0);
        rep_xy(i,3) = means(1);
        rep_depth(i,3) = means(2);
        rep_temp(i,3) = means(3);
        save("eighteenall_net_b_"+string(i)+".mat", "net");
    end
end