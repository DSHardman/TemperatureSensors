% Uses target/error variables created at end of NN_Training.m

n = 100;
quiver(target(1:n,1),target(1:n,2),errors(1:n,1),errors(1:n,2), 'off', 'color', 'k');
set(gca, 'LineWidth', 2, 'FontSize', 15);
xlim([0 50]);
ylim([0 50]);
xlabel('X (mm)');
ylabel('Y (mm)');
