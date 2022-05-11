% Training vs test data changed at end of NN training script

figure();

localization = rssq(errors(:,1:2).');

subplot(1,3,1);
scatter(target(:,1), target(:,2), 40, localization, 'filled');
%axis square
xlim([0 50]);
ylim([0 50]);
colorbar();
title('Localisation (mm)');

subplot(1,3,2);
scatter(target(:,1), target(:,2), 40, abs(errors(:,3)), 'filled');
%axis square
xlim([0 50]);
ylim([0 50]);
colorbar();
title('Depth (mm)');

subplot(1,3,3);
scatter(target(:,1), target(:,2), 40, abs(errors(:,4)), 'filled');
%axis square
xlim([0 50]);
ylim([0 50]);
colorbar();
title('Temperature (^oC)');

set(gcf, 'Position', 1000*[0.0970    0.4810    1.2944    0.2272]);