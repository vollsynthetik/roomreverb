export Envelope, ConstantEnvelope, LinearEnvelope

abstract type Envelope end

"Represents a constant envelope"
struct ConstantEnvelope <: Envelope
    c::Number
    f::Function
    ConstantEnvelope(c) =
        new(c, (x -> c))
end

"Represents a constant envelope"
struct LinearEnvelope <: Envelope
    m::Number
    n::Number
    f::Function
    LinearEnvelope(m,n) =
        new(m, n, (x -> m*x + n))
end
