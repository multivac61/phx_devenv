# `phx_devenv`

> [!IMPORTANT]
> Everything you need to develop your Phoenix app locally™

I wanted a simple template repository that had everything needed work on [Phoenix applications](https://hexdocs.pm/phoenix/overview.html).

I use a basic [Nix flake with devenv](https://devenv.sh/guides/using-with-flakes/#modifying-your-flakenix-file) to manage dependencies, as well as managing the postgres instance.

We then use [direnv](https://direnv.net/) and [nix-direnv](https://github.com/nix-community/nix-direnv) to automatically enter a development shell when you `cd` into the project directory.

## Bootstrapping new app

> [!IMPORTANT]
> When running `phx.new` you need to provide a new name for the project, unfortunately the
> Tailwind LSP will not recognize the project when run in the current directory `./.`

First make sure that you have entered into the development shell, using `nix develop` (manual) or `direnv` (automatically when entering dir).

Following the excellent Phoenix documentation we need to run the following commands to bootstrap a new application, in our case we'll call it "hello":

> [!NOTE]
> Tailwind LSP and other code actions may not work until you run obtain and compile the dependencies
> `mix deps.get && mix deps.compile`, which is automatically done when running `mix phx.new --install .` below

```bash
mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new
mix phx.new --install hello
sed -i.bak -e "s/hostname: \"localhost\"/socket_dir: System.get_env(\"PGHOST\")/" ./hello/config/dev.exs && rm ./hello/config/dev.exs.bak  # mac/linux compatible
```

## Dev server and database

By running

```bash
devenv up
``` 
`devenv` will run the phoenix server and postgres database for you in a [process-compose](https://github.com/F1bonacc1/process-compose) instance

The first time you run the app you also need to run `mix ecto.create` inside the `hello` directory to bootstrap the database

## TODO

- [ ] Build project using Nix
- [ ] Format and lint
- [ ] CI/CD
