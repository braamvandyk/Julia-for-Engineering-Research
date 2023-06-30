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