using Plots

data1 = rand(5)
x = randn(10)
y = randn(10)

plot(
    plot(
        data1,
        label = "some data",
        title="Line plot",
        xlabel="sample",
        ylabel="value",
        linecolor = :red,
        linewidth = 3
        ),
    scatter(
        x, y, 
        title = "Scatter plot",
        label = "samples",
        xlabel="x",
        ylabel="y",
        markercolor = :blue,
        markershape = :diamond
        )
)

savefig("plotsexample1.svg")


data2 = rand(7)
data3 = rand(6)
plot(data2, label="Experiment 2", linestyle=:dashdotdot)
plot!(data3, label= "Experiment 3", linewidth = 2)
title!("Two series in a plot")
xlabel!("Sample number")
ylabel!("Sample size")

savefig("plotsexample2.svg")


f(x, y) = x*sin(x) - y^2 * cos(y)
x = range(0, 5, length=100)
y = range(0, 3, length=50)
z = @. f(x', y)
contour(z)
savefig("img/plotscontour.svg")
surface(x, y, z)
savefig("img/plotssurface.svg")
