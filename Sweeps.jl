export Sweep, LinearSweep, LogarithmicSweep

abstract type Sweep <: Sound end

"Represents a discrete linear sweep."
struct LinearSweep <: Sweep
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
end

"Represents a discrete logarithmic sweep."
struct LogarithmicSweep <: Sweep
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
end

"Gives a sample at a time for the given sine sweep definition."
function generatesample(sinewave::LinearSweep, nunmber::Int)
end

"Gives a sample at a time for the given discrete log sweep definition."
function generatesample(sweep::LogarithmicSweep, number::Int)
    a0 = sweep.amplitude
    c = log(2, sweep.highestfrequency) - log(2, sweep.lowestfrequency)
    phi0 = -((2 * pi * sweep.lowestfrequency * sweep.duration) / (c * log(2)))
    x = number / sweep.samplerate
    Sample(a0 * sin(((2 * pi * sweep.lowestfrequency * sweep.duration) / (c * log(2))) * 2^(c*x / sweep.duration) + phi0))
end
