net = network;
%initialization, training, evaluation
net.initFcn = 'initlay'; %https://de.mathworks.com/help/nnet/ref/initlay.html?searchHighlight=initlay&s_tid=doc_srchtitle
net.trainFcn = 'trainlm'; %not sure if best training function
net.performFcn = 'mse'; %not sure it's usable since there must be layer in which it's tested, which currently resides outside the net

    %initialize imds
    imds = initImds; 
    %disp('imds = ');
    %disp(imds);

net.numInputs = 1; %one 520x520 preProc image (gabor energy map)
net.numLayers = 6; 


%layernames:
net.layers{1}.name = 'surroundinhib';
net.layers{2}.name = 'maxpooling';
net.layers{3}.name = 'adtEndWeighting';
net.layers{4}.name = 'extAdtEndWeighting';
net.layers{5}.name = 'InhibitionLayer';
net.layers{6}.name = 'binarizationLayer';
%biases (E5, and E4 may be realised this way)

%input connections: inputConnect(layer,input)
%input -> 1,2,3,5
net.inputConnect(1,1) = 1;
net.inputConnect(2,1) = 1;
net.inputConnect(3,1) = 1;
net.inputConnect(5,1) = 1;


%layer connections: layerConnect(targetLayer.sourceLayer)
%1 -> 5,3
%rest consecutive
net.layerConnect(5,1) = 1;
net.layerConnect(5,3) = 1;
net.layerConnect(3,1) = 1;
net.layerConnect(3,2) = 1;
net.layerConnect(4,3) = 1;
net.layerConnect(5,4) = 1;
net.layerConnect(6,5) = 1;

net.biasConnect(1) = 1;

%output connections: outputConnect [layer1 layer2 layer3] (indicate with
%boolean)
net.outputConnect = [0 0 0 0 0 1]; %layer 6 connects to output

%preprocessing functions for the inputs: inputs{layerIndex}.processFcns
%example inputs
exampleMap = zeros(520);
exampleMap(:,:,13) = zeros(520);
disp(size(exampleMap));


%size = #ofNeurons
%transferFcn = functionToNextLayer
%initFcn = initialization function
%set first layer neurons: surrWeighting
%net.layers{1}.size = 32; %one neuron per pixel?
net.layers{1}.size = 6;
%net.layers{1}.exampleInputs = exampleMap;
net.layers{1}.netInputParam = exampleMap;
net.layers{1}.transferParam = exampleMap;
net.layers{1};
net.layers{1}.transferFcn = 'surroundWeighting_new'; %part of the weighting function Ws*WDoG = Wside (11)
%net.layers{1}.initFcn = 'initlay';

%set second layer neurons: maxpooling to 28x28
net.layers{2}.size = 32; %one neuron per pixel?
net.layers{2}.transferFcn = 'maxPooling2dLayer' ;

%set third layer neurons: adptEndWeighting
net.layers{3}.size = 28;
net.layers{3}.transferFcn = 'adptEndInhib';


%set fourth layer neurons: extAdptEndWeighting
net.layers{4}.size = 28;
net.layers{4}.transferFcn = 'apdtEndInhibExt';


%set fifth layer neurons: E-surround-end
net.layers{5}.size = 28;
net.layers{5}.transferFcn = 'convInhibition';


%set sixth layer neurons: binarization
net.layers{6}.size = 1;
net.layers{6}.transferFcn = 'im2bw'; %or nonMaximalSupp.m



%    %0. training options
%     opts = trainingOptions('sgdm', ...
%     'InitialLearnRate', 0.001, ...
%    'LearnRateSchedule', 'piecewise', ...
%     'LearnRateDropFactor', 0.1, ...
%    'LearnRateDropPeriod', 8, ...
%     'L2Regularization', 0.004, ...
%     'MaxEpochs', 10, ...
%     'MiniBatchSize', 100, ...
%     'Verbose',true);



    %1. train cnn
       % net = init(net);
        net = train(net,imds);
        view(net);




    
    
   

  
%     %3. analyise net
%     act1 = activations(net,imds,'conv_1','OutputAs','channels');
%     sz = size(act1);
%     %act1 = reshape(act1,[sz(1) sz(2) 1 sz(3)]);
%     disp(size(act1));
%     imshow(act1(:,:,1,4)); %does it display something good or not?
%     %montage(mat2gray(act1),'Size',[8 12]);