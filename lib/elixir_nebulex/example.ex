defmodule ElixirNebulex.Example do
  @moduledoc false

  use Nebulex.Caching
  use Tesla

  alias ElixirNebulex.Cache

  plug(Tesla.Middleware.BaseUrl, "https://jsonplaceholder.typicode.com")
  plug(Tesla.Middleware.JSON)

  @decorate cacheable(cache: Cache, key: route)
  def get_by_route(route) do
    case get(route) do
      {:ok, response} -> IO.inspect(response.body)
      {_, _} -> IO.inspect(nil)
    end
  end

  @decorate cache_put(cache: Cache, key: route)
  def update_by_route(route, data), do: data
end
