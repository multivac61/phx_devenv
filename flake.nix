{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      systems,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              {
                packages = with pkgs; [ git ] ++ lib.optionals stdenv.isLinux [ inotify-tools ];

                scripts."bootstrap".exec = # bash
                  ''
                    mix local.hex --force
                    mix local.rebar --force
                    mix archive.install hex phx_new
                    mix phx.new --install .
                    sed -i.bak -e "s/hostname: \"localhost\"/socket_dir: System.get_env(\"PGHOST\")/" ./config/dev.exs && rm ./config/dev.exs.bak  # mac/linux compatible
                  '';

                languages.elixir.enable = true;

                services.postgres = {
                  enable = true;
                  initialScript = ''CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres' SUPERUSER;'';
                  initialDatabases = [ { name = "phx_devenv_dev"; } ];
                };

                processes.phoenix.exec = "mix phx.server";
              }
            ];
          };
        }
      );
    };
}
