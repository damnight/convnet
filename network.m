net = network;

net.numInputs = 2; %fine and coarse scale images
net.numLayers = 5; %inhibitory and excitatory neurons (TO BE CHANGED maybe)

%biases (E5, and E4 may be realised this way)

%input connections: inputConnect(layer,input)
%1.finescale (input 1) to first layer(1) sideregion
%2.finescale (input1) to second layer(2) endregion
%3.finesclae (input1) to third layer(3) inhibition layer
%4.coarse scale (input 2) to second layer(2) endregion
net.inputConnect(1,1) = 1;
net.inputConnect(1,2) = 1;
net.inputConnect(1,3) = 1;
net.inputConnect(2,2) = 1;

%layer connections: layerConnect(targetLayer.sourceLayer)
%layer 1 to layer 2 for consistent side inhib
%layer 1 to layer 3 for final inhib calc (side)
%layer 2 to layer 3 for final inhib calc (end)
%layer 3 to layer 3 for final inhib calc (with source image)
net.layerConnect(2.1);
net.layerConnect(3.1);
net.layerConnect(3.2);
net.layerConnect(3.3);

%output connections: outputConnect [layer1 layer2 layer3] (indicate with
%boolean)
%only layer 3 which sends the output to a binary map constructor
net.outputConnect = [0 0 1];

%preprocessing functions for the inputs: inputs{layerIndex}.processFcns
net.inputs{1}.processFcns = {'preprocessImage'};
net.inputs{1}.processFcns = {'preprocessImage'};

%set first layer neurons: 
%size = #ofNeurons
%transferFcn = functionToNextLayer
%initFcn = initialization function
net.layers{1}.size = 32; %one neuron per pixel?
net.layers{1}.transferFcn = 'WDoG'; %part of the weighting function Ws*WDoG = Wside (11)
net.layers{1}.initFcn = 'initwb'; %https://de.mathworks.com/help/nnet/ref/init.html

%set second layer neurons
net.layers{2}.size = 28; %one neuron per pixel?
net.layers{2}.transferFcn = ''; %endreion functions
net.layers{2}.initFcn = 'initwb'; %https://de.mathworks.com/help/nnet/ref/init.html

%set third layer neurons
net.layers{2}.size = 8; %1/4 of previous neurons or maybe 4 times as many? really no clue atp
net.layers{2}.transferFcn = '';
net.layers{3}.initFcn = 'initnw';

%initialization, training, evaluation
net.initFcn = 'initlay'; %https://de.mathworks.com/help/nnet/ref/initlay.html?searchHighlight=initlay&s_tid=doc_srchtitle
net.trainFcn = 'trainlm'; %not sure if best training function
net.performFcn = 'mse'; %not sure it's usable since there must be layer in which it's tested, which currently resides outside the net




