# Import the Base functions we are going to extend
import Base: +, /, convert, promote_rule

# Define our Dual number type as a sub-type of Number
struct Dual <: Number
    f::Tuple{Float64, Float64}
end

# Tell Julia how to add and divide with Dual
+(x::Dual, y::Dual) = Dual(x.f .+ y.f)
/(x::Dual, y::Dual) = Dual((x.f[1]/y.f[1], (y.f[1]*x.f[2] - x.f[1]*y.f[2])/y.f[1]^2))

# Tell Julia how to deal with type conversions
convert(::Type{Dual}, x::Real) = Dual((float(x), 0.0))
promote_rule(::Type{Dual}, ::Type{<:Number}) = Dual

# The Babylonian algorithm for square roots
function babylonian(x, n = 10)
    a = (x + 1)/2
    for i in 2:n
        a = (a + x/a)/2
    end
    return a
end

# Test our algorithm
babylonian(2)
err = babylonian(2) - √2

# Create a dual number, with the epsilon part set to 1, to "seed" the derivative for the first variable
d = Dual((2., 1.))

# Run the same code we just used for real numbers
res = babylonian(d)

# Check the results
res.f[1] - √2
res.f[2] - 0.5/√2