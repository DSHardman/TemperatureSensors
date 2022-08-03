resistance = (5./s_logA4_response(:,5) - 1)*2.7;
plot(s_logA4_response_times, smooth(resistance, 50), 'color', 'b');
xlabel('Time (s)');
ylabel('Resistance (M\Omega)')
set(gca, 'LineWidth', 2, 'FontSize', 13);
box off
set(gcf, 'Position', [415.4000  578.6000  940.0000  279.4000]);