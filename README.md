# Terrain Simulator with Neural Networks


## Configuration Files

### MainConfig.m

##### Elements description
* terrain_number: The string with the terrain number ("13" for this group).
* training_percentage: The percentage of the original set to use in training set.
* simulation_plot: The boolean flag to enable/disable the simulation plot.
* test_set_error_plot: The boolean flag to enable/disable the plot of error in test set.
* simulation_error_plot: The boolean flag to enable/disable the plot of error in simulation.
* sets_from_file: The boolean flag to enable/disable the use o training/test sets from specific files.
* training_set_path: The path to training set if set_from_file flag is true.
* training_set_path: The path to test set if set_from_file flag is true.


### NeuralNet.m

##### Elements description
* layers: The layers architecture (ei: [2, 30, 10, 1] including the input and output layers).
* eta: The learning rate.
* epsilon: The error dimmension.
* weight_init: The weight initialization mode (RANDOM or FAN_IN).
* activation: The activation function (TANH or EXPONENTIAL).
* momentum: The momentum coeficient (must be between 0 and 1).
* weight_decay: The weight decay proportion.
* max_epochs: The max epochs for the training.
* learning: The learning mode (BATCH or INCREMENTAL).
* optimization: The optimization of backpropagation (SGD or ADAPTIVE_ETA or ADAM).
* alfa: The adaptive eta alfa parameter.
* beta: The adaptive eta beta parameter.
* error_horizon: The adaptive eta k parameter.
* output_funtion: The output function (LINEAR).
* beta_1: The beta 1 Adam parameter.
* beta_2: The beta 2 Adam parameter.
* adam_epsilon: The epsilon Adam parameter.

## Building Project 

This project uses octave with statistics octave package previuos installed.

To install statistics pacakage in octave execute the following command in the Octave's Command Window:

```bash
	pkg install -forge statistics
```

Run the project by executing the following command in the Octave's Command Window having as working directory the project folder:

```bash
	source main.m
```

## Authors

**Group 13**

* AQUILI, Alejo Ezequiel (57432)
* BASSANI, Santiago (57435)
* SANGUINETI ARENA, Francisco Javier (57565)