defmodule Test do

  def test1() do
    seq = [{:match, {:var, :x}, {:atm,:a}},
        {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},
        {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
        {:var, :z}]

  Eager.eval(seq)

  end

  def test2() do
    seq = [{:match, {:var, :x}, {:atm, :a}},
       {:case, {:var, :x},
          [{:clause, {:atm, :b}, [{:atm, :ops}]},
           {:clause, {:atm, :a}, [{:atm, :yes}]}
        ]} ]
    Eager.eval_seq(seq, Env.new())

  end

def test3() do
  seq = [{:match, {:var, :x}, {:atm, :a}},
            {:match, {:var, :f},
              {:lambda, [:y], [:x], [{:cons, {:var, :x}, {:var, :y}}]}},
            {:apply, {:var, :f}, [{:atm, :b}]}
        ]
  Eager.eval_seq(seq, Env.new())

end

def test4() do
  seq = [{:match, {:var, :x},
         {:cons, {:atm, :a}, {:cons, {:atm, :b}, {:atm, []}}}},
            {:match, {:var, :y},
              {:cons, {:atm, :c}, {:cons, {:atm, :d}, {:atm, []}}}},
            {:apply, {:fun, :append}, [{:var, :x}, {:var, :y}]}
          ]
  Eager.eval_seq(seq, Env.new())
end


end
