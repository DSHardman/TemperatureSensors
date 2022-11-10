load('DeepestBars.mat');
colors = 1/255*[117 112 179; 231 31 138];

subplot(3,1,1);
my_errorbar([{[s_xy(:,1) l_xy(:,1)]}, {[s_xy(:,2) l_xy(:,2)]}], colors(1:2,:));
my_defaults();
ylabel('Error (mm)');
xticklabels(['Small'; 'Large']);
title('xy Error')
legend(["0 - 4 mm"; "2.5 - 4 mm"], 'location', 'nw');
legend boxoff


subplot(3,1,2);
my_errorbar([{[s_depth(:,1) l_depth(:,1)]}, {[s_depth(:,2) l_depth(:,2)]}], colors(1:2,:));
my_defaults();
ylabel('Error (mm)');
xticklabels(['Small'; 'Large']);
title('Depth Error')


subplot(3,1,3)
my_errorbar([{[s_temp(:,1) l_temp(:,1)]}, {[s_temp(:,2) l_temp(:,2)]}], colors(1:2,:));
my_defaults([488.0000  152.2000  560.0000  705.8000]);
ylabel('Error (^oC)');
xticklabels(['Small'; 'Large']);
title('Temperature Error')