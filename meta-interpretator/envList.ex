defmodule EnvList do

  def new() do [] end

  def add([], key, value) do [{key, value}] end #key-value pairs added to an empty list
  def add([{key, _}|map], key, value) do [{key, value}|map] end #if there already is an association of the key the value is changed.
  def add([ass|map], key, value) do #head that does not match is added to the left side of the list
    [ass|add(map, key, value)]
  end

  def lookup([], _key) do nil end
  def lookup([{key, value}|_], key) do {key, value} end
  def lookup([_|map], key) do lookup(map, key) end

  def remove([], _key) do [] end
  def remove([{key, _}|map], key) do map end
  def remove([kv|map], key) do [kv|remove(map, key)] end

end
