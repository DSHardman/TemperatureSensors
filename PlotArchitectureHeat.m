figure();

heatmap([l_3(:,3); l_6(:,3); l_12(:,3); l_tvd(:,3)]);

% set(gca, 'YDisplayLabels', {'3-inp [100]';'3-inp [100 50]';...
%     '3-inp [200 50]';'3-inp [200 50 20]';'6-inp [100]';'6-inp [100 50]';...
%     '6-inp [200 50]';'6-inp [200 50 20]';'12-inp [100]';'12-inp [100 50]';...
%     '12-inp [200 50]';'12-inp [200 50 20]';'TVD3 [100]';'TVD3 [100 50]';...
%     'TVD3 [200 50]';'TVD3 [200 50 20]'}, 'XDisplayLabels', 'L x/y');

set(gca, 'XDisplayLabels', 'L Temp', 'YDisplayLabels', nan(16,1));

colormap('summer');
%set(gcf, 'Position', [488.0000  209.0000  364.2000  649.0000]);
set(gcf, 'Position', [832.2000  225.8000  276.8000  648.8000]);
