NaiveExtraction % Extract 3 data points from each of the 16 sensor response: input size 48

% Define input/output variables for quick changing
inp = extractedinp;
out = extractedout;

% Training data
P=randperm(length(inp));
XTrain=inp(P(1:round(0.8*length(inp))),:); % 80:10:10 data split
YTrain=out(P(1:round(0.8*length(inp))),:);
len=size(XTrain,2);

% Normalize training outputs between 0 and 1
YTrain(:,1) = YTrain(:,1)./25; % Small: x 0-25 mm
YTrain(:,2) = YTrain(:,2)./20; % Small: y 0-20 mm
YTrain(:,3) = (YTrain(:,3)-1)./3; % depths 1-4 mm
YTrain(:,4) = (YTrain(:,4)-20)./80; % Temperatures mostly 20-100 C

% Validation data
XVal=inp(P(round(0.8*length(inp))+1:round(0.9*length(inp))),:);
YVal=out(P(round(0.8*length(inp))+1:round(0.9*length(inp))),:);

% Normalize validation outputs between 0 and 1
YVal(:,1) = YVal(:,1)./25;
YVal(:,2) = YVal(:,2)./20;
YVal(:,3) = (YVal(:,3)-1)./3;
YVal(:,4) = (YVal(:,4)-20)./80;

% Test data
XTest=inp(P(round(0.9*length(inp)+1):end),:);
YTest=out(P(round(0.9*length(inp)+1):end),:);

% Normalize test outputs between 0 and 1
YTest(:,1) = YTest(:,1)./25;
YTest(:,2) = YTest(:,2)./20;
YTest(:,3) = (YTest(:,3)-1)./3;
YTest(:,4) = (YTest(:,4)-20)./80;

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
    'MaxEpochs',1000, ...
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
ypred = predict(net, XTest);

% Convert predictions back to dimensioned values
pred(:,1) = ypred(:,1).*25;
pred(:,2) = ypred(:,2).*20;
pred(:,3) = ypred(:,3).*3 + 1;
pred(:,4) = ypred(:,4).*80 + 20;

% Reference target values for error calculations
target = YTest;
target(:,1) = target(:,1).*25;
target(:,2) = target(:,2).*20;
target(:,3) = target(:,3).*3 + 1;
target(:,4) = target(:,4).*80 + 20;

% Calculate errors
errors = pred - target;

