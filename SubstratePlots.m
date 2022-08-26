tiledlayout(2,2);
nexttile
substratebar(6, '2s', [0 10]);
nexttile
substratebar(10, '4s', [0 10]);
nexttile;
substratebar(1, '0t', [0 50]);
nexttile;
substratebar(5, '2t', [0 50]);
set(gcf, 'position', 1000*[0.0202    0.0994    1.5072    0.7586]);

% substratebar(2, '0s', [0 10]);
% figure()
% substratebar(4, '1s', [0 10]);
% figure()
% substratebar(12, '5s', [0 10]);


function substratebar(sens, titlestring, ylims)
    load('Extracted/Individuals_L.mat');
    load('Extracted/Individuals_LE.mat');
    load('Extracted/Individuals_LF.mat');
    
    originals7 = [calcbars(l_repA4_50, sens); calcbars(l_repA4_100, sens);...
        calcbars(l_repB4_50, sens); calcbars(l_repB4_100, sens);
        calcbars(l_repC4_50, sens); calcbars(l_repC4_100, sens);];
    
    es7 = [calcbars(le_repA4_50, sens); calcbars(le_repA4_100, sens);...
        calcbars(le_repB4_50, sens); calcbars(le_repB4_100, sens);
        calcbars(le_repC4_50, sens); calcbars(le_repC4_100, sens);];
    
    fs7 = [calcbars(lf_repA4_50, sens); calcbars(lf_repA4_100, sens);...
        calcbars(lf_repB4_50, sens); calcbars(lf_repB4_100, sens);
        calcbars(lf_repC4_50, sens); calcbars(lf_repC4_100, sens);];
    
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
    
    ylabel('Response Magnitude (%)');
    xticklabels({'A (50^oC)'; 'A (100^oC)'; 'B (50^oC)'; 'B (100^oC)'; 'C (50^oC)'; 'C (100^oC)'});
    box off
    set(gca, 'FontSize', 13, 'LineWidth', 2);
    legend({'00-30';'00-10';'Foam'}, 'orientation', 'horizontal', 'location', 'ne', 'fontsize', 13);
    legend boxoff
    title(titlestring);
    ylim(ylims);
end

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

        magnitudes(i, 1) = 100*magnitudes(i,1)/(resistances(sens)*(5/smoothed(5) - 1));
    end
    outputs = [mean(magnitudes), mean(magnitudes)-min(magnitudes), max(magnitudes)-mean(magnitudes)];
end