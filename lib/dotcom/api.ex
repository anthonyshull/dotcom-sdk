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
          adapter: NebulexRedisAdapter,
          default_key_generator: unquote(dotcom_module)

        use Nebulex.Caching

        @behaviour Nebulex.Caching.KeyGenerator

        @impl true
        def generate(mod, fun, args), do: :erlang.phash2({mod, fun, args})

        defp ttl(mod, fun) do
          mod_atom =
            mod
            |> Atom.to_string()
            |> String.split(".")
            |> (fn [head | tail] -> tail end).()
            |> Enum.join("_")
            |> String.downcase()
            |> String.to_atom()

          Application.get_env(:dotcom_sdk, mod_atom, nil) ||
            Application.get_env(:dotcom_sdk, fun, :infinity)
        end

        unquote do
          for {fun, arity} <- api_module.__info__(:functions) do
            quote do
              @decorate cacheable(
                          cache: __MODULE__,
                          opts: [ttl: ttl(unquote(dotcom_module), unquote(fun))]
                        )
              def unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, __MODULE__))) do
                case unquote(api_module).unquote(fun)(
                       unquote_splicing(Macro.generate_arguments(arity, __MODULE__))
                     ) do
                  {:ok, result} -> result
                  {:error, error} -> nil
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
