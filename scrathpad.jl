using DataFrames

df = DataFrame(X = 1:3:1500, Y = repeat(1:100, outer=5), Z = repeat(1:100, inner=5))




select(df, [:X, :Z])
select(df, Not(:Y))

df.A = 2 .* df.X
df.B = df.Y .+ df.Z
df.C = df.Z .^ 2
df

describe(df)

select(df, Cols(:A, Between(:X, :Z)))

df[:, Cols(:A, Between(:X, :Z))]

df2 = select(df, Cols(:A, Between(:X, :Z)))
df2

select!(df, Cols(:A, Between(:X, :Z)))

filter(:X => <=(10), df)
df[df.X .<= 10, :]


select(df, :X, :X => cumsum => :cumX)
select(df, [:X, :Y], [:X, :Y] => ByRow((x, y) -> sin(x)*cos(y)) => :sinXcosY)
select(df, AsTable(:) => ByRow(extrema) => [:min, :max])
transform(df, AsTable(:) => ByRow(extrema) => [:min, :max])

df = DataFrame(
    Names = ["Tom", "Dick", "Harry"], 
    AddressLine1 = ["2 Maple Drive", "4 Oak Street", "6 Pine Road"],
    AddressLine2 = ["Hopetown", "Smallville", "Metropolis"],
    AddressZip = [1234, 2345, 3456]
)

df[:, r"Addr"]