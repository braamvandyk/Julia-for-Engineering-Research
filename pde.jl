using ModelingToolkit, Clapeyron

const N = 3

# function viscosity(T, P, n)


eos = SRK(["propylene", "propane", "hydrogen"])

@parameters D, ϵ
@variables z uₛ(z) P(z) T(z) (ṅ(z))[1:N]
d = Differential(z)

eqs = [
    Aᵣ ~ π/4*D^2

    D(P) = 

    uₛ ~ V̇/Aᵣ
    


    ]
