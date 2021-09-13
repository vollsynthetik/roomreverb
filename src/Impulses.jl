export Impulse, BellFunctionImpulse, DiracImpulse

"Represents an abstract impulse."
abstract type Impulse <: Sound end

"Represents a Bell function impulse."
struct BellFunctionImpulse <: Impulse
    duration::Number
    samplecount::Unsigned
    samplerate::Unsigned
    BellFunctionImpulse(samplecount, samplerate) = new(samplecount / samplerate, samplecount, samplerate)
end

"Generates a single sample at a time for the given bell function impulse definiton."
function generatesample(impulse::BellFunctionImpulse, number::Integer)::Real
    epsilon = 1 / (2 * pi * (impulse.samplerate / impulse.samplecount)^2)
    x = (number - 1/2 - (impulse.samplecount / 2)) / (impulse.samplerate / 4)
    ((4 / (sqrt(2 * pi * epsilon))) * exp( - (x^2 / (2 * epsilon)))) / impulse.samplerate
end

"Represents a Dirac Impulse, i.e., one sample with samplerate height."
struct DiracImpulse <: Impulse
    duration::Number
    samplerate::Unsigned
    DiracImpulse(samplerate) = new(1 / samplerate, samplerate)
end

"Generates exactly a single sample for the given dirac impulse definiton."
function generatesample(impulse::DiracImpulse, number::Integer)::Real
    1
end