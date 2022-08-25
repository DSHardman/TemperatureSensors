load("Extracted/Individuals_L.mat");
colors = [0 0.447 0.741;...
            0.85 0.325 0.98;...
            0.929 0.694 0.125;...
            0.494 0.184 0.556;...
            0.466 0.674 0.188;...
            0.301 0.745 0.933;...
            0.635 0.078 0.184;
            0 0 0];


%% Deep Touch
figure();
strainresp50{8} = nan;
strainresp100{8} = nan;

for i = 1:8
    strainresp50{i} = [responsemagnitude(l_repA4_50, 2*i)...
        responsemagnitude(l_repB4_50, 2*i)...
        responsemagnitude(l_repC4_50, 2*i)];
    strainresp100{i} = [responsemagnitude(l_repA4_100, 2*i)...
        responsemagnitude(l_repB4_100, 2*i)...
        responsemagnitude(l_repC4_100, 2*i)];
    tempresp50{i} = [responsemagnitude(l_repA4_50, 2*i-1)...
        responsemagnitude(l_repB4_50, 2*i-1)...
        responsemagnitude(l_repC4_50, 2*i-1)];
    tempresp100{i} = [responsemagnitude(l_repA4_100, 2*i-1)...
        responsemagnitude(l_repB4_100, 2*i-1)...
        responsemagnitude(l_repC4_100, 2*i-1)];
end

tiledlayout(2,2, 'TileSpacing','compact','Padding','compact');
nexttile
responsebar(strainresp50, colors);
legend({'0s'; '1s'; '2s'; '3s'; '4s'; '5s'; '6s'; '7s'}, 'Location', 'n',...
    'Orientation', 'horizontal');
legend boxoff
title('50^oC Strain');
ylim([0 6]);
nexttile
responsebar(tempresp50, colors);
legend({'0t'; '1t'; '2t'; '3t'; '4t'; '5t'; '6'; '7t'}, 'Location', 'n',...
    'Orientation', 'horizontal');
legend boxoff
title('50^oC Temp');
ylim([0 40]);
nexttile
responsebar(strainresp100, colors);
title('100^oC Strain');
ylim([0 6]);
nexttile
responsebar(tempresp100, colors);
title('100^oC Temp');
ylim([0 40]);

%% Light Touch
figure();
strainresp50{8} = nan;
strainresp100{8} = nan;

for i = 1:8
    strainresp50{i} = [responsemagnitude(l_repA1_50, 2*i)...
        responsemagnitude(l_repB1_50, 2*i)...
        responsemagnitude(l_repC1_50, 2*i)];
    strainresp100{i} = [responsemagnitude(l_repA1_100, 2*i)...
        responsemagnitude(l_repB1_100, 2*i)...
        responsemagnitude(l_repC1_100, 2*i)];
    tempresp50{i} = [responsemagnitude(l_repA1_50, 2*i-1)...
        responsemagnitude(l_repB1_50, 2*i-1)...
        responsemagnitude(l_repC1_50, 2*i-1)];
    tempresp100{i} = [responsemagnitude(l_repA1_100, 2*i-1)...
        responsemagnitude(l_repB1_100, 2*i-1)...
        responsemagnitude(l_repC1_100, 2*i-1)];
end

tiledlayout(2,2, 'TileSpacing','compact','Padding','compact');
nexttile
responsebar(strainresp50, colors);
legend({'0s'; '1s'; '2s'; '3s'; '4s'; '5s'; '6s'; '7s'}, 'Location', 'n',...
    'Orientation', 'horizontal');
legend boxoff
title('50^oC Strain');
ylim([0 2.5]);
nexttile
responsebar(tempresp50, colors);
legend({'0t'; '1t'; '2t'; '3t'; '4t'; '5t'; '6'; '7t'}, 'Location', 'n',...
    'Orientation', 'horizontal');
legend boxoff
title('50^oC Temp');
ylim([0 20]);
nexttile
responsebar(strainresp100, colors);
title('100^oC Strain');
ylim([0 2.5]);
nexttile
responsebar(tempresp100, colors);
title('100^oC Temp');
ylim([0 20]);

%% Functions
function responsebar(response, colors)
    my_errorbar(response, colors(1:8, :));
    my_defaults(1000*[0.1178    0.1866    1.3336    0.6640]);
    xticklabels({'A'; 'B'; 'C'});
    ylabel('Response Magnitude (%)');
end

function magnitudes = responsemagnitude(individual, sens)
    resistances = [1e6 1.6e3 5.6e6 6.18e3 2.7e6 5.1e3 0.63e6 2.2e3...
    2.7e6 3.3e3 5.6e6 2.4e3 2.2e6 2.4e3 3.9e6 3.3e3];
    magnitudes = zeros(4,1);
    % Ignore first of 5 repetitions, in case first touch causes jump
    for i = 2:5
        smoothed = smooth(individual.responses(i,10:end,sens));
        maxresponse = max(smoothed);
        maxresponse = resistances(sens)*(5/maxresponse - 1);
        minresponse = min(smoothed);
        minresponse = resistances(sens)*(5/minresponse - 1);
        magnitudes(i-1, 1) = abs(maxresponse - minresponse);

        magnitudes(i-1, 1) = 100*magnitudes(i-1,1)/(resistances(sens)*(5/smoothed(5) - 1));
    end
end