using ModelingToolkit, DifferentialEquations

#=
    Differential molar balance for i
        ∂Cᵢ/∂t = Dₐ*∂²Cᵢ/∂z² - ∂(uₛCᵢ)/∂z + ∑(reaction j)νᵢⱼrᵢ
        Dₐ(z) = uₛ(z)l/Peₐ (l = characteristic length = L = reactor length)
        uₛ(z) = V̇/A = ṅRT/P(z)

    Dankwerts boundary conditions
        z = 0   uₛCᵢ(z = 0) - Dₐ*dCₜₒₜ/dz(z=0) = uₛCᵢ(feed)
        z = L   dCᵢ/dz(z=L) = 0

    Cₜₒₜ = P/RT
    Cᵢ = nᵢ/nₜₒₜ*Cₜₒₜ

    Reaction:
    A + 2B -> C
    r = k*pA*pC / (1 + Ka*pA + Kb*pB)
    rA = -r
    rB = -2r
    rC = +r
=#

const N = 3 # Number of species
const ν = [-1.0, -2.0, 1.0]
const R₀ = 8.314
const Cfeed = [1.0, 1.0, 0.0]
const L = 2.0

@parameters T Dₐ k Ka Kb
@variables z u(z) C(z)[1:N] p(z)[1:N] r(z)[1:N]

Dz = Differential(z)
Dzz = Differential(z)^2

# 1D ADPFR with Dankwerts boundary conditions

# Cᵢ = Pᵢ/R₀T
presconc = [C[i] ~ p[i]/R₀/T for i in 1:N]

# A + 2B -> C
# r = k*pA*pC / (1 + Ka*pA + Kb*pB)
reactions = [r[i] ~ ν[i] * (k * p[1] * p[2] / (1 + Ka*p[1] + Kb*p[2])) for i in 1:N]

# Superficial velocity
#TODO Add equation for u(z) = ...

# ∂Cᵢ/∂t = 0 = Dₐ*∂²Cᵢ/∂z² - ∂(uCᵢ)/∂z + ∑(reaction j)νᵢⱼrᵢ
#TODO Change to PDE version
axdisp = [0 ~ Dₐ*Dzz(C[i]) - Dz(u*C[i]) + r[i] for i in 1:N]
 
eqs = vcat(presconc, reactions, axdisp)

expanded_eqs = expand_derivatives.(eqs)

# Dankwerts boundary conditions
#     z = 0   uₛCᵢ(z = 0) - Dₐ*dCₜₒₜ/dz(z=0) = uₛCᵢ(feed)
#     z = L   dCᵢ/dz(z=L) = 0
#TODO Change to Dankwerts
bcs = [
    u(t,0) ~ 0.,# for all t > 0
    u(t,1) ~ 0.,# for all t > 0
    u(0,x) ~ x*(1. - x), #for all 0 < x < 1
    Dt(u(0,x)) ~ 0.
] #for all  0 < x < 1]

# Space and time domains
domains = [
    t ∈ (0.0,1.0),
    z ∈ (0.0,1.0)
]

@named reactorsys = ODESystem(expanded_eqs, bcs, domains)