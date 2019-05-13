pkg load statistics

global ZERO;
global RANDOM;
global FAN_IN; 
global BIAS;
global ZERO_BIAS; 

function [varargout] = enum (first_index = 1) 
    for k = 1:nargout 
      varargout {k} = k + first_index - 1; 
    endfor 
endfunction

[ZEROS, RANDOM, FAN_IN, BIAS, ZERO_BIAS] = enum(0);

function result = create_arrays(arraySize, type)
global ZERO;
global RANDOM;
global FAN_IN; 
global BIAS; 
global ZERO_BIAS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% arraySize es un vector con las dimensiones de cada capa ej: [4,3,2, 3, 5] %%
%% nArrays es el numero de capas a crear                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    n_arrays = size(arraySize)(2) - 1;
    result = cell(1, n_arrays );
    for i = 1 : (n_arrays)
        switch (type)
            case (RANDOM)
                result{i} = randn([arraySize(i), arraySize(i + 1)]);
            case (BIAS)
                result{i} = (zeros([1, arraySize(i+1)]) - 1);
            case (ZERO_BIAS)    
                result{i} = zeros([1, arraySize(i+1)]);
            case (FAN_IN)
                mu = 0;
                sigma = (1 / ( arraySize(i))) ^ (1/2);
                #result{i} =  norm_matrix(arraySize(i), arraySize(i +1), mu, sigma);    
                result{i} = randn([arraySize(i), arraySize(i + 1)]) .* sigma;            
            otherwise
                result{i} = (zeros([arraySize(i), arraySize(i + 1)]));
        endswitch
    end
endfunction

function [training_set, test_set] = subset(original_set, training_percentage)
    original_size = length(original_set(:,1));
    if(0 < training_percentage && training_percentage < 1)
        training_size = floor(training_percentage * original_size);
        count = 1;
        for index = randperm(original_size)
            if count < training_size
                training_set(count, :) = original_set(index, :);
            else
                test_set(count - training_size + 1, :) = original_set(index, :);
            endif
            count = count + 1;
        end 
    endif
endfunction

% Normalize Functions

function input_set = gaussian_normalize(input_set)
  mean_data_set = mean(input_set);
  std_dev = std(input_set);
  input_set = (input_set - mean_data_set) ./ std_dev;
endfunction

function norm_set = norm_normalize(input_set)
  for i = [ 1 : size(input_set)(2)]
    norm_value = norm(input_set(i));
    if(norm_value != 0)
      input_set(i) = input_set(i) / norm_value;
    end
  endfor
  norm_set = input_set;
endfunction

function norm_input = min_max_normalize(input_set, min_val, max_val)
  norm_input = input_set - min(input_set(:));
  norm_input = norm_input ./ max(input_set(:));
  norm_input = norm_input * (max_val - min_val) + min_val;
endfunction

function matrix =  norm_matrix(n,m, mu, sigma)
    matrix = normrnd(mu, sigma, [n,m]);
endfunction

% Plot Functions

function plot_error(x2, y2, z3, str)
  n = 1000;
  [X, Y] = meshgrid(linspace(min(x2),max(x2), n), linspace(min(y2),max(y2), n));
  Z = griddata(x2,y2,z3,X,Y);
  Z(isnan(Z)) = 0;
  subplot (2, 1, 2)
  title(str,"fontsize", 20);
  surface(X,Y,0*X,Z,'EdgeColor','none','FaceColor','flat');
  xlabel('Latitud');
  ylabel('Longitud');
  colorbar();
  subplot (2, 1, 1)
  surf(X, Y, Z);
  xlabel('Latitud');
  ylabel('Longitud');
  zlabel('Error');
endfunction

function terrain = terrain_reader(terrain_number = "13")
  terrain_str = ["data/terrain/terrain" terrain_number ".data"];
  terrain = dlmread(terrain_str, '', 1, 0);
endfunction
