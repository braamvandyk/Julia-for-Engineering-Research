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