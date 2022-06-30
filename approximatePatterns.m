x = zeros(50,1);
y = zeros(50,1);

for i = 1:50
%     x(i) = 24*sin(2*pi*i/50) + 25;
%     y(i) = 24*cos(2*pi*i/50) + 25;
    x(i) = 10*sin(2*pi*i/50) + 12.5;
    y(i) = 10*cos(2*pi*i/50) + 10;
end

inds = closestPoint(x, y, target);

figure();
% line([0 50 50 0 0], [0 0 50 50 0], 'color', 'k')
hold on
scatter(pred(inds,1), pred(inds,2), 'filled');
scatter(target(inds,1), target(inds,2), 'filled');

quiver(target(inds,1), target(inds,2),...
    pred(inds,1)-target(inds,1), pred(inds,2)-target(inds,2), 'off', 'color', 'k');


function inds  = closestPoint(x, y, target)

    assert(size(x,1)==size(y,1));

    inds = zeros(size(x));

    for i = 1:size(x,1)
        distance = rssq([target(:,1)-x(i) target(:,2)-y(i)].');
        [~, inds(i)] = min(distance);
    end
end