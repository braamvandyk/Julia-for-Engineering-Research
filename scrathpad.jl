using DifferentialEquations, Plots

"""
The reactions rates for A + B -> C
    u:  array with the molar flows of A, B and C
    p:  tuple with P and T
    t:  position in the reactor 0..L
"""
function rates!(du, u, p, t)
    k₀ = 0.50
    Eₐ = 100.0
    T₀ = 500.0
    R = 8.314
    
    # Convert molar flows to molar fractions
    y = u ./ sum(u)

    # Unpack the tuple to get pressure and temperature
    P, ΔP, T = p

    k = k₀ * exp(-Eₐ/R * (1/T - 1/T₀))
    rA = -k * y[1] * y[2] * P^2
    rB = rA
    rC = -rA

    du[1] = rA
    du[2] = rB
    du[3] = rC
end

# Set up the input values and pack into a tuple of parameters
T = 510.0
P = 10.0
ΔP = 1.0
p = (P, ΔP, T)

# The starting values for the initial value problem
u₀ = [60.0, 40.0, 0.0]

# The span over which to integrate - here the mass of catalyst
tspan = (0.0, 20.0)

# Create the ODEProblem object
prob = ODEProblem(rates!, u₀, tspan, p)

# Solve with the default solver
sol = solve(prob)

# Plot the result - the molar flows vs the mass of catalyst
plot(sol, leg=:right)
savefig("img/ODEmol.svg")

# Now, we want to plot the molar fractions...
# Copy over the independent values (sol.t) into our x array (optional)
x = sol.t

# For each entry in sol.u, sum up the molar flows - we get an array of values
# with the total molar flow at every point in the reactor
totflows = sum.(sol.u)

# Now divide the individual flows with the total. 
fracs = sol.u ./ totflows

# We get the same structure as sol.u - an array of arrays.
# We need to flatten this to plot it.
y = hcat(fracs...)'
plot(x,y, labels=["A" "B" "C"])
savefig("img/ODEfrac.svg")