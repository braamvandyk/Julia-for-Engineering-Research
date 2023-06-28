function addthem(a::T, b::S) where {T<:Number, S<:Number}
    return a + b
end

function addthem(a::T, b::T) where T<:AbstractString
    return a * b
end

addthem(1, 2)
addthem(2, 2.0)
addthem("One", "Two")