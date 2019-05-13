% Fields in the structure
terrain_number = 'terrain_number';
training_percentage = 'training_percentage';
simulation_plot = 'simulation_plot';
test_set_error_plot = 'test_set_error_plot';
simulation_error_plot = 'simulation_error_plot';
sets_from_file = 'sets_from_file';
training_set_path = 'training_set_path';
test_set_path = 'test_set_path';

MainConfig.terrain_number = "13";
MainConfig.training_percentage = 0.9;
MainConfig.simulation_plot = true;
MainConfig.test_set_error_plot = true;
MainConfig.simulation_error_plot = true;
MainConfig.sets_from_file = false;
% If sets_from_file
MainConfig.training_set_path = "data/training.data";
MainConfig.test_set_path = "data/test.data";

global MainConfig;