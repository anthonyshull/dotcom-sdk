defmodule DOTCOM.Api do
  @moduledoc false

  api_modules =
    :application.get_key(:mbta_sdk, :modules)
    |> Kernel.elem(1)
    |> Enum.filter(fn module ->
      Kernel.to_string(module) |> String.match?(~r/Api/)
    end)

  for api_module <- api_modules do
    parent_module_str = Kernel.to_string(__MODULE__)
    sub_module_str = api_module |> Kernel.to_string() |> String.split(".") |> List.last()
    dynamic_module_str = "#{parent_module_str}.#{sub_module_str}"
    dynamic_module = String.to_atom(dynamic_module_str)

    ast =
      quote do
        use Nebulex.Cache,
          otp_app: unquote(dynamic_module),
          adapter: NebulexRedisAdapter,
          default_key_generator: unquote(dynamic_module)

        use Nebulex.Caching

        @behaviour Nebulex.Caching.KeyGenerator

        @impl true
        def generate(mod, fun, args), do: :erlang.phash2({mod, fun, args})

        unquote do
          for {fun, arity} <- api_module.__info__(:functions) do
            quote do
              @decorate cacheable(cache: __MODULE__)
              def unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, __MODULE__))) do
                Logster.info(
                  message: :calling_upstream,
                  module: __MODULE__,
                  function: unquote(fun)
                )

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
      dynamic_module,
      ast,
      Macro.Env.location(__ENV__)
    )
  end
end
