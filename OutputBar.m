load("Training/OutputTests.mat")

figure()

subplot(3,1,1);
makebar(s_xy, m_xy, l_xy);
ylabel('Mean Error (mm)');
title('x/y Predictions');
legend({'Partial Output'; 'Full Output'}, 'location', 'nw');
legend boxoff


subplot(3,1,2);
makebar(s_depth, m_depth, l_depth);
ylabel('Mean Error (mm)');
title('Depth Predictions');

subplot(3,1,3);
makebar(s_temp, m_temp, l_temp);
ylabel('Mean Error (^oC)');
title('Temperature Predictions');

set(gcf, 'Position', [488  217  620.2  641]);

function makebar(small, med, large)
    
    means = [mean(small); mean(med); mean(large)];
    b = bar(means);
    b(1).FaceColor = 1/255*[27 158 119];
    b(2).FaceColor = 1/255*[217 95 2];
    %b(3).FaceColor = 1/255*[117 112 179];

    set(gca,'xticklabel',{'Small';'Medium';'Large'});
    hold on
    sneg = [max(mean(small(:,1))-small(:,1)) max(mean(small(:,2))-small(:,2))];
    mneg = [max(mean(med(:,1))-med(:,1)) max(mean(med(:,2))-med(:,2))];
    lneg = [max(mean(large(:,1))-large(:,1)) max(mean(large(:,2))-large(:,2))];

    spos = [max(small(:,1)-mean(small(:,1))) max(small(:,2)-mean(small(:,2)))];
    mpos = [max(med(:,1)-mean(med(:,1))) max(med(:,2)-mean(med(:,2)))];
    lpos = [max(large(:,1)-mean(large(:,1))) max(large(:,2)-mean(large(:,2)))];

    errorbar([0.86 1.14], means(1,:), sneg, spos, 'color', 'k', 'LineStyle', 'none', 'lineWidth', 2);
    errorbar([1.86 2.14], means(2,:), mneg, mpos, 'color', 'k', 'LineStyle', 'none', 'lineWidth', 2);
    errorbar([2.86 3.14], means(3,:), lneg, lpos, 'color', 'k', 'LineStyle', 'none', 'lineWidth', 2);

    set(gca, 'LineWidth', 2, 'FontSize', 12);
    box off
end