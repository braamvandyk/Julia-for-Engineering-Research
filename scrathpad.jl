using Plots

f1(x, y) = x*sin(x) - y^2 * cos(y)
f2(x, y) = x*cos(x) - y^2 * sin(y)
x = range(0, 5, length=100)
y = range(0, 3, length=50)
z1 = @. f1(x', y)
z2 = @. f2(x', y)
contour(z1)
contour!(z2)


surface(x, y, z1)
contour!(x, y, z1)



N = 10

function primesieve(N=2_000_000)
    # Create the list, setting even numbers to false already
    primes = isodd.(1:N) # This allocates an array
    primes[1] = false # Also exclude 1
    primes[2] = true # And remember that 2 is prime!

    # Start the sieve at 3
    nextval = 3
    while nextval <= N ÷ 2 # ÷ does integer division
        if primes[nextval] # Still in the list?
            primes[2*nextval:nextval:N] .= false # Then remove all multiples
        end
        nextval += 1 # Start looking for next entry in list
        while !primes[nextval] && nextval <= N
            nextval += 1
        end
    end

    return (1:N)[primes] # This allocates an array
end

using BenchmarkTools
@btime primesieve()

function primesieve!(primes)
    N = length(primes)
    # Create the list, setting even numbers to false already
    primes[1] = false # Exclude 1
    primes[2] = true # And remember that 2 is prime!

    # Start the sieve at 3
    nextval = 3
    while nextval <= N ÷ 2 # ÷ does integer division
        if primes[nextval] # Still in the list?
            primes[2*nextval:nextval:N] .= false # Then remove all multiples
        end
        nextval += 1 # Start looking for next entry in list
        while !primes[nextval] && nextval <= N
            nextval += 1
        end
    end

    return primes
end

N = 2_000_000
primes = isodd.(1:N)
idx = primesieve!(primes)
primes = (1:N)[idx]
sum(primes)

using BenchmarkTools
N = 2_000_000

startval = isodd.(1:N)
@btime primesieve!($primes) setup=(primes = copy(startval))
primes = (1:N)[idx]
sum(primes)