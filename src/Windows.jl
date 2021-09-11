export Window, BlackmanHarrisWindow, HannWindow, HammingWindow, apply

abstract type Window end

"Represents a Blackmann-Harris window."
struct BlackmanHarrisWindow <: Window
    f::Function
    BlackmanHarrisWindow() = new(samples -> applyblackmanharris(samples))
end

"Represents a Hann window."
struct HannWindow <: Window
    f::Function
    HannWindow() = new(samples -> applyhann(samples))
end

"Represents a Hamming window."
struct HammingWindow <: Window
    f::Function
    HammingWindow() = new(samples -> applyhamming(samples))
end

function apply(window::Window, samples::Array{Float64, 1})::Array{Float64, 1}
    window.f(samples)
end

function applyblackmanharris(samples::Array{Float64, 1})::Array{Float64, 1}
    window::Array{Float64, 1} = []
    for index = 1:length(samples)
       push!(window, blackmanharriswindow(samples[index], index, length(samples)))
    end
    window
end

function blackmanharriswindow(sample::Float64, index::Number, windowsize::Number)::Float64
    sample * (0.35875 - 
              0.48829*cos((2*pi*(index-1))/(windowsize-1)) - 
              0.14128*cos((4*pi*(index-1))/(windowsize-1)) - 
              0.01168*cos((6*pi*(index-1))/(windowsize-1))
              )
end

function applyhann(samples::Array{Float64})::Array{Float64, 1}
    window::Array{Float64, 1} = []
    for index = 1:length(samples)
       push!(window, hannwindow(samples[index], index, length(samples)))
    end
    window
end

function hannwindow(sample::Float64, index::Number, windowsize::Number)::Float64
    sample * (1/2) * (1 - cos((2*pi*(index-1))/(windowsize-1)))
end

function applyhamming(samples::Array{Float64, 1})::Array{Float64, 1}
    window::Array{Float64, 1} = []
    for index = 1:length(samples)
       push!(window, hammingwindow(samples[index], index, length(samples)))
    end
    window
end

function hammingwindow(sample::Float64, index::Number, windowsize::Number)::Float64
    sample * (0.54 - 0.46 * cos((2*pi*(index-1))/(windowsize-1)))
end
