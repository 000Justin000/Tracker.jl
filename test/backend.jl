xs = rand(20)

d = Affine(20, 10)

dt = tf(d)

@test d(xs) ≈ dt(xs)
