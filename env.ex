defmodule Env do

  def new() do [] end

  def add(id, str, env) do [{id, str} | env] end

  def lookup(id, env) do EnvList.lookup(env, id) end

  def remove(ids, env) do
    List.foldr(ids, env, fn(id, env) ->
      EnvList.remove(env, id)
    end)
  end

  def closure([], env) do env end
  def closure([var|vars], env) do
    case lookup(var, env) do
      nil -> :error
      {_, _} -> closure(vars, env)
    end
  end

  def args([], _, env) do env end
  def args([param|params], [str|strs], env) do
    env = add(param, str, env)
    args(params, strs, env)
  end

end
