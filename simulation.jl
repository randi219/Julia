include("/home/randi/randi/julia2016/Julia/Newton_method_logistic.jl")

"""
check Newton's method
compare to exist function in pkg GLM
the result is identical
"""

# simulation - logistic regression
M = [1.0 0.5;
     0.5 1.0]
nobs = 1000
nvars = size(M, 1)
L = chol(M)

#Pkg.add("Distributions")
#Pkg.update()
#workspace()
using Distributions

srand(12345)

r = *(L' , reshape(rand(Normal(), nobs*nvars), nvars, nobs))
r = r'
z = *(r, [2 1]') + 1
y = Array(Int64, 1, nobs)
for i = 1:nobs
  y[i] = rand(Binomial(1, 1/(1+exp(-1*z[i]))),1)[1]
end


#Pkg.add("GLM")
using GLM

y1 = Array(Bool, 1, nobs)
for i = 1:length(y)
  y1[i] = convert(Bool, y[i])
end
y1

#data = DataFrame(Y=vec(y), X1=vec(r[:,1]), X2=vec(r[:,2]))
#Pkg.add("DataFrames")
using DataFrames
dat = convert(DataFrame, r) #> convert array to dataframe
dat[:Y] = @data(vec(y1))

fit1 = glm(Y ~ x1 + x2, dat, Binomial(), LogitLink())
fit1
vcov(fit1)
est1 = coef(fit1)

dat1 = dat[:, [:Y, :x1, :x2]]
dat1[:, :Y] = 1.0
dat1 = convert(Array, dat1)

h1 = logistic_hessian(vec(y), dat1, est1)
inv(-1*h1)


w0 = [0.0, 0.0, 0.0]
fitnm = newton_method(logistic_loglik, logistic_gradient, logistic_hessian,
                      w0, vec(y), dat1)
fitnm

logistic_loglik(vec(y), dat1, est1)
est1

fitnm[1]
fitnm[2]
fitnm[3]
sqrt(diag(inv(-1*fitnm[4])))

fit1
