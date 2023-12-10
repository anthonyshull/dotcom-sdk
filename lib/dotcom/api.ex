defmodule DOTCOM.Api do
  @moduledoc false

  @modules :application.get_key(:mbta_sdk, :modules)
           |> Kernel.elem(1)
           |> Enum.filter(fn module ->
             Kernel.to_string(module) |> String.match?(~r/Api/)
           end)
           |> Enum.map(fn module ->
             parent_module_str = Kernel.to_string(__MODULE__)
             sub_module_str = module |> Atom.to_string() |> String.split(".") |> List.last()

             {module, String.to_atom("#{parent_module_str}.#{sub_module_str}")}
           end)

  def submodules, do: @modules |> Enum.map(fn modules -> Kernel.elem(modules, 1) end)

  for modules <- @modules do
    {api_module, dotcom_module} = modules

    ast =
      quote do
        use Nebulex.Cache,
          otp_app: unquote(dotcom_module),
          adapter: NebulexRedisAdapter

        defp ttl(mod, fun) do
          mod_atom =
            mod
            |> Atom.to_string()
            |> String.split(".")
            |> Kernel.tl()
            |> Enum.join("_")
            |> String.downcase()
            |> String.to_atom()

          Application.get_env(:dotcom_sdk, mod_atom, nil) ||
            Application.get_env(:dotcom_sdk, fun, :infinity)
        end

        unquote do
          for {fun, arity} <- api_module.__info__(:functions) do
            quote do
              def unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, dotcom_module))) do
                args = unquote(Macro.generate_arguments(arity, dotcom_module)) |> Kernel.tl()

                key = :erlang.phash2({unquote(dotcom_module), unquote(fun), args})

                if value = unquote(dotcom_module).get(key) do
                  value
                else
                  case unquote(api_module).unquote(fun)(
                         unquote_splicing(Macro.generate_arguments(arity, dotcom_module))
                       ) do
                    {:ok, result} ->
                      unquote(dotcom_module).put(key, result)

                      result

                    {:error, error} ->
                      nil
                  end
                end
              end
            end
          end
        end
      end

    Module.create(
      dotcom_module,
      ast,
      Macro.Env.location(__ENV__)
    )
  end
end
