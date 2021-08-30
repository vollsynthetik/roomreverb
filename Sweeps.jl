export Sweep, LinearSweep, LogarithmicSweep

abstract type Sweep <: Sound end

"Represents a discrete linear sweep."
struct LinearSweep <: Sweep
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
    envelope::Any
    LinearSweep(duration, samplerate, lowestfrequency, highestfrequency, amplitude) =
        new(duration, samplerate, lowestfrequency, highestfrequency, amplitude, createconstantenvelope(1))
    LinearSweep(duration, samplerate, lowestfrequency, highestfrequency, amplitude) =
        new(duration, samplerate, lowestfrequency, highestfrequency, amplitude, envelope)
end

"Represents a discrete logarithmic sweep."
struct LogarithmicSweep <: Sweep
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
    envelope::Any
    LogarithmicSweep(duration, samplerate, lowestfrequency, highestfrequency, amplitude) = 
        new(duration, samplerate, lowestfrequency, highestfrequency, amplitude, createconstantenvelope(1))
    LogarithmicSweep(duration, samplerate, lowestfrequency, highestfrequency, amplitude, envelope) = 
        new(duration, samplerate, lowestfrequency, highestfrequency, amplitude, envelope)
end

"Gives a sample at a time for the given sine sweep definition."
function generatesample(sweep::LinearSweep, nunmber::Int)
    a0 = sweep.amplitude * sweep.envelope(number)
    x = number / sweep.samplerate
    f = (((sweep.highestfrequency - sweep.lowestfrequency) / (2 * sweep.duration)) * x) + sweep.lowestfrequency
    Sample(f * 2 * pi * x)
end

"Gives a sample at a time for the given discrete log sweep definition."
function generatesample(sweep::LogarithmicSweep, number::Int)
    a0 = sweep.amplitude * sweep.envelope(number)
    c = log(2, sweep.highestfrequency) - log(2, sweep.lowestfrequency)
    phi0 = -((2 * pi * sweep.lowestfrequency * sweep.duration) / (c * log(2)))
    x = number / sweep.samplerate
    Sample(a0 * sin(((2 * pi * sweep.lowestfrequency * sweep.duration) / (c * log(2))) * 2^(c*x / sweep.duration) + phi0))
end
