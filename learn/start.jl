# Calculate the gravitational acceleration grav_acc:
gc = 6.67e-11 # gravitational constant in m3/kg s2
mass_earth = 5.98e24 # in kg
radius_earth = 6378100 # in m
grav_acc = gc * mass_earth / radius_earth^2 # 9.8049 m/s2

# print in color
print_with_color(:red, "I love Julia!")

# d for integers:
@printf("%d\n", 1e5) #> 10000
x = 7.35679
# f = float format, rounded if needed:
@printf("x = %0.3f\n", x) #> 7.357
aa = 1.5231071779744345
bb = 33.97688693000695
@printf("%.2f %.2f\n", aa, bb) #> 1.52 33.98
# or to create another string:
str = @sprintf("%0.3f", x)
show(str) #> "7.357"
println()
# e = scientific format with e:
@printf("%0.6e\n", x) #> 7.56790e+00
# c = for characters:
@printf("output: %c\n", 'a') #> output: a
# s for strings:
@printf("%s\n", "I like Julia!")
# right justify:
@printf("%50s\n", "text right justified!")


# regular expression
email_pattern = r".+@.+"
input = "john.doe@mit.edu"
println(ismatch(email_pattern, input))

email_pattern = r"(.+)@(.+)"
input = "john.doe@mit.edu"
m = match(email_pattern, input)
println(m.captures)

m = match(r"(ju|l)(i)?(a)", "Julia")
println(m.match)
println(m.captures)
println(m.offset)
println(m.offsets)

replace("Juaaaaalia", r"u[\w]*l", "red")

str = "The sky is blue"
reg = r"[\w]{3,}" # matches words of 3 chars or more
r = matchall(reg, str)
show(r)
iter = eachmatch(reg, str)
for i in iter
  println("\"$(i.match)\" ")
end

# ranges and arrays
a = split("A,B,C,D", ",")
typeof(a)
show(a)
# initialize from a range
arr = collect(1:7) # sequential from 1 to 7
show(arr)
arr = collect(1:2:9) # from 1 to 9, step = 2
show(arr)
# define an array with 0 element of type Float64
arr1 = Float64[]

# common functions for arrays
# join the array elements to a string separated by a comma
join(arr, ", ")
# append
b = collect(1:7)
c = [100, 200, 300]
append!(b, c) #> now b is [1,2,3,4,5,6,7,100,200,300], array b is changed
# a function whose name ends in a ! changes its first argument
# append one element at the end
push!(b, 42)
# remove the last element
pop!(b)
# remove the first element
shift!(b)
# append one element on the front of the array
unshift!(b, 42)
# remove an element at a certain index
splice!(b, 8)
# check whether an array contains an element
in(42, b)
in(43, b)
# sort
sort(b) #> sort b, but b is not changed
println(b)
sort!(b) #> sort b, and now b is changed
println(b)
# loop over an array
for e in b
  print("$e ")
end
# if a dot (.) preceds operators such as .+ or .*, the operation is done by elements
a1 = [1, 2, 3]
a2 = [4, 5, 6]
a1 .* a2
# dot product
dot(a1, a2)
sum(a1 .* a2) #> the same
# repeat
repeat([1, 2, 3], inner=[2]) #> repeat each individual twice
repeat([1, 2, 3], outer=[2]) #> repeat the whole slice twice
# can check all methods related to array
methodswith(Array) #> 367 methods

# assign an array to another array
a = [1, 2, 4, 6]
a1 = a
show(a1)
a[4] = 0
show(a)
show(a1) #> both a and a1 changed, because they point to the object in the memory
# if you don't want this,
# you have to make a copy of the array
b = copy(a) #> or  b = deepcopy(a)
a[4] = 100
show(a)
show(b)
# arrays are mutable
a = [1, 2, 3]
function change_array(arr)
  arr[2] = 25
end
change_array(a)
println(a)

# convert an array of chars to string
arr = ['a', 'b', 'c']
join(arr)
utf32(arr)
string(arr) #> it does not
string(arr...) #> ... is the splice operator
# the contents of arr to be passed as individual arguments rather than passing arr as an array

# dates and time
# tic toc
start_time = time()
# long computation
time_elasped = round(time() - start_time, 2)
println("Time elapsed: $time_elasped")

# time in format
Libc.strftime(time())

# check 'Dates' package
d = Date(2016, 9, 7)
dt = DateTime(2016, 9, 7, 12, 30, 59, 1)
# some functions
Dates.year(d)
Dates.month(d)
Dates.week(d)
Dates.day(d)
Dates.dayofweek(d)
Dates.dayname(d)
Dates.daysinmonth(d)
Dates.dayofyear(d)
Dates.isleapyear(d)

# practice related to chars, strings, and array
# a newspaper headline
str = "The Gold and Blue Loses a Bit of Its Luster"
println(str)
nchars = length(str) #> length 43
println("The headline counts $nchars characters")
str2 = replace(str, "Blue", "Red")
# strings are immutable
println(str)
println(str2)
println("Here are the characters at position 25 to 30:")
subs = str[25:30]
println("-$(lowercase(subs))-") #-a bit -
println("Here are all the characters:")
for c in str
  println(c)
end
arr = split(str, ' ')
show(arr)
nwords = length(arr)
println("The headline counts $nwords words")
println("Here are all the words:")
for word in arr
  println(word)
end
arr[4] = "Red"
show(arr) #> arrays are mutable
println("Convert back to a sentence:")
nstr = join(arr, ' ')
println(nstr)

# working with arrays
println("arrays: Calculate sum, mean and stand deviation ")
arr = collect(1:100)
typeof(arr)
println(sum(arr))
println(mean(arr))
println(std(arr))


# functions
# example 1
function mult(x, y)
  println("x is $x and y is $y")
  if x == 1
    return y
  end
  return x*y
end

mult(2, 3)
mult(1, 4)

# example 2 - return multiple values
function multi(n, m)
  return n*m, div(n, m), n%m
end
multi(5, 2)
x, y, z = multi(5, 2)
show(x)
show(y)
show(z)

# varargs function, all none positional arguments are going to a tuple called args
function varargs(n, m, args...)
  println("arguments: $n $m $args")
end
varargs(1, 2, 3, 4)
varargs(1, 2) #> args can be empty

function varargs2(args...)
  println("arguments2: $args")
end

x = (3, 4)
varargs2(1, 2, x...) #> tuple x was spliced
x = [10, 11, 12]
varargs2(1, 2, x...) #> also works for array

# exmpale 3 - define argument types
function mult(x::Float64, y::Float64)
  return x * y
end
# can genrate different function with the same name
# Julia Jit will generate versions called methods for different argument types
# generic function with	2	method
function mult(x::Float64, y::Float64)
  return x * y
end

mult1(3.0, 4.0)
mult1(3, 4)

# one-line function syntax
mult(x, y) = x*y
f(x, y) = x^3 - y + x * y
f(3, 2)

# optional positional arguments
f(a, b = 5) = a + b
f(1)
f(2, 4)
f(1, 2, 4)

# optional keyword arguments
# order is irrelavent,
# be separated from the positional arguments by a semi-colon(;)
k(x; a1 = 1, a2 = 2) = x * (a1 + a2)
k(3, a2 = 3)
k(3, a2 = 3, a1 = 0)
k(3)

# when keyword arguments are splatted
function varargs3(; args...)
  args
end
varargs3(k1="name1", k2="name2", k3=7)

# anonymous function - lambda function
(x, y) -> x^3 - y
f = (x, ) -> x^3 - y

# a function can take a function as its argument
function numerical_derivative(ff, x, dx=0.01)
  derivative = (ff(x+dx) - ff(x-dx))/(2*dx)
  return derivative
end
ff = (x) -> 2x^2 + 30x + 9 #> a lambda function
println(numerical_derivative(ff, 1, 0.001))

# a function can return another fucntion as its value
# calculate the derivative of a function (which is also a function)
function derivative(ff)
  return function(x) #> return a lambda function
  #pick a small value for h
    h = x == 0 ? sqrt(eps(Float64)) : sqrt(eps(Float64)) * x
    xph = x + h
    dx = xph - x
    f1 = ff(xph) #> evaluate f at x + h
    f0 = ff(x)   #> evaluate f at x
    return (f1 - f0) / dx #> divide by h
  end
end

d1 = derivative(ff)
d1(2)

# counter function
function counter()
  n = 0
  () -> n += 1, () -> n = 0
end
# assign the returned function to variables
(addOne, reset) = counter()
n #> not defined outside the function
addOne() #> 1
addOne() #> 2
addOne() #> 3
reset()  #> 0
# n is captured in the anonymous functions
# it can only be manipulate by the functions, addOne and reset
# these two functions are said to be closed over the variable n
# and both have references to n
# they are so called closures

# currying
function add(x)
  println("x is $x")
  return function f(y)
      println("y is $y")
      return x + y
  end
end
add(1)(2)

# recursive function
fib(n) = n < 2 ? n : fib(n-1) + fib(n-2)
fib(10)
for i in 1:10
  println("$i ",fib(i))
end

# map, filter, and list comprehensions
map(x -> x*10, [1,2,3]) #> returns [10, 20, 30]
cubes = map(x -> x^3, [1:5])
show(cubes)
map(*, [1,2,3], [4,5,6])

# when function passed to map requires several lines
# two ways to deal with it
# write as an anonymous function - not recommended ??
map( x -> begin
            if x == 0 return 0
            elseif iseven(x) return 2
            elseif isodd(x) return 1
            end
          end, collect(-3:3))
# use a do block, do x statement creates an anonymous function
# with the argument x and passes it as the first argument to map
map(collect(-3:3)) do x
  if x == 0 return 0
  elseif iseven(x) return 2
  elseif isodd(x) return 1
  end
end

# filter
# only return elements which is evaluate as true
filter(n -> iseven(n), collect(1:10))

# list comprehensions - create an array
            
