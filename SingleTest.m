classdef SingleTest < handle
    properties
        n
        positions
        responses
        poses
        times
        temps
    end
    
    methods
        
        % Constructor
        function obj = SingleTest(path,path2,n)
            
            % initialise properties
            obj.n = n;
            obj.responses = zeros(n,380,16);
            obj.positions = zeros(n,3);
            obj.poses = zeros(n,380,6);
            obj.times = zeros(n,380);
            obj.temps = zeros(n,1);
            
            
            for i = 1:n
                % set positions
                obj.positions(i, :) = 1000*readNPY(strcat(path,'xy',path2, string(i-1),'.npy'));
                % set times
                obj.times(i,:) = readNPY(strcat(path,'times',path2, string(i-1),'.npy'));
                % set poses
                obj.poses(i,:,:) = readNPY(strcat(path,'poses', path2, string(i-1),'.npy'));
                % set responses
                obj.responses(i,:,:) = readNPY(strcat(path,'response', path2, string(i-1),'.npy'));
                % set temperatures
                obj.temps(i) = readNPY(strcat(path,'temp', path2, string(i-1),'.npy'));
            end
        end

        function combine(obj, secondobj)
            obj.n = obj.n + secondobj.n;
            obj.positions = [obj.positions; secondobj.positions];
            obj.responses = cat(1, obj.responses, secondobj.responses);
            obj.poses = cat(1, obj.poses, secondobj.poses);
            obj.times = [obj.times; secondobj.times];
            obj.temps = [obj.temps; secondobj.temps];
        end
        
        % plot raw sensor responses
        function plotresponse(obj, iteration, sensor)

            if nargin == 3
                plot(obj.responses(iteration,:,sensor));
            else
                colors = [0 0.447 0.741;...
                            0.85 0.325 0.98;...
                            0.929 0.694 0.125;...
                            0.494 0.184 0.556;...
                            0.466 0.674 0.188;...
                            0.301 0.745 0.933;...
                            0.635 0.078 0.184;
                            0 0 0];
                for i = 1:8
                    subplot(2,1,1);
                    plot(obj.responses(iteration,:,i*2-1), 'LineWidth', 2,...
                        'Color', colors(i,:), 'DisplayName', string(i-1)+"t",...
                        'LineStyle','-');
                    
                    hold on
                    subplot(2,1,2);
                    plot(obj.responses(iteration,:,i*2), 'LineWidth', 2,...
                        'Color', colors(i,:), 'DisplayName', string(i-1)+"s",...
                        'LineStyle','-');
                    hold on
                end
            end
            subplot(2,1,1);
            ylim([min(min(min(obj.responses)))-0.5 max(max(max(obj.responses)))]);
            xlim([0 380])
            set(gca, 'LineWidth', 2, 'FontSize', 15, 'XTickLabel', []);
            box off
            ylabel('Sensor Response (V)');
            legend('location','south', 'orientation', 'horizontal');
            title('Temperature Sensors');
            subplot(2,1,2);
            ylim([min(min(min(obj.responses)))-0.5 max(max(max(obj.responses)))]);
            xlim([0 380])
            set(gca, 'LineWidth', 2, 'FontSize', 15, 'XTickLabel', []);
            box off
            ylabel('Sensor Response (V)');
            legend('location','south', 'orientation', 'horizontal');
            title('Strain Sensors');

            titlestring = sprintf('x = %.3fmm, y = %.3fmm, Temp=%d^oC',...
                obj.positions(iteration,1), obj.positions(iteration,2),...
                obj.temps(iteration));
            sgtitle(titlestring);
            set(gcf, 'Position', [571   200   838   778]);
        end
        
    end
end

