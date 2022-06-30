%% Localization error vs depth
figure();

load('Training/6inp_3layer_allin_allout_training/s_output.mat');
errors = abs(pred-target);
localerrors = rssq(errors(:,1:2).');
scatter(target(:,3), localerrors./mean(localerrors), 20, 'k', 'filled');
hold on

load('Training/6inp_3layer_allin_allout_training/l_output.mat');
errors = abs(pred-target);
localerrors = rssq(errors(:,1:2).');
scatter(target(:,3), localerrors./mean(localerrors), 20, 'k');

legend({'Small'; 'Large'}, 'FontSize', 13, 'Location', 'nw');
legend boxoff

set(gca, 'FontSize', 13, 'LineWidth', 2);
box off

xlabel('Depth (mm)');
ylabel('Normalized Localization Error');

%% Temperature error vs depth
figure();

load('Training/6inp_3layer_allin_allout_training/s_output.mat');
errors = abs(pred-target);
scatter(target(:,3), errors(:,4), 20, 'k', 'filled');
hold on

load('Training/6inp_3layer_allin_allout_training/l_output.mat');
errors = abs(pred-target);
scatter(target(:,3), errors(:,4), 20, 'k');

legend({'Small'; 'Large'}, 'FontSize', 13, 'Location', 'nw');
legend boxoff

set(gca, 'FontSize', 13, 'LineWidth', 2);
box off

xlabel('Depth (mm)');
ylabel('Temperature Error (^oC)');