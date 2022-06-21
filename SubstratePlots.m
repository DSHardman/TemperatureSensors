
originals7 = [calcbars(l_repA4_50, 14); calcbars(l_repA4_100, 14);...
    calcbars(l_repB4_50, 14); calcbars(l_repB4_100, 14);
    calcbars(l_repC4_50, 14); calcbars(l_repC4_100, 14);];

es7 = [calcbars(le_repA4_50, 14); calcbars(le_repA4_100, 14);...
    calcbars(le_repB4_50, 14); calcbars(le_repB4_100, 14);
    calcbars(le_repC4_50, 14); calcbars(le_repC4_100, 14);];

fs7 = [calcbars(lf_repA4_50, 14); calcbars(lf_repA4_100, 14);...
    calcbars(lf_repB4_50, 14); calcbars(lf_repB4_100, 14);
    calcbars(lf_repC4_50, 14); calcbars(lf_repC4_100, 14);];

bar([originals7(:,1) es7(:,1) fs7(:,1)]);
hold on
errorbar([0.78; 1.78; 2.78; 3.78; 4.78; 5.78], originals7(:,1),...
    originals7(:,2), originals7(:,3), 'linestyle', 'none', 'linewidth', 2,...
    'color', 'k');
errorbar(1:6, es7(:,1),...
    es7(:,2), es7(:,3), 'linestyle', 'none', 'linewidth', 2,...
    'color', 'k');
errorbar([1.22; 2.22; 3.22; 4.22; 5.22; 6.22], fs7(:,1),...
    fs7(:,2), fs7(:,3), 'linestyle', 'none', 'linewidth', 2,...
    'color', 'k');

function outputs = calcbars(individual, sens)
    resistances = [1e6 1.6e3 5.6e6 6.18e3 2.7e6 5.1e3 0.63e6 2.2e3...
    2.7e6 3.3e3 5.6e6 2.4e3 2.2e6 2.4e3 3.9e6 3.3e3];
    magnitudes = zeros(5,1);
    for i = 1:5
        smoothed = smooth(individual.responses(i,:,sens));
        maxresponse = max(smoothed);
        maxresponse = resistances(sens)*(5/maxresponse - 1);
        minresponse = min(smoothed);
        minresponse = resistances(sens)*(5/minresponse - 1);
        magnitudes(i, 1) = abs(maxresponse - minresponse);
    end
    outputs = [mean(magnitudes) max(magnitudes)-mean(magnitudes) mean(magnitudes - min(magnitudes))];
end