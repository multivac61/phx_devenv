# `phx_devenv`

> [!NOTE]
> Everything you need to develop your Phoenix app™

I wanted a simple template repo that had everything needed work on [Phoenix applications](https://hexdocs.pm/phoenix/overview.html).

This is an adaption of the [devenv Phoenix example](https://github.com/cachix/devenv/tree/main/examples/phoenix)  where we use a basic [Nix flake with devenv](https://devenv.sh/guides/using-with-flakes/#modifying-your-flakenix-file) to manage dependencies, as well as managing the postgres instance.

If you do not have nix installed, please use the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) to obtain a copy.

### Optional

For convenience you can use [direnv](https://direnv.net/) and [nix-direnv](https://github.com/nix-community/nix-direnv) to automatically enter a development shell when entering into the project directory.

> [!CAUTION]
> If using `direnv`, storing the `.direnv` folder along with the code will cause issues. [See here for a workaround.](https://github.com/direnv/direnv/wiki/Customizing-cache-location#hashed-directories)

## Bootstrap

First make sure that you have entered into the development shell, using `nix develop` (https://hexdocs.pm/phoenix/overview.htmlmanual) or `direnv` (automatically when entering dir).

Following the excellent [Phoenix documentation](https://hexdocs.pm/phoenix/overview.html) we need to run the following commands to bootstrap a new application.

> [!WARNING]
> Tailwind LSP and other code actions may not work until you run obtain and compile the dependencies
> `mix deps.get && mix deps.compile`. This is done automatically when running `mix phx.new --install .` as below

```bash
mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new
mix phx.new --install .
sed -i.bak -e "s/hostname: \"localhost\"/socket_dir: System.get_env(\"PGHOST\")/" ./config/dev.exs && rm ./config/dev.exs.bak  # mac/linux compatible
```

## Dev server and [database](genki.is)

By running `devenv up` we spawn a phoenix server and postgres database inside a [process-compose](https://github.com/F1bonacc1/process-compose) instance. There you can inspect the logs, start/stop services, et cetera.

> [!NOTE]
> The first time you run the app you also need to run `mix ecto.create` to create the initial database


## References and documentation
* [Elixir documentation](https://elixir-lang.org/docs.html)
* [Phoenix documentation](https://hexdocs.pm/phoenix/Phoenix.html)
* [devenv documentation](https://devenv.sh/getting-started/)
* Sam Rose's [nix-phx](https://github.com/samrose/nix-phx) is an alternative flake-based Phoenix/nix starting point. The demo project is built using Nix and optionally deployed using NixOS

## TODO

- [ ] Build project using Nix
- [ ] Format and lint
- [ ] CI/CD

