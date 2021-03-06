%% Localization error vs depth
figure();
mov = 100; % num used for moving mean and std

color1 = 1/255*[27 158 119];
color2 = 1/255*[217 95 2];

% For legend order
plot(nan, nan, 'color', color1, 'linewidth', 2);
hold on
plot(nan, nan, 'color', color2, 'linewidth', 2);

load('Training/6inp_3layer_allin_allout_training/s_output.mat');
errors = abs(pred-target);
localerrors = rssq(errors(:,1:2).');

[sorteddepths,ind] = sort(target(:,3));

curve1 = movmean(localerrors(ind)./mean(localerrors), mov) + movstd(localerrors(ind)./mean(localerrors), mov);
curve2 = movmean(localerrors(ind)./mean(localerrors), mov) - movstd(localerrors(ind)./mean(localerrors), mov);
x2 = [sorteddepths.', fliplr(sorteddepths.')];
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, color1, 'edgecolor', 'none', 'facealpha', 0.5);

plot(sorteddepths, movmean(localerrors(ind)./mean(localerrors), mov), 'linewidth', 2, 'color', color1);

load('Training/6inp_3layer_allin_allout_training/l_output.mat');
errors = abs(pred-target);
localerrors = rssq(errors(:,1:2).');

[sorteddepths,ind] = sort(target(:,3));

curve1 = movmean(localerrors(ind)./mean(localerrors), mov) + movstd(localerrors(ind)./mean(localerrors), mov);
curve2 = movmean(localerrors(ind)./mean(localerrors), mov) - movstd(localerrors(ind)./mean(localerrors), mov);
x2 = [sorteddepths.', fliplr(sorteddepths.')];
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, color2, 'edgecolor', 'none', 'facealpha', 0.5);

plot(sorteddepths, movmean(localerrors(ind)./mean(localerrors), mov), 'linewidth', 2, 'color', color2);

legend({'Small'; 'Large'}, 'FontSize', 13, 'Location', 'nw');
legend boxoff

set(gca, 'FontSize', 13, 'LineWidth', 2);
box off

xlabel('Depth (mm)');
ylabel('Normalized Localization Error');


%% Temperature error vs depth
figure();

% For legend order
plot(nan, nan, 'color', color1, 'linewidth', 2);
hold on
plot(nan, nan, 'color', color2, 'linewidth', 2);

load('Training/6inp_3layer_allin_allout_training/s_output.mat');
errors = abs(pred-target);

[sorteddepths,ind] = sort(target(:,3));

curve1 = movmean(errors(ind, 4), mov) + movstd(errors(ind, 4), mov);
curve2 = movmean(errors(ind, 4), mov) - movstd(errors(ind, 4), mov);
x2 = [sorteddepths.', fliplr(sorteddepths.')];
inBetween = [curve1.', fliplr(curve2.')];
fill(x2, inBetween, color1, 'edgecolor', 'none', 'facealpha', 0.5);

plot(sorteddepths, movmean(errors(ind,4), mov), 'linewidth', 2, 'color', color1);

load('Training/6inp_3layer_allin_allout_training/l_output.mat');
errors = abs(pred-target);

[sorteddepths,ind] = sort(target(:,3));

curve1 = movmean(errors(ind, 4), mov) + movstd(errors(ind, 4), mov);
curve2 = movmean(errors(ind, 4), mov) - movstd(errors(ind, 4), mov);
x2 = [sorteddepths.', fliplr(sorteddepths.')];
inBetween = [curve1.', fliplr(curve2.')];
fill(x2, inBetween, color2, 'edgecolor', 'none', 'facealpha', 0.5);

plot(sorteddepths, movmean(errors(ind,4), mov), 'linewidth', 2, 'color', color2);

legend({'Small'; 'Large'}, 'FontSize', 13, 'Location', 'nw');
legend boxoff

set(gca, 'FontSize', 13, 'LineWidth', 2);
box off

xlabel('Depth (mm)');
ylabel('Temperature Error (^oC)');