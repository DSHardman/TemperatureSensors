NaiveExtraction % Extract 3 data points from each of the 16 sensor response: input size 48

% Define input/output variables for quick changing
inp = extractedinp;
% inp = (inp - mean(inp))./std(inp); % normalise input
inp = normalize(inp);
out = extractedout;

% Normalize outputs between 0 and 1
% out(:,1) = out(:,1)./25; % Small: x 0-25 mm
% out(:,2) = out(:,2)./20; % Small: y 0-20 mm
% out(:,1) = out(:,1)./45; % Medium: x 0-45 mm
% out(:,2) = out(:,2)./40; % Medium: y 0-40 mm
out(:,1) = out(:,1)./50; % Large: x 0-50 mm
out(:,2) = out(:,2)./50; % Large: y 0-50 mm
out(:,3) = (out(:,3)-1)./3; % depths 1-4 mm
out(:,4) = (out(:,4)-20)./80; % Temperatures mostly 20-100 C

% Training data
P=randperm(length(inp));
XTrain=inp(P(1:round(0.8*length(inp))),:); % 80:10:10 data split
YTrain=out(P(1:round(0.8*length(inp))),:);
len=size(XTrain,2);

% Validation data
XVal=inp(P(round(0.8*length(inp))+1:round(0.9*length(inp))),:);
YVal=out(P(round(0.8*length(inp))+1:round(0.9*length(inp))),:);

% Test data
XTest=inp(P(round(0.9*length(inp)+1):end),:);
YTest=out(P(round(0.9*length(inp)+1):end),:);

% define network and training options
layers = [
    featureInputLayer(len,"Name","featureinput")
    fullyConnectedLayer(200,"Name","fc_hidden1")
    tanhLayer("Name","tanh1")
    fullyConnectedLayer(50,"Name","fc_hidden2")
    tanhLayer("Name","tanh2")
    fullyConnectedLayer(4,"Name","fc_out")
    regressionLayer("Name","regressionoutput")];

opts = trainingOptions('sgdm', ...
    'MaxEpochs',10000, ...
    'MiniBatchSize', 500,...
     'ValidationData',{XVal,YVal}, ...
    'ValidationFrequency',30, ...
    'GradientThreshold',1000, ...
    'ValidationPatience',100,...
    'InitialLearnRate',0.05*0.4, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',500, ...
    'LearnRateDropFactor', 0.1, ...
    'Verbose',0, ...
    'Plots','training-progress', 'ExecutionEnvironment', 'gpu');

% Training
[net, info] = trainNetwork(XTest,YTest,layers, opts);

% Make test set predictions
ypred = predict(net, XTrain);

% Convert predictions back to dimensioned values
% pred(:,1) = ypred(:,1).*25;  % Small
% pred(:,2) = ypred(:,2).*20;
% pred(:,1) = ypred(:,1).*45;  % Medium
% pred(:,2) = ypred(:,2).*40;
pred(:,1) = ypred(:,1).*50;  % Large
pred(:,2) = ypred(:,2).*50;
pred(:,3) = ypred(:,3).*3 + 1;
pred(:,4) = ypred(:,4).*80 + 20;

% Reference target values for error calculations
target = YTrain;
% target(:,1) = target(:,1).*25;  % Small
% target(:,2) = target(:,2).*20;
% target(:,1) = target(:,1).*45;  % Medium
% target(:,2) = target(:,2).*40;
target(:,1) = target(:,1).*50;  % Large
target(:,2) = target(:,2).*50;
target(:,3) = target(:,3).*3 + 1;
target(:,4) = target(:,4).*80 + 20;

% Calculate errors
errors = pred - target;

