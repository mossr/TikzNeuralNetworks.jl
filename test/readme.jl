using TikzNeuralNetworks

nn = TikzNeuralNetwork(input_size=3,
                       hidden_layer_sizes=[4],
                       activation_functions=["hidden"],
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
                       activation_functions=[L"\tanh", "softplus", "ReLU", "sigmoid"],
                       hidden_layer_labels=(h,i)->["{\\scriptsize\$a_{$j}^{[$h]}\$}" for j in 1:i],
                       output_size=1,
                       output_label=i->L"\hat{y}",
                       node_size="24pt")
save(SVG("../img/deep.svg"), nn)


nn = TikzNeuralNetwork(input_size=2,
                       input_arrows=false,
                       hidden_layer_sizes=[4],
                       hidden_color="blue!20",
                       output_size=1,
                       output_arrows=false)
save(SVG("../img/hidden_color.svg"), nn)
