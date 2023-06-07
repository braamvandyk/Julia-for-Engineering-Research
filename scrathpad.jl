using DataFrames

df = DataFrame(X = 1:3:1500, Y = repeat(1:100, outer=5), Z = repeat(1:100, inner=5))

filter(:Y => ==(50), df)


select(df, [:X, :Z])
select(df, Not(:Y))

df.A = 2 .* df.X
df.B = df.Y .+ df.Z
df.C = df.Z .^ 2
df

select(df, Cols(:A, Between(:X, :Z)))

df[:, Cols(:A, Between(:X, :Z))]

df2 = select(df, Cols(:A, Between(:X, :Z)))
df2

select!(df, Cols(:A, Between(:X, :Z)))