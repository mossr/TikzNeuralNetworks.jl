using TikzNeuralNetworks

nn = TikzNeuralNetwork(input_size=3,
                       hidden_layer_sizes=[4],
                       hidden_layer_labels=["hidden"],
                       output_size=2)
save(SVG("../img/standard.svg"), nn)


nn = TikzNeuralNetwork()
save(SVG("../img/default.svg"), nn)


nn = TikzNeuralNetwork(input_size=3,
                       hidden_layer_sizes=[2, 4],
                       output_size=2)
save(SVG("../img/two_layer.svg"), nn)


nn = TikzNeuralNetwork(input_size=3,
                       input_label=i->"\$x_{$i}\$",
                       hidden_layer_sizes=[2, 4, 3, 4],
                       activation_functions=[L"g", L"$\phi$", L"{\small $f$}", L"\sigma"],
                       hidden_layer_labels=[L"\tanh", "softplus", "ReLU", "sigmoid"],
                       output_size=1,
                       output_label=i->L"\hat{y}")
save(SVG("../img/deep.svg"), nn)


nn = TikzNeuralNetwork(input_size=2,
                       input_arrows=false,
                       hidden_layer_sizes=[4],
                       hidden_color="blue!20",
                       output_size=1,
                       output_arrows=false)
save(SVG("../img/hidden_color.svg"), nn)
