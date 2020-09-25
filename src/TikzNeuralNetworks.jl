module TikzNeuralNetworks

using TikzGraphs
using TikzPictures
using LightGraphs
using Parameters

export TikzNeuralNetwork, save, PDF, TEX, SVG, @L_str

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

    function TikzNeuralNetwork(kwargs...)
        nn = new(kwargs...)
        node_styles = Dict()

        num_input_labels = nn.input_arrows ? nn.input_size : 0
        num_output_labels = nn.output_arrows ? nn.output_size : 0
        num_nodes = num_input_labels + nn.input_size + sum(nn.hidden_layer_sizes) + nn.output_size + num_output_labels
        g = DiGraph(num_nodes)

        # input labels as nodes with edges
        if nn.input_arrows
            for i in 1:nn.input_size
                add_edge!(g, i, i+nn.input_size)
                node_styles[i] = "draw=none, rectangle, minimum size=1pt"
            end
            latest_node = nn.input_size+1
        else
            latest_node = 1
        end

        layer_sizes = [nn.input_size, nn.hidden_layer_sizes..., nn.output_size]
        nnnode_style = "circle, draw=black, fill=white, minimum size=16pt"

        # assumes fully connected
        for ls in 1:length(layer_sizes)-1
            isinput::Bool = ls == 1
            ishidden::Bool = ls > 1
            pre_layer_idx = (1:layer_sizes[ls]) .+ (latest_node-1)
            post_layer_idx = (1:layer_sizes[ls+1]) .+ pre_layer_idx[end]
            for i in pre_layer_idx
                node_styles[i] = nnnode_style
                if isinput && !nn.input_arrows
                    node_styles[i] *= ", label=left:{$(nn.input_label(i))}"
                elseif ishidden
                    node_styles[i] *= ", fill=$(nn.hidden_color)"
                    # add hidden layer label to top node
                    if !isempty(nn.hidden_layer_labels[ls-1]) && i == pre_layer_idx[1]
                        node_styles[i] *= ", label=above:{$(nn.hidden_layer_labels[ls-1])}"
                    end
                end
                for j in post_layer_idx
                    add_edge!(g, i, j)
                end
            end
            latest_node = post_layer_idx[1]
        end

        # output labels
        for (i,o) in enumerate((num_nodes-num_output_labels-nn.output_size+1):num_nodes-num_output_labels)
            node_styles[o] = nnnode_style
            if !nn.output_arrows
                node_styles[o] *= ", label=right:{$(nn.output_label(i))}"
            end
        end

        if nn.output_arrows
            for i in (num_nodes-nn.output_size-num_output_labels+1):(num_nodes-nn.output_size)
                add_edge!(g, i, i+nn.output_size)
            end
            for i in (num_nodes-nn.output_size+1):num_nodes
                node_styles[i] = "draw=none, rectangle, minimum size=1pt"
            end
        end

        # inner node labels, fill hidden layers with `activation_functions`
        node_tags = String[]
        if nn.input_arrows
            for i in 1:nn.input_size
                push!(node_tags, nn.input_label(i))
            end
        end

        push!(node_tags, fill("", nn.input_size)...)

        for (i,hs) in enumerate(nn.hidden_layer_sizes)
            push!(node_tags, fill(nn.activation_functions[i], hs)...)
        end

        push!(node_tags, fill("", nn.output_size)...)

        if nn.output_arrows
            for i in 1:nn.output_size
                push!(node_tags, nn.output_label(i))
            end
        end

        nn.tikz = TikzGraphs.plot(g, Layouts.Layered(), node_tags,
                                  node_styles=node_styles,
                                  options="grow'=right, level distance=15mm, sibling distance=2mm, semithick, >=stealth'")
        return nn
    end
end

# Show the TikzPicture when in a notebook
Base.show(f::IO, ::MIME"image/svg+xml", nn::TikzNeuralNetwork) = Base.show(f, MIME("image/svg+xml"), nn.tikz)

TikzPictures.save(pdf::PDF, nn::TikzNeuralNetwork) = save(pdf, nn.tikz)
TikzPictures.save(tex::TEX, nn::TikzNeuralNetwork) = save(tex, nn.tikz)
TikzPictures.save(svg::SVG, nn::TikzNeuralNetwork) = save(svg, nn.tikz)

end # module
