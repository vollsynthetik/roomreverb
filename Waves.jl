export SineWave

"Represents a sine wave at a given frequency"
struct SineWave <: Sound
    duration::Number
    samplerate::Int
    frequency::Number
    amplitude::Number
end

"Gives a sample at a time for the given sine wave definition."
function generatesample(sinewave::SineWave, nunmber::Int)
    a0 = sweep.amplitude
    x = number / sweep.samplerate
    Sample(a0 * sin(2 * pi * sinewave.frequency * x))
end
