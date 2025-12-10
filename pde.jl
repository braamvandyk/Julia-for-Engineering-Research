using ModelingToolkit
using DifferentialEquations
using MethodOfLines
using DomainSets
using Plots
using Interpolations

# Concentration of A in feed at various times
times = [0.0, 5.0, 6.0, 10.0, 20.0, 30.0]
feeds = [0.3, 0.5, 0.45, 0.25, 0.2, 0.3]

# Create a linear interpolation function for concentrtion of A vs time
interp_linear = linear_interpolation(times, feeds)

feed(t) = interp_linear(t)
@register_symbolic feed(t)

@variables x t
@variables c(..)

∂t = Differential(t)
∂x = Differential(x)

# advection-diffusion constants
Da = 100.0
v = 5.0
cₒ = 0.0
cf = 1.0

# advection-diffusion equation
eqn = ∂t(c(x, t)) ~ Da * ∂x(c(x, t))^2 - v * ∂x(c(x, t))

# initial and boundary conditions

# Danckwerts boundary conditions
bcs = [
    c(x, 0) ~ cₒ,
    (-Da/v)*∂x(c(0.0, t)) + c(0.0, t) ~ feed(t),
    ∂x(c(100.0, t)) ~ 0.0
]

# space and time domains
domain = [x ∈ Interval(0.0, 100.0), t ∈ Interval(0.0, 30.0)]

# define PDE system
@named sys = PDESystem(eqn, bcs, domain, [x, t], [c(x, t)])

# convert the PDE into an ODE problem
prob = discretize(sys, MOLFiniteDifference([x => 101], t))

# solve the problem
sol = solve(prob, AutoTsit5(Rosenbrock23()), saveat=0.2)

discrete_x = sol[x]
discrete_t = sol[t]
solc = sol[c(x, t)]

anim = @animate for i in eachindex(discrete_t)
    plot(discrete_x, solc[:, i], title = "t=$(discrete_t[i])", leg=:none, ylims=(0.0, 0.6))
end

gif(anim, "profile.gif", fps = 10)


"""
    findprimes(N::T) where T <: Integer

Find all prime numbers less than or equal to N
"""

function findprimes(N::T) where T <: Integer
    numbers = collect(2:N)
    isprime = trues(length(numbers))
    
    index = 1
    p = numbers[index]

    while true
        m = 2
        for j = (index + 1):length(numbers)
            if isprime[j] && (numbers[j] % p == 0)
                isprime[j] = false
            end
        end
        
        newindex = findfirst(isprime[index+1:end])
        isnothing(newindex) && break
        index += newindex

        p = numbers[index]
    end 
    
    return numbers[isprime]
end

p = findprimes(50)