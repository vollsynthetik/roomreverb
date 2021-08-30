export applyblackmanharris

function applyblackmanharris(samples::Array{Sample})::Array{Sample}
    window::Array{Sample} = []
    for index = 1:length(samples)
       push(window, blackmanharriswindow(samples[index].value, index, length(samples)))
    end
    window
end

function blackmanharriswindow(sample::Sample, index::Number, windowsize::Number)::Sample
    Sample(sample.value * (0.35875 - 
                           0.48829*cos((2*pi*(index-1))/(windowsize-1)) - 
                           0.14128*cos((4*pi*(index-1))/(windowsize-1)) - 
                           0.01168*cos((6*pi*(index-1))/(windowsize-1))
                           ))
end

function applyhann(samples::Array{Sample})::Array{Sample}
    window::Array{Sample} = []
    for index = 1:length(samples)
       push(window, hannwindow(samples[index].value, index, length(samples)))
    end
    window
end

function hannwindow(sample::Sample, index::Number, windowsize::Number)::Sample
    Sample(sample.value * (1/2) * (1 - cos((2*pi*(index-1))/(windowsize-1))))
end

function applyhamming(samples::Array{Sample})::Array{Sample}
    window::Array{Sample} = []
    for index = 1:length(samples)
       push(window, hammingwindow(samples[index].value, index, length(samples)))
    end
    window
end

function hammingwindow(sample::Sample, index::Number, windowsize::Number)::Sample
    Sample(sample.value * (0.54 - 0.46 * cos((2*pi*(index-1))/(windowsize-1))))
end
