export Sweep, DiscreteSweep, DiscreteLogSweep, iterate, generatesample

abstract type Sweep end
abstract type DiscreteSweep <: Sweep end

struct DiscreteLogSweep <: DiscreteSweep
    duration::Number
    samplerate::Int
    lowestfrequency::Number
    highestfrequency::Number
    amplitude::Number
end

function generatesample(sweep::DiscreteLogSweep, number::Int)
    a0 = sweep.amplitude
    c = log(2, sweep.highestfrequency) - log(2, sweep.lowestfrequency)
    phi0 = -((sweep.lowestfrequency * sweep.duration) / (c * log(2)))
    x = number / sweep.samplerate
    Sample(a0 * sin(((sweep.lowestfrequency * sweep.duration) / (c * log(2))) * 2^(c*x / sweep.duration) + phi0))
end

function Base.iterate(S::DiscreteSweep, state=1)
    state > S.duration * S.samplerate ? nothing : (generatesample(S, state), state + 1)
end
