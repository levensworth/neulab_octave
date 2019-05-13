source('multilayer_perceptron.m');

% Fields in the structure
layers = 'layers';
eta = 'eta';
epsilon = 'epsilon';
regularization = 'regularization';
weight_init = 'weight_init';
optimization = 'optimization';
momentum = 'momentum';

NetConfig.layers = [2, 30, 10, 1];
NetConfig.eta = 0.005;
NetConfig.epsilon = 0.0001;
NetConfig.weight_init = RANDOM;
NetConfig.activation = EXPONENTIAL;
NetConfig.error_vec = [];
NetConfig.momentum = 0.9;
NetConfig.weight_decay = 0.0;
NetConfig.max_epochs = 200;
NetConfig.learning = INCREMENTAL;
#educational purposes
NetConfig.epoch = 1;
global errors
global etas ;
errors = [];
etas = [NetConfig.eta];

% Eta optimization
NetConfig.optimization = SGD;
NetConfig.alfa = 0.00003;
NetConfig.beta = 0.002;
NetConfig.error_horizon = 50;
NetConfig.output_funtion = LINEAR;
% Adam
NetConfig.beta_1 = 0.9;
NetConfig.beta_2 = 0.9999;
NetConfig.adam_epsilon = 0.00000001;

global NeuralNet;
NeuralNet = NetConfig;






