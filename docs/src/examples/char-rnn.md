# Char RNN

This walkthrough will take you through a model like that used in [Karpathy's 2015 blog post](http://karpathy.github.io/2015/05/21/rnn-effectiveness/), which can learn to generate text in the style of Shakespeare (or whatever else you may use as input). `shakespeare_input.txt` is [here](http://cs.stanford.edu/people/karpathy/char-rnn/shakespeare_input.txt).

```julia
using Flux
import StatsBase: wsample
```

Firstly, we define up front how many steps we want to unroll the RNN, and the number of data points to batch together. Then we create some functions to prepare our data, using Flux's built-in utilities.

```julia
nunroll = 50
nbatch = 50

getseqs(chars, alphabet) =
  sequences((onehot(Float32, char, alphabet) for char in chars), nunroll)
getbatches(chars, alphabet) =
  batches((getseqs(part, alphabet) for part in chunk(chars, nbatch))...)
```

Because we want the RNN to predict the next letter at each iteration, our target data is simply our input data offset by one. For example, if the input is "The quick brown fox", the target will be "he quick brown fox ". Each letter is one-hot encoded and sequences are batched together to create the training data.

```julia
input = readstring("shakespeare_input.txt");
alphabet = unique(input)
N = length(alphabet)

# An iterator of (input, output) pairs
train = zip(getbatches(input, alphabet), getbatches(input[2:end], alphabet))
# We will evaluate the loss on a particular batch to monitor the training.
eval = tobatch.(first(drop(train, 5)))
```

Creating the model and training it is straightforward:

```julia
model = Chain(
  Input(N),
  LSTM(N, 256),
  LSTM(256, 256),
  Affine(256, N),
  softmax)

m = tf(unroll(model, nunroll))

# Call this to see how the model is doing
evalcb = () -> @show logloss(m(eval[1]), eval[2])

@time Flux.train!(m, train, η = 0.1, loss = logloss, cb = [evalcb])

```

Finally, we can sample the model. For sampling we remove the `softmax` from the end of the chain so that we can "sharpen" the resulting probabilities.

```julia
function sample(model, n, temp = 1)
  s = [rand(alphabet)]
  m = unroll1(model)
  for i = 1:n-1
    push!(s, wsample(alphabet, softmax(m(unsqueeze(onehot(s[end], alphabet)))./temp)[1,:]))
  end
  return string(s...)
end

sample(model[1:end-1], 100)
```

`sample` then produces a string of Shakespeare-like text. This won't produce great results after only a single epoch (though they will be recognisably different from the untrained model). Going for 30 epochs or so produces good results.

Trained on [a dataset from base Julia](https://gist.githubusercontent.com/MikeInnes/c2d11b57a58d7f2466b8013b88df1f1c/raw/4423f7cb07c71c80bd6458bb94f7bf5338403284/julia.jl), the network can produce code like:

```julia
function show(io::IO, md::Githompty)
    Buffer(jowerTriangular(inals[i], initabs_indices), characters, side, nextfloat(typeof(x)))
    isnull(r) && return
    start::I!
    for j = 1:length(b,1)
        a = s->cosvect(code)
        return
    end
    indsERenv | maximum(func,lsg))
    for i = 1:last(Abjelar) && fname (=== nothing)
        throw(ArgumentError("read is declave non-fast-a/remaining of not descride method names"))
    end
    if e.ht === Int
        # update file to a stroducative, but is decould.
        # xna i -GB =# [unsafe_color <c *has may num 20<11E 16/s
        tuple | Expr(:(UnitLowerTriangular(transpose,(repl.ptr)))
        dims = pipe_read(s,Int(a)...)
    ex,0 + y.uilid_func & find_finwprevend(msg,:2)
    ex = stage(c)
    # uvvalue begin
    end
end
```
