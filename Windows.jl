export applyblackmanharris

function applyblackmanharris(samples::Array{Sample{Float64},1})::Array{Sample{Float64},1}
    window::Array{Sample{Float64},1} = []
    for index = 1:length(samples)
       push(window, blackmanharriswindow(samples[index].value, index, length(samples)))
    end
    window
end

function blackmanharriswindow(sample::Sample{Float64}, index::Number, windowsize::Number)::Sample{Float64}
    Sample{Float64}(sample.value * (0.35875 - 
                           0.48829*cos((2*pi*(index-1))/(windowsize-1)) - 
                           0.14128*cos((4*pi*(index-1))/(windowsize-1)) - 
                           0.01168*cos((6*pi*(index-1))/(windowsize-1))
                           ))
end

function applyhann(samples::Array{Sample{Float64}})::Array{Sample{Float64},1}
    window::Array{Sample{Float64},1} = []
    for index = 1:length(samples)
       push(window, hannwindow(samples[index].value, index, length(samples)))
    end
    window
end

function hannwindow(sample::Sample{Float64}, index::Number, windowsize::Number)::Sample{Float64}
    Sample{Float64}(sample.value * (1/2) * (1 - cos((2*pi*(index-1))/(windowsize-1))))
end

function applyhamming(samples::Array{Sample{Float64},1})::Array{Sample{Float64},1}
    window::Array{Sample{Float64},1} = []
    for index = 1:length(samples)
       push(window, hammingwindow(samples[index].value, index, length(samples)))
    end
    window
end

function hammingwindow(sample::Sample{Float64}, index::Number, windowsize::Number)::Sample{Float64}
    Sample{Float64}(sample.value * (0.54 - 0.46 * cos((2*pi*(index-1))/(windowsize-1))))
end
