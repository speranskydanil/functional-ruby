module FunctionalRuby
  ##
  # Example
  #  pow = -> x, y { x ** y }
  #  (pow >> 2)[3] #=> 8
  def apply_head(*first)
    -> *rest { self[*first.concat(rest)] }
  end

  alias >> apply_head
  alias % apply_head

  ##
  # Example
  #  pow = -> x, y { x ** y }
  #  (pow % 2)[3] #=> 9
  def apply_tail(*last)
    -> *rest { self[*rest.concat(last)] }
  end

  alias << apply_tail

  ##
  # Example
  #  f = -> x { x * x }
  #  g = -> x { x + 1 }
  #  (f * g)[3] #=> 16
  def compose(f)
    if respond_to? :arity and arity == 1
      -> *args { self[f[*args]] }
    else
      -> *args { self[*f[*args]] }
    end
  end

  alias * compose

  ##
  # Example
  #  f = -> x { x * x }
  #  d = [1, 2, 3]
  #  f | d #=> [1, 4, 9]
  def map(enum)
    enum.to_enum.map &self
  end

  alias | map

  ##
  # Example
  #  f = -> a, e { a * e }
  #  d = [1, 2, 3]
  #  f <= d #=> 6
  def reduce(enum)
    enum.to_enum.reduce &self
  end

  alias <= reduce

  ##
  # Example
  #  fact = +-> n { n < 2 ? 1 : n * fact[n - 1] }
  #  t = Time.now; fact[1000]; Time.now - t #=> 0.018036605
  #  t = Time.now; fact[1000]; Time.now - t #=> 2.6761e-05
  def memoize
    cache = {}

    -> *args do
      cache.fetch(args) do
        cache[args] = self[*args]
      end
    end
  end

  alias +@ memoize

  ##
  # Example
  #  f = -> x { x * x }
  #  g = -> x { x + 1 }
  #  (f + g)[3] #=> 13
  # def +(f)
  #   -> *args { self[*args] + f[*args] }
  # end

  ##
  # Example
  #  f = -> x { x * x }
  #  g = -> x { x + 1 }
  #  (f - g)[3] #=> 5
  # def -(f)
  #   -> *args { self[*args] - f[*args] }
  # end

  ##
  # Example
  #  f = -> x { x * x }
  #  g = -> x { x + 1 }
  #  (f / g)[3] #=> 2
  # def /(f)
  #   -> *args { self[*args] / f[*args] }
  # end

  ##
  # Example
  #  f = -> x { x * x }
  #  g = -> x { x + 1 }
  #  f.mult(g)[5] #=> 36
  def mult(f)
    -> *args { self[*args] * f[*args] }
  end

   %w(+ - /).each do |meth|
      define_method(meth) do |fn, *args|
        -> *args { self[*args].send(meth.to_sym, fn[*args]) }
      end
    end
end

class Proc
  include FunctionalRuby
end

class Method
  include FunctionalRuby
end

class Symbol
  def +@
    method(self)
  end
end

