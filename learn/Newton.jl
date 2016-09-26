# loglikelihood function - logistic regression model
function logistic_loglik(y::Vector{Int64},
                         X::Array{Float64},
                         Beta::Vector{Float64})
  n = length(y)
  res = zeros(n)
  for i = 1:n
    res[i] = y[i] * vecdot(X[i,:], Beta) - log(1 + exp(vecdot(X[i,:], Beta)))
  end
  return sum(res)
end



# test function
arr1 = [1.0 2 3 4 ;
        5 6 7 8 ;
        1 2 3 4 ;
        5 6 7 8]
v = collect(1:4.0)
b = [0,1,0,1]

logistic_loglik(b, arr1, v)


# gradient
function logistic_gradient(y::Vector{Int64},
                           X::Array{Float64},
                           Beta::Vector{Float64})
  n = length(y)
  nbeta = length(Beta)
  g = zeros(nbeta)

  for j = 1:nbeta
    res = zeros(n)
    for i = 1:n
      res[i] = X[i,j] * (y[i] - exp(vecdot(X[i,:], Beta))/(1 + exp(vecdot(X[i,:], Beta))))
    end
    g[j] = sum(res)
  end

  return g
end


logistic_gradient(b, arr1, v)



# hessian matrix
function logistic_hessian(y::Vector{Int64},
                           X::Array{Float64},
                           Beta::Vector{Float64})
  n = length(y)
  nbeta = length(Beta)
  h = Array(Float64, nbeta, nbeta)

  for k = 1:nbeta
    for j = 1:nbeta
      res = zeros(n)
      for i = 1:n
        res[i] = -1 * X[i,k] * X[i,j] *
                  exp(vecdot(X[i,:], Beta)) / (1 + exp(vecdot(X[i,:], Beta)))^2
      end
      h[k,j] = sum(res)
    end
  end

  return(h)
end




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
Pkg.add("DataFrames")
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






# Newton's method
function newton_method(f::Function, fp1::Function, fp2::Function, b0, y, X;
                       tolerance=1e-3, maxiter=100)
  b = b0
  oldf = f(y, X, b)
  iter = 0

  for i = 1:maxiter
    iter = iter + 1
    #println(iter)
    newb = b - *(inv(fp2(y, X, b)), fp1(y, X, b))
    #println(newb)
    newf = f(y, X, newb)
    #println(newf)
    relative_change = abs(newf - oldf) / oldf
    #println(relative_change)
    if abs(relative_change) > tolerance
      b = newb
      oldf = newf
    else
      break
    end
  end

  iter < maxiter || error("Did not converge in ", maxiter, " steps.")

  loglik = oldf
  hessian = fp2(y, X, b)

  return b, iter, hessian
end


w0 = [0.0, 0.0, 0.0]
fitnm = newton_method(logistic_loglik, logistic_gradient, logistic_hessian,
                      w0, vec(y), dat1)
fitnm

logistic_loglik(vec(y), dat1, est1)
est1

fitnm[1]
fitnm[2]
sqrt(diag(inv(-1*fitnm[3])))

fit1
