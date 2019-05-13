source('NeuralNet.m');
source('MainConfig.m')
% Reading File
terrain = terrain_reader(MainConfig.terrain_number);

% Normalize terrain data
terrain_input = norm_normalize(terrain(:, 1:2));
terrain_normalize = [terrain_input terrain(:,3)];

% Creating Training and Test sets
if(!MainConfig.sets_from_file)
	[training_set, test_set] = subset(terrain_normalize, MainConfig.training_percentage);
else
	training_set = dlmread(MainConfig.training_set_path, '', 1, 0);
	test_set = dlmread(MainConfig.test_set_path, '', 1, 0);
endif

% Creating NeuralNet
NeuralNet = create(NetConfig);

% Prints in runtime
page_output_immediately (1);
page_screen_output (0);

% Training with training set
NeuralNet = fit(training_set(:,1:2), training_set(:,3));

if(MainConfig.test_set_error_plot)

	% Compare with test set
	x2 = test_set(:,1);
	y2 = test_set(:,2);
	z2 = feed([test_set(:,1), test_set(:,2)], NeuralNet);
	z3 = test_set(:,3) - z2;
	figure(2);
	plot_error(x2, y2, z3, 'Error del conjunto de prueba');
	printf("MSE in Test Set ----> %f\n", epoch_error(test_set(:,3), z2));
endif

function z = super_feed_matrix(x, y, net)
	 z = feed([x ; y]', net);
endfunction

if(MainConfig.simulation_plot)
	% Generating grid to simulate terrain
	n = 100;
	[X, Y] = meshgrid(linspace(min(terrain(:,1)), max(terrain(:,1)),n), linspace(min(terrain(:,2)), max(terrain(:,2)),n));

	Z = arrayfun(@super_feed_matrix, X, Y, NeuralNet);

	figure(3);
	plot3(test_set(:,1),test_set(:,2),test_set(:,3),'.', 'markersize',20, 'color', 'r', 'DisplayName', 'Prueba');
	hold on
	plot3(training_set(:,1),training_set(:,2),training_set(:,3),'.', 'markersize',20, 'color', 'b', 'DisplayName', 'Entrenamiento');
	legend ("location", "eastoutside");
	hold on
	surf(X,Y,Z, 'FaceAlpha',0.2);
	surfc(X,Y,Z);
	title('Simulacion y mediciones', "fontsize", 20);
	xlabel('Latitud');
	ylabel('Longitud');
	zlabel('Altitud');
endif

if(MainConfig.simulation_error_plot)

	x2 = terrain(:,1);
	y2 = terrain(:,2);
	z2 = feed([terrain(:,1), terrain(:,2)], NeuralNet);
	z3 = terrain(:,3) - z2;
	figure(4);
	plot_error(x2, y2, z3, 'Error de la simulacion');
endif

function plot_grid()
  	% Generating grid to simulate terrain
	n = 100;
	[X, Y] = meshgrid(linspace(min(terrain(:,1)), max(terrain(:,1)),n), linspace(min(terrain(:,2)), max(terrain(:,2)),n));

	Z = arrayfun(@super_feed_matrix, X, Y, NeuralNet);

	figure(3);
	plot3(test_set(:,1),test_set(:,2),test_set(:,3),'.', 'markersize',20, 'color', 'r', 'DisplayName', 'Prueba');
	hold on
	plot3(training_set(:,1),training_set(:,2),training_set(:,3),'.', 'markersize',20, 'color', 'b', 'DisplayName', 'Entrenamiento');
	legend ("location", "eastoutside");
	hold on
	surf(X,Y,Z, 'FaceAlpha',0.2);
	surfc(X,Y,Z);
	title('Simulacion y mediciones', "fontsize", 20);
	xlabel('Latitud');
	ylabel('Longitud');
	zlabel('Altitud');
endfunction


