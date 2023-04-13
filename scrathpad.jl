using NonlinearSolve

"""
    Calculate the difference between the vapour pressure and 1atm
"""
function f(u, p)
    A, B, C = p
    return 10^(A - B/(u + C)) - 1.01325
end

# Antoine parameters from NIST
# 1. Liu and Lindsay, 1970
pLL = (3.55959, 643.748, -198.043)
# 2. Stull, 1947
pS = (4.6543, 1435.264, -64.848)

# Initial guess
u0 = 373.15

probLL = NonlinearProblem(f, u0, pLL)
solLL = solve(probLL, NewtonRaphson())
f(solLL.u, pLL)

probS = NonlinearProblem(f, u0, pS)
solS = solve(probS, NewtonRaphson())
f(solS.u, pS)

uspan = (370.0, 380.0)

probLL2 = IntervalNonlinearProblem(f, uspan, pLL)
solLL2 = solve(probLL2, Falsi())
f(solLL2.u, pLL)

probS2 = IntervalNonlinearProblem(f, uspan, pS)
solS2 = solve(probS2, Falsi())
f(solS2.u, pS)

\epsilon