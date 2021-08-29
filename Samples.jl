module Samples

export Sample

using Base

struct Sample{T<:Number}
    value::T
end

end