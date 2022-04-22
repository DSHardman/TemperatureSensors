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
        function obj = SingleTest(path,temp,n)
            
            % initialise properties
            obj.n = n;
            obj.responses = zeros(n,380,16);
            obj.positions = zeros(n, 3);
            obj.poses = zeros(n,380,6);
            obj.times = zeros(n,380);
            obj.temps = zeros(n, 1);
            
            
            for i = 1:sqrt(n)
                for j = 1:sqrt(n)
                    % set positions
                    obj.positions((i-1)*n+j, :) = 1000*readNPY(strcat(path,'xy',string(temp),'_', string((i-1)*3),...
                        '_', string((j-1)*3),'.npy'));
                    % set times
                    obj.times((i-1)*n+j,:) = readNPY(strcat(path,'times',string(temp),'_', string((i-1)*3),...
                        '_', string((j-1)*3),'.npy')).';
                    % set poses
                    obj.poses((i-1)*n+j,:,:) = readNPY(strcat(path,'poses',string(temp),'_', string((i-1)*3),...
                        '_', string((j-1)*3),'.npy'));
                    % set responses
                    obj.responses((i-1)*n+j,:,:) = readNPY(strcat(letter,'response',string(temp),'_', string((i-1)*3),...
                        '_', string((j-1)*3),'.npy'));
                    % set temperatures
                    obj.temps((i-1)*n+j) = readNPY(strcat(letter,'temp',string(temp),'_', string((i-1)*3),...
                        '_', string((j-1)*3),'.npy'));
                end
            end
        end
        
        % plot raw sensor responses
        function plotresponse(obj, iteration, sensor)

            if nargin == 3
                plot(obj.rawresponses(iteration,:,sensor));
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
                    plot(obj.rawresponses(iteration,:,i*2-1), 'LineWidth', 2,...
                        'Color', colors(i,:), 'DisplayName', string(i-1)+"temp",...
                        'LineStyle','--');
                    hold on
                    plot(obj.rawresponses(iteration,:,i*2), 'LineWidth', 2,...
                        'Color', colors(i,:), 'DisplayName', string(i-1)+"strain",...
                        'LineStyle','-');
                end
            end
            ylim([min(min(min(obj.rawresponses)))-0.5 max(max(max(obj.rawresponses)))]);
            xlim([0 380])
            set(gca, 'LineWidth', 2, 'FontSize', 15, 'XTickLabel', []);
            box off
            ylabel('Sensor Response (V)');
            titlestring = sprintf('x = %.3fmm, y = %.3fmm, Press %d',...
                obj.positions(iteration,1), obj.positions(iteration,2),...
                iteration);
            title(titlestring);
        end
        
    end
end

