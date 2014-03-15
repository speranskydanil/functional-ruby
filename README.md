# Functional Ruby

## Installing

    gem install fn-ruby

    require 'functional-ruby'

There are some utils for working in ruby in functional style.

### Currying, first parameters (apply_head, >>, %)

    pow = -> x, y { x ** y }
    (pow % 2)[3] #=> 8

### Currying, last parameters (apply_tail, <<)

    pow = -> x, y { x ** y }
    (pow << 2)[3] #=> 9

### Composing (compose, *)

    f = -> x { x * x }
    g = -> x { x + 1 }
    (f * g)[3] #=> 16

### Mapping (map, |)

    f = -> x { x * x }
    d = [1, 2, 3]
    f | d #=> [1, 4, 9]

### Reducing (reduce, <=)

    f = -> a, e { a * e }
    d = [1, 2, 3]
    f <= d #=> 6

### Memoization (memoize, +@)

You can make your function memoized just by typing `+` before it.

    fact = +-> n { n < 2 ? 1 : n * fact[n - 1] }
    t = Time.now; fact[1000]; Time.now - t #=> 0.018036605
    t = Time.now; fact[1000]; Time.now - t #=> 2.6761e-05

### Arithmetic

You can use usual arithmetic operators.

##### +

    f = -> x { x * x }
    g = -> x { x + 1 }
    (f + g)[3] #=> 13

##### -

    f = -> x { x * x }
    g = -> x { x + 1 }
    (f - g)[3] #=> 5

##### /

    f = -> x { x * x }
    g = -> x { x + 1 }
    (f / g)[3] #=> 2

##### mult

The `*` method is used for composing so we provide symbolic name for this.

    f = -> x { x * x }
    g = -> x { x + 1 }
    f.mult(g)[5] #=> 36

### Working with methods

The `Symbol#@+` method is overloaded.


    def sqr(x)
      x * x
    end

    def inc(x)
      x + 1
    end

    (+:sqr * +:inc)[3] #=> 16

