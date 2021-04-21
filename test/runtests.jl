using Test
using TikzNeuralNetworks

@testset "File generation" begin
    nn = TikzNeuralNetwork()
    save(SVG("nn.svg"), nn)
    @test isfile("nn.svg")

    nn = TikzNeuralNetwork(input_arrows=false)
    save(SVG("no_input_arrows.svg"), nn)
    @test isfile("no_input_arrows.svg")

    nn = TikzNeuralNetwork(output_arrows=false)
    save(SVG("no_output_arrows.svg"), nn)
    @test isfile("no_output_arrows.svg")

    nn = TikzNeuralNetwork(input_arrows=false, output_arrows=false)
    save(SVG("no_arrows.svg"), nn)
    @test isfile("no_arrows.svg")

    nn = TikzNeuralNetwork(input_size=3, hidden_layer_sizes=[2, 4], hidden_color="white")
    save(SVG("hidden_color.svg"), nn)
    @test isfile("hidden_color.svg")

    nn = TikzNeuralNetwork(input_size=3, hidden_layer_sizes=[2, 4], hidden_layer_labels=(h,i)->["{\\scriptsize\$a_{$j}^{[$h]}\$}" for j in 1:i], activation_functions=["sigmoid", "function"], node_size="24pt")
    save(SVG("two_layer.svg"), nn)
    @test isfile("two_layer.svg")
    save(PDF("two_layer.pdf"), nn)
    @test isfile("two_layer.pdf")
    save(TEX("two_layer.tex"), nn)
    @test isfile("two_layer.tex")

    @inferred show(stdout, MIME("image/svg+xml"), nn)

end


@testset "README examples" begin
    include("readme.jl")
end
