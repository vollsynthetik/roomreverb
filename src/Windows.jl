export applyblackmanharris,applyhann,applyhamming

function applyblackmanharris(samples::Array{T, 1})::Array{T, 1} where T <: Number
    window::Array{T, 1} = []
    for index = 1:length(samples)
       push!(window, blackmanharriswindow(samples[index], index, length(samples)))
    end
    window
end

function blackmanharriswindow(sample::T, index::Number, windowsize::Number)::T where T <: Number
    T(sample.value * (0.35875 - 
                      0.48829*cos((2*pi*(index-1))/(windowsize-1)) - 
                      0.14128*cos((4*pi*(index-1))/(windowsize-1)) - 
                      0.01168*cos((6*pi*(index-1))/(windowsize-1))
                      ))
end

function applyhann(samples::Array{T})::Array{T, 1} where T <: Number
    window::Array{T, 1} = []
    for index = 1:length(samples)
       push!(window, hannwindow(samples[index], index, length(samples)))
    end
    window
end

function hannwindow(sample::T, index::Number, windowsize::Number)::T where T <: Number
    T(sample.value * (1/2) * (1 - cos((2*pi*(index-1))/(windowsize-1))))
end

function applyhamming(samples::Array{T, 1})::Array{T, 1} where T <: Number
    window::Array{T, 1} = []
    for index = 1:length(samples)
       push!(window, hammingwindow(samples[index], index, length(samples)))
    end
    window
end

function hammingwindow(sample::T, index::Number, windowsize::Number)::T where T <: Number
    T(sample.value * (0.54 - 0.46 * cos((2*pi*(index-1))/(windowsize-1))))
end
