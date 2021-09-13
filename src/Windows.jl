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

function apply(window::Window, samples::Vector{Real})::Vector{Real}
    window.f(samples)
end

function applyblackmanharris(samples::Vector{Real})::Vector{Real}
    window::Vector{Real} = []
    for index = 1:length(samples)
       push!(window, blackmanharriswindow(samples[index], index, length(samples)))
    end
    window
end

function blackmanharriswindow(sample::Real, index::Integer, windowsize::Integer)::Real
    sample * (0.35875 - 
              0.48829*cos((2*pi*(index-1))/(windowsize-1)) - 
              0.14128*cos((4*pi*(index-1))/(windowsize-1)) - 
              0.01168*cos((6*pi*(index-1))/(windowsize-1))
              )
end

function applyhann(samples::Vector{Real})::Vector{Real}
    window::Vector{Real} = []
    for index = 1:length(samples)
       push!(window, hannwindow(samples[index], index, length(samples)))
    end
    window
end

function hannwindow(sample::Real, index::Integer, windowsize::Integer)::Real
    sample * (1/2) * (1 - cos((2*pi*(index-1))/(windowsize-1)))
end

function applyhamming(samples::Vector{Real})::Vector{Real}
    window::Vector{Real} = []
    for index = 1:length(samples)
       push!(window, hammingwindow(samples[index], index, length(samples)))
    end
    window
end

function hammingwindow(sample::Real, index::Integer, windowsize::Integer)::Real
    sample * (0.54 - 0.46 * cos((2*pi*(index-1))/(windowsize-1)))
end
