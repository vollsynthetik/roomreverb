export Wave, SineWave, SquareWave, PulseWave, TriangularWave, SawtoothWave

abstract type Wave <: Sound end

"Represents a sine wave at a given frequency"
struct SineWave <: Wave
    duration::Number
    samplerate::Unsigned
    frequency::Number
    dBFS::Real
    envelope::Envelope
    SineWave(duration, samplerate, frequency, dBFS) = 
        new(duration, samplerate, frequency, dBFS, ConstantEnvelope(1))
    SineWave(duration, samplerate, frequency, dBFS, envelope) = 
        new(duration, samplerate, frequency, dBFS, envelope)
end

"Gives a sample at a time for the given sine wave definition."
function generatesample(sinewave::SineWave, number::Integer)::Real
    a0 = dBFS2Float(sinewave.dBFS) * sinewave.envelope.f(number)
    x = (number - 1) / sinewave.samplerate
    a0 * sin(2 * pi * sinewave.frequency * x)
end

"Represents a square wave for a given frequency."
struct SquareWave <: Wave
    duration::Number
    samplerate::Unsigned
    frequency::Number
    dBFS::Real
    envelope::Envelope
    SquareWave(duration, samplerate, frequency, dBFS) = 
        new(duration, samplerate, frequency, dBFS, ConstantEnvelope(1))
    SquareWave(duration, samplerate, frequency, dBFS, envelope) = 
        new(duration, samplerate, frequency, dBFS, envelope)
end

"Gives a sample at a time for the given square wave definition."
function generatesample(wave::SquareWave, number::Integer)::Real
    a0 = dBFS2Float(wave.dBFS) * wave.envelope.f(number)
    modulo = wave.samplerate / wave.frequency
    mod(number - 1, modulo) < (modulo * 0.5) ? a0 : -a0
end

"Represents a pulse wave for a given frequency."
struct PulseWave <: Wave
    duration::Number
    samplerate::Unsigned
    frequency::Number
    dBFS::Real
    pulsewidth::Real
    envelope::Envelope
    PulseWave(duration, samplerate, frequency, dBFS, pulsewidth) = 
        new(duration, samplerate, frequency, dBFS, pulsewidth, ConstantEnvelope(1))
    PulseWave(duration, samplerate, frequency, dBFS, pulsewidth, envelope) = 
        new(duration, samplerate, frequency, dBFS, pulsewidth, envelope)
end

"Gives a sample at a time for the given pulse wave definition."
function generatesample(wave::PulseWave, number::Integer)::Real
    a0 = dBFS2Float(wave.dBFS) * wave.envelope.f(number)
    modulo = wave.samplerate / wave.frequency
    mod(number - 1, modulo) < (modulo * wave.pulsewidth) ? a0 : -a0
end

"Represents a triangluar wave for a given frequency."
struct TriangularWave <: Wave
    duration::Number
    samplerate::Unsigned
    frequency::Number
    dBFS::Real
    envelope::Envelope
    TriangularWave(duration, samplerate, frequency, dBFS) = 
        new(duration, samplerate, frequency, dBFS, ConstantEnvelope(1))
    TriangularWave(duration, samplerate, frequency, dBFS, envelope) = 
        new(duration, samplerate, frequency, dBFS, envelope)
end

"Gives a sample at a time for the given triangluar wave definition."
function generatesample(wave::TriangularWave, number::Integer)::Real
    a0 = dBFS2Float(wave.dBFS) * wave.envelope.f(number)
    modulo = wave.samplerate / wave.frequency
    x = mod(number - 1, modulo)
    m = (2 * a0) / (modulo / 2)
    x < (modulo / 2) ? (m*x - a0) : (-m*x + 3 * a0)
end

"Represents a saw tooth wave for a given frequency."
struct SawtoothWave <: Wave
    duration::Number
    samplerate::Unsigned
    frequency::Number
    dBFS::Real
    envelope::Envelope
    SawtoothWave(duration, samplerate, frequency, dBFS) = 
        new(duration, samplerate, frequency, dBFS, ConstantEnvelope(1))
    SawtoothWave(duration, samplerate, frequency, dBFS, envelope) = 
        new(duration, samplerate, frequency, dBFS, envelope)
end

"Gives a sample at a time for the given saw tooth wave definition."
function generatesample(wave::SawtoothWave, number::Int)::Real
    a0 = dBFS2Float(wave.dBFS) * wave.envelope.f(number)
    modulo = wave.samplerate / wave.frequency
    x = mod(number - 1, modulo)
    m = (2 * a0) / modulo
    m*x - a0
end
