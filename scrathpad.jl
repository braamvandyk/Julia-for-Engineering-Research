using CSV, DataFrames, Statistics

df = CSV.read(raw"D:\JuliaCode\KaggleData\food_ingredients_and_allergens.csv", DataFrame; normalizenames=true)
select!(df, [:Food_Product, :Allergens])

allAllergens = String[]
for row in eachrow(df)
    allergens = row.Allergens
    for s in eachsplit(allergens, ", ")
        push!(allAllergens, s)
    end
end
unique!(allAllergens)

for allergen in allAllergens
    transform!(df, :Allergens => ByRow(s -> contains(string(s), allergen)) => Symbol(allergen))
end


gdf = groupby(df, [:Almonds, :Wheat])
for (keys, sdf) in pairs(gdf)
    println("Number of foods with $keys: $(nrow(sdf))")
end

combine(gdf, nrow, proprow)




df = DataFrame(X = 1:50, Y = repeat(1:2, outer=25), Z = repeat(2:2:10, inner=10))
gdf = groupby(df, [:Y, :Z])
counts = select(gdf, nrow, :X => mean)

function f(x, y=2, z=4)
    println(x)
    println(y)
    println(z)
end

f(2)

function f(x; y=2, z=4)
    println(x)
    println(y)
    println(z)
end

f(2)

f(2, z=3)


function isnotnegative(x)
    x >= 0
end

function trychangeing(x)
    println("Passed value: $x")
    x = 10
    println("Local value: $x")
end

x = -1
trychangeing(x)
println("Value at call site: $x")

a = [1]
trychangeing(a)
println("Value at call site: $a")

function canchange!(x)
    println("Passed value: $x")
    x[1] = -10
    println("Local value: $x")
end

a = [1, 2, 3]
canchange!(a)
println(a)


function sqr_two(a, b)
    return a^2, b^2
end

a2, b2 = sqr_two(2, 3)
println("a2 = $a2 and b2 = $b2.")


function confused(a, b, c)
    println("a is $a")
    println("b is $b")
    println("c is $c")
end

x = [1, 2, 3]
confused(x...)

x = [1, 2, 3, 4]
confused(x...)

