# TikzNeuralNetworks.jl

[![Build Status](https://travis-ci.com/mossr/TikzNeuralNetworks.jl.svg?branch=master)](https://travis-ci.com/mossr/TikzNeuralNetworks.jl) [![codecov](https://codecov.io/github/mossr/TikzNeuralNetworks.jl/coverage.svg?branch=master)](https://codecov.io/gh/mossr/TikzNeuralNetworks.jl)

Visualize neural networks using TikZ in Julia. Uses [TikzGraphs.jl](https://github.com/JuliaTeX/TikzGraphs.jl) as a backend and outputs a [`TikzPicture`](https://github.com/JuliaTeX/TikzPictures.jl).

<p align="center"><img src="./img/standard.svg"></p>

## Installation
```julia
] add https://github.com/mossr/TikzNeuralNetworks.jl
```
---
```julia
using TikzNeuralNetworks
```

## Examples

A `TikzNeuralNetwork` will output to SVG within Jupyter and Pluto noteboks, and can be saved to PDF/SVG/TEX (see below).

```julia
nn = TikzNeuralNetwork()
```
<p align="center"><img src="./img/default.svg"></p>


```julia
nn = TikzNeuralNetwork(input_size=3,
                       hidden_layer_sizes=[2, 4],
                       output_size=2)
```
<p align="center"><img src="./img/two_layer.svg"></p>


```julia
nn = TikzNeuralNetwork(input_size=3,
                       input_label=i->"\$x_{$i}\$",
                       hidden_layer_sizes=[2, 4, 3, 4],
                       activation_functions=[L"g", L"$\phi$", L"{\small $f$}", L"\sigma"],
                       hidden_layer_labels=[L"\tanh", "softplus", "ReLU", "sigmoid"],
                       output_size=1,
                       output_label=i->L"\hat{y}")
```
<p align="center"><img src="./img/deep.svg"></p>


```julia
nn = TikzNeuralNetwork(input_size=2,
                       input_arrows=false,
                       hidden_layer_sizes=[4],
                       hidden_color="blue!20",
                       output_size=1,
                       output_arrows=false)
```
<p align="center"><img src="./img/hidden_color.svg"></p>

## Structure

```julia
@with_kw mutable struct TikzNeuralNetwork
    input_size::Int = 1
    input_label::Function = i->string("input", input_size==1 ? "" : "\$_{$i}\$")
    input_arrows::Bool = true
    hidden_layer_sizes::Vector{Int} = [1]
    activation_functions::Vector{String} = fill("", length(hidden_layer_sizes))
    hidden_layer_labels::Vector{String} = fill("", length(hidden_layer_sizes))
    hidden_color::String = "lightgray!70"
    output_size::Int = 1
    output_label::Function = i->string("output", output_size==1 ? "" : "\$_{$i}\$")
    output_arrows::Bool = true
    tikz::TikzPicture = TikzPicture("")
end
```

## Saving
Saving piggy-backs on [TikzPictures.jl](https://github.com/JuliaTeX/TikzPictures.jl).

```julia
save(PDF("nn.pdf"), nn)
save(SVG("nn.svg"), nn)
save(TEX("nn.tex"), nn)
```

---
Written by [Robert Moss](https://github.com/mossr).