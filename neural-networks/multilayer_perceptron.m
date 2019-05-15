source('utils.m');
source('optimization.m');
source('weight_initialization.m');
source('activation_function.m');

% Notations
% w_vector: is a vector of weight matrices.
% b_vector: is a vector of biases vectors.
% x_set: is the vector of the input patterns.
% y_set: is the vector of the expected output patterns.

global INCREMENTAL;
global BATCH;
[BATCH, INCREMENTAL] = enum();


function a = feed(input_x, NeuralNet)
    x_size = size(input_x)(1);
    w_size = size(NeuralNet.w_vector)(2);
    a = input_x;
    for i = 1 : (w_size - 1)
        h = (a * NeuralNet.w_vector{i}) + generate_bias_matrix(NeuralNet.b_vector{i}, x_size);
        y = activation(NeuralNet.activation, h);
        a = y;
    end
    %last layer can have different activation
    h = (a * NeuralNet.w_vector{w_size}) + generate_bias_matrix(NeuralNet.b_vector{w_size}, x_size);
    y = activation(NeuralNet.output_funtion, h);
    a = y;
    
endfunction

function a_vector = internal_feed(input_x )
    global NeuralNet;
    w_vector = NeuralNet.w_vector;
    b_vector = NeuralNet.b_vector;
    activationType = NeuralNet.activation;
    
    x_size = size(input_x)(1);
    w_size = size(w_vector)(2);

    a_vector =  cell(1, w_size + 1);
    for i = 1 : (w_size + 1)
        a_vector{i} = zeros([x_size, w_size]);
    end

    a_vector{1} = input_x;
    for i = 1 : (w_size - 1)
        h = (a_vector{i} * w_vector{i}) + generate_bias_matrix(b_vector{i}, x_size);
        y = activation(activationType, h);
        a_vector{i+1} = y;
    end
    h = (a_vector{w_size} * w_vector{w_size}) + generate_bias_matrix(b_vector{w_size}, x_size);
    y = activation(NeuralNet.output_funtion, h);
    a_vector{w_size+1} = y;
endfunction

function b_matrix = generate_bias_matrix(b_vector, amount_of_patterns)
    b_matrix = b_vector;
    if(amount_of_patterns > 1)
        for  i = 2:amount_of_patterns
        b_matrix = [b_matrix; b_vector];
        end
    endif
endfunction

function error = epoch_error(o_set, y_set)
    error = mean((o_set - y_set).^2);
endfunction

function delta = delta_weight(prev_delta, W, A, activationType)
    f_prime = activation_prime(A, activationType);
    delta = f_prime .* (prev_delta * W');
endfunction

function NeuralNet = back_propagate(y_set, y_hat, a_vector, input)
    global ZERO;
    global RANDOM;
    global BIAS;
    global NeuralNet;

    w_vector = NeuralNet.w_vector;
    b_vector = NeuralNet.b_vector;
    layers_vector = NeuralNet.layers;
    eta = NeuralNet.eta;
    activation = NeuralNet.activation;
    prev_derivatives = NeuralNet.prev_derivatives;
    prev_bias_derivatives = NeuralNet.prev_bias_derivatives;
    momentum = NeuralNet.momentum;
    weight_decay = NeuralNet.weight_decay;
    
    delta = y_set - y_hat;
    deltas = create_arrays(layers_vector, ZERO);
    layers_size = size(w_vector)(2);
    f_prime = activation_prime(y_hat, NeuralNet.output_funtion);
    deltas{layers_size} = f_prime .* delta;
    n_arrays = size(layers_vector)(2) - 1;
    derivatives = cell(1, n_arrays);
    for i = layers_size - 1 : -1 : 1
        deltas{i} = delta_weight(deltas{i + 1},w_vector{i+1}, a_vector{i + 1}, activation);
    end 
    new_w_vector = w_vector;
    new_b_vector = b_vector;
      
    for i = 1 : layers_size
        [eta_correction, w_derivative, bias_derivative] = weight_correction(w_vector{i}, b_vector{i} ,a_vector{i}, deltas{i}, prev_derivatives{i}, prev_bias_derivatives{i});
        eta += eta_correction;
        new_w_vector{i} = w_vector{i} + w_derivative ;
        new_b_vector{i} = b_vector{i} + bias_derivative;
        prev_derivatives{i} = w_derivative;
        prev_bias_derivatives{i} = bias_derivative;
    end
    
    NeuralNet.w_vector = new_w_vector;
    NeuralNet.b_vector = new_b_vector;
    NeuralNet.prev_derivatives = prev_derivatives;
    NeuralNet.prev_bias_derivatives = prev_bias_derivatives;
    NeuralNet.eta = eta;
    
endfunction

function NeuralNet = fit(x_set, y_set)
    global ZERO;
    global ZERO_BIAS;
    global INCREMENTAL;
    global BATCH;
    global NeuralNet;
    
    % Adam
    NeuralNet.adam_weight_first_momentum = 0;
    NeuralNet.adam_weight_second_momentum = 0;
    NeuralNet.adam_bias_first_momentum = 0;
    NeuralNet.adam_bias_second_momentum = 0;

    NeuralNet.epoch = 1;
    epoch = NeuralNet.epoch;
    % Momentum
    NeuralNet.prev_derivatives = create_arrays(NeuralNet.layers, ZERO);
    NeuralNet.prev_bias_derivatives = create_arrays(NeuralNet.layers, ZERO_BIAS);
    NeuralNet.error_vec = [];
    NeuralNet.adaptive_eta_error = [];

    # For runtime plots
    errors = [];
    etas = [NeuralNet.eta];

    do 
        if(mod(epoch, 25 ) == 0)
          epoch = epoch;
        end
        
        switch(NeuralNet.learning)
          case(BATCH)
            a_vector = internal_feed(x_set);
            NeuralNet = back_propagate(y_set, a_vector{end}, a_vector, x_set);
            error = epoch_error(y_set, a_vector{end});
            NeuralNet.adaptive_eta_error(end+1) = error;
          case(INCREMENTAL)
            for i = [1 : size(x_set)(1)]
              a_vector = internal_feed(x_set(i,:), NeuralNet);
              NeuralNet = back_propagate(y_set(i), a_vector{end}, a_vector, x_set(i));
              error = epoch_error(y_set, a_vector{end});
              NeuralNet.adaptive_eta_error(end+1) = error;
            endfor
            a_vector = internal_feed(x_set);
         endswitch
        %a_vector = internal_feed(x_set, NeuralNet);
        error = epoch_error(y_set, a_vector{end});
        printf("ERROR ----> %f\n", error);
        if( error == NaN)
          return;
        end
        errors = [errors error];
        subplot (2, 2, 1);
        grid off
        plot(errors);
        ylabel('MSE');


        %printf("ETA   ----> %f\n", NeuralNet.eta);
        etas = [etas, NeuralNet.eta];
        subplot (2, 2, 2);
        plot(etas);
        ylabel('ETA');
        epoch += 1;
        
        NeuralNet.error_vec(end+1) = error;
        NeuralNet.epoch = epoch;
    until(error <= NeuralNet.epsilon || epoch >= NeuralNet.max_epochs)
    printf("%d epochs \t %f error (MSE) in training set. \n", epoch, error);

endfunction


function [NeuralNet] = create()
    global NeuralNet;
    global ZERO;
    global RANDOM;
    global BIAS;
    global FAN_IN;
    global ADAM;
    global ADAPTIVE_ETA;

    old_w_vector = weight_init(NeuralNet.layers, NeuralNet.weight_init);
    old_b_vector = weight_init(NeuralNet.layers, BIAS);
    prev_derivatives = create_arrays(NeuralNet.layers, ZERO);

    NeuralNet.w_vector = old_w_vector;
    NeuralNet.b_vector = old_b_vector;
    NeuralNet.original_eta = NeuralNet.eta;
    NeuralNet.original_momentum = NeuralNet.momentum;
endfunction
