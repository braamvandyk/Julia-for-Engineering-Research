using Optimization, OptimizationOptimJL, OptimizationBBO, BenchmarkTools

rosenbrock(u, p) = (p[1] - u[1])^2 + p[2] * (u[2] - u[1]^2)^2
u0 = zeros(2)
p = [1.0, 100.0]

# Use NelderMead from Optim.jl, linked in via OptimizationOptimJL

prob = OptimizationProblem(rosenbrock, u0, p)
@btime sol = solve(prob, NelderMead())

# 945.400 μs (3309 allocations: 168.98 KiB)
# u: 2-element Vector{Float64}:
#  0.9999634355313174
#  0.9999315506115275

# Use Adaptive Differential Evolution method adaptive_de_rand_1_bin_radiuslimited from
# BlackBoxOptim.jl, via OptimizationBBO. This method needs a bounded search area.

prob = OptimizationProblem(rosenbrock, u0, p, lb = [-1.0, -1.0], ub = [1.0, 1.0])
sol = solve(prob, BBO_adaptive_de_rand_1_bin_radiuslimited())

# 13.260 ms (153718 allocations: 5.69 MiB)
# u: 2-element Vector{Float64}:
#  0.9999999999999495
#  0.9999999999998918