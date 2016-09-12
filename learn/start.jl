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
arr = Float64[x^2 for x in 1:4]
cubes = [x^3 for x in 1:5]
# create a array
mat1 = [x+y for x in 1:2, y in 1:3] #> 2x3 array
table10 = [x*y for x=1:10, y=1:10] #> 10x10 array
arrany = Any[i*2 for i in 1:5]

# generic functions
f(n, m) = "base case"
f(n::Number, m::Number) = "n and m are both numbers"
f(n::Number, m) = "n is a number"
f(n, m::Number) = "m is a number"
f(n::Integer, m::Integer) = "n and m are both integers"
#> now generic function f has 5 methods
f(1.5, 2)
f(1, "bar")
f(1, 2)
f("foo", [1,2])
f("foo", "bar")
f(n::Float64, m::Integer) = "n is a float and m is an integer"
f(1.5, 2)
# quick overview of all version of a function
methods(f)
methods(+)



## control flow
# conditional evaluation
var = 7
if var > 10
  println("var has value $var and is bigger than 10.")
elseif var < 10
  println("var has value $var and is smaller than 10.")
else
  println("var has value $var and is 10.")
end

a = 10
b = 15
z = if a > b a
else     b
end
# can be simplified using ternary operator
z = a > b ? a : b #>the ternary operator can be chained

# Using short-circuit evaluation
# the statements with if only are often written as follows
# if <cond> <statement> end is written as <cond> && <statement>
# if !<cond> <statement> end is written as <cond> || <statement>
function sqroot(n::Int)
  n >= 0 || error("n must be non-negative") #> stop code execution
  n == 0 && return 0
  sqrt(n)
end
sqroot(4)
sqroot(0)
sqroot(-6)

# for loop
for n = 1:10
  print(n^3, "\t")
end
for n in 1:10
  print(n^3, " ")
end

arr = [x^2 for x in 1:10]
for i = 1:length(arr)
  println("the $i-th element is $(arr[i])")
end
# a more elegant way is using enumerate function
for (ix, val) in enumerate(arr)
  println("the $ix-th element is $val") #> ix - index; val - value
end

# nested for loop
for n = 1:5
  for m = 1:5
    println("$n * $m = $(n*m)")
  end
end
# combine into a single outer loop
for n = 1:5, m = 1:5
  println("$n * $m = $(n*m)")
end


# while loop
a = 10; b = 15
while a < b
  # body: process(a)
  println(a)
  a += 1
end
# loop over an array
arr = [1, 2, 3, 4]
while !isempty(arr)
  print(pop!(arr), ", ")
end

# break
a = 10; b = 150
while a < b
  # process(a)
  println(a)
  a += 1
  if a >= 50
    break
  end
end

# search for a given element in an array
arr = rand(1:10, 10)
println(arr)
searched = 4
for (ix, curr) in enumerate(arr)
  if curr == searched
    println("The searched element $searched occurs on index $ix")
    break
  end
end

# continue statement
# skip one (or more) loop repetitions
for n in 1:10
  if 3 <= n <= 6
    continue # skip current iteration
  end
  println(n)
end

# a do-while loop
while true
  #code
  condition || break
end


# exception
# throw / rethrow
# error, warn, info
# try-catch-finally construct
a = []
try
  pop!(a)
catch ex
  println(typeof(ex))
  showerror(STDOUT, ex)
end


# scope - globle vs. local
x = 9
function funscope(n)
  x = 0 #> x is in the local scope of the function
  for i = 1:n
    local x #> x is local to the for loop
    x = i + 1
    if (x == 7)
      println("This is the local x in for: $x") #> 7
    end
  end
  x
  println("This is the local x in funscope: $x") #> 0
  global x = 15
end
funscope(10)
println("This is the global x: $x") #> 15

# let
# statements allocate new variable bindings each time they run
anon = cell(2) # return 2-element array{Any, 1}: #undef #undef
for i = 1:2
  anon[i] = () -> println(i)
  i += 1
end
anon[1]()
anon[2]()
# What if you wanted them to stick to the value
# of i at the moment of their creation
anon = cell(2)
for i = 1:2
  let i = i
    anon[i] = () -> println(i)
  end
  i += 1
end
anon[1]()
anon[2]()

begin
  local x = 1
  let
    local x = 2
    println(x) #> 2
  end
  x
  println(x) #> 1
end

# The for loops and comprehensions differ in the way
# they scope an iteration variable
i = 0
for i in 1:10
end
println(i) #> 10
# After executing a comprehension, it is still 0
i = 0
[i for i = 1:10]
println(i) #> 0


# tasks
# produce function - similar to yield in Python
# fibonacci numbers
function fib_producer(n)
  a, b = (0, 1)
  for i = 1:n
    produce(b)
    a, b = (b, a + b)
  end
end
# fib_producer(5) - wrong way
# envelop it as a task that takes a function with no arguments
tsk1 = Task( () -> fib_producer(10) )
consume(tsk1)
consume(tsk1)
consume(tsk1)
consume(tsk1)
consume(tsk1)
consume(tsk1)
consume(tsk1)
consume(tsk1)
consume(tsk1)
consume(tsk1)
consume(tsk1) #> nothing # tsk done

# or can use for loop
for n in tsk1
  println(n)
end

# use a macro
tsk1 = @task fib_producer(10)
for n in tsk1
  println(n)
end


## collection types
[1, 2, 3] #> column vector
[1 2 3] #> row vector
Array{Int64, 1} == Vector{Int64} #> true
Array{Int64, 2} == Matrix{Int64} #> true
# create Matrix
m1 = [1 2; 3 4]
m1[2, 1]
m2 = rand(3, 5)
ndims(m2)
size(m2)
size(m2, 1)
size(m2, 2)
length(m2)
idm = eye(3)
idm[1:end, 2]
idm[:, 2]
idm[2, :]
idmc = idm[2:end, 2:end]
jarr = fill(Array(Int64, 1), 3)
jarr[1] = [1, 2]
jarr[2] = [1, 2, 3, 4]
jarr[3] = [1, 2, 3]
jarr
m1'
m1 * m1'
m1 .* m1' #> element-wise muliplication
inv(m1)
m1 * inv(m1) #> identity Matrix
v = [1., 2., 3.]
w = [2., 4., 6.]
hcat(v, w)
vcat(v, w)
a = [1 2; 3 4]
b = [5 6; 7 8]
c = [a; b] #> 4x2
c = [a, b] #> the same, but return warnings
reshape(1:12, 3, 4)
a = rand(3, 3)
reshape(a, (9,1))
reshape(a, (2,2)) #> error
# copy a array
x = cell(2)
x[1] = ones(2)
x[2] = trues(3)
x
a = x #> point to same object in memory
b = copy(x) #> shadow copy with references to the contained arrays
c = deepcopy(x) #> complete copy of the values
# now if we change x:
x[1] = "julia"
x[2][1] = false
x
a #> the same as changed x
is(a, x) #> true
b #> The b value retains the changes in a contained array of x, but not if one of the contained arrays becomes another array.
is(b, x) #> false
c #> the origin x
is(c, x) #> false


# tuple
# tuple is immutable
a, b, c, d = 1, 22.0, "word", 'x'
t1 = a, b, c, d = 1, 22.0, "word", 'x'
t1
typeof(t1)
() #> empty tuple
(1, ) #> one element tuple
for i in t1
  println(i)
end
# unpacked
x, y = t1
x
y

# dictionary - hash
# two elements tuple - (key, value)
# key must be unique
# d1 = [1 => 4.2, 2 => 5.3] #> old usage
d1 = Dict(1 => 4.2, 2 => 5.6)
# note: all keys must have the same type, so is the values

# dynamic version
# d1 = {1 => 4.2, 2 => 5.6} #> old syntax
d1 = Dict{Any, Any}(1 => 4.2, 2 => 5.6)
d2 = Dict{Any, Any}("a" => 1, (2,3) => true)

# use symboles as keys, symboles are immutable
d1 = Dict(:A => 100, :B => 200)
d1[:A]
d1[:Z] #> keyerror
get(d1, :Z, 999) #> use 999 instead of an error
d1[:C] = 300
d1
length(d1)

# empty dictionary
d4 = Dict()
d5 = Dict{Float64, Int64}()
d5["c"] = 100 #> error 'convert', worong type of keys
delete!(d1, :B)

for k in keys(d1)
  println(k)
end
:A in keys(d1)
haskey(d1, :A)
collect(keys(d1))
vi = values(d1)
for v in values(d1)
  println(v)
end

keys1 = ["bach", "allen", "obama"]
values1 = [1685, 1935, 1961]
d5 = Dict(keys1, values1) #> old syntax
d5 = Dict(zip(keys1, values1))
for (k, v) in d5
  println("$k was born in $v")
end
# alternative
for p in d5
  println("$(p[1]) was born in $(p[2])")
end

dpaires = ["a", 1, "b", 2, "c", 3]
d6 = [dpaires[i] => dpaires[i+1] for i in 1:2:length(dpaires)]
d6 = (AbstractString => Int64)[dpaires[i] => dpaires[i+1] for i in 1:2:length(dpaires)]

function showfactor(n)
  d = factor(n)
    println("factors for $n")
    for (k, v) in d
      print("$k^$v\t")
    end
end

@time showfactor(3752)

# sets
# order doesn't matter, elements have to be unique
s1 = Set({11, 14, 13, 7, 14, 11}) #> old syntax
s1 = Set(Any[11, 14, 13, 7, 14, 11])
s1 = Set(Int64[11, 14, 13, 7, 14, 11])

s1 = Set(Any[11, 25])
s2 = Set(Any[25, 3.14])
union(s1, s2)
intersect(s1, s2)
setdiff(s1, s2)
setdiff(s2, s1)
issubset(s1, s2)
issubset(s1, Set(Any[25,4,11]))
push!(s1, 33) #> add one element
in(33, s1)
Set([1,2,3])
Set({[1,2,3]}) #> not right

# checking an element is present is independent of the size of the set
x1 = Set(collect(1:100))
@time 2 in x1 #> 0.000007
x2 = Set(collect(1:1000000))
@time 2 in x1 #> 0.000007



# example project - word frequecy
# 1. read in text file as a string
str = readall("start.jl")
# 2. replace non alphabet characters from text with a space
nonalpha = r"(\W\s?)"
str = replace(str, nonalpha, ' ')
digits1 = r"(\d+)"
str = replace(str, digits1, ' ')
# 3. split text in words
word_list = split(str, ' ')
# 4. make a dictionary with the words and count their frequecies
word_freq = Dict{AbstractString, Int64}()
for word in word_list
  word = strip(word)
  if isempty(word) continue end
  haskey(word_freq, word) ?
    word_freq[word] += 1 :
    word_freq[word] = 1
end
# sort the words (the keys) and print out the frequecies:
println("Word: frequecy \n")
words = sort!(collect(keys(word_freq)))
for word in words
  println("$word: $(word_freq[word])")
end
