NaiveExtraction

inp = extractedinp;
inp = normalize(inp);
out = extractedout;

% training data
P=randperm(length(inp));
XTrain=inp(P(1:3600),:); % 80:10:10 data split
YTrain=out(P(1:3600),:);
len=size(XTrain,2);

YTrain(:,1) = YTrain(:,1)./25;
YTrain(:,2) = YTrain(:,2)./20;
YTrain(:,3) = (YTrain(:,3)-1)./3;
YTrain(:,4) = (YTrain(:,4)-20)./80;

% validation data
XVal=inp(P(3601:4050),:);
YVal=out(P(3601:4050),:);

YVal(:,1) = YVal(:,1)./25;
YVal(:,2) = YVal(:,2)./20;
YVal(:,3) = (YVal(:,3)-1)./3;
YVal(:,4) = (YVal(:,4)-20)./80;

% test data
XTest=inp(P(4051:end),:);
YTest=out(P(4051:end),:);

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

ypred = predict(net, XTest);

pred(:,1) = ypred(:,1).*25;
pred(:,2) = ypred(:,2).*20;
pred(:,3) = ypred(:,3).*3 + 1;
pred(:,4) = ypred(:,4).*80 + 20;

target = YTest;
target(:,1) = target(:,1).*25;
target(:,2) = target(:,2).*20;
target(:,3) = target(:,3).*3 + 1;
target(:,4) = target(:,4).*80 + 20;

errors = pred - target;


