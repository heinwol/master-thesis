{
  description = "A Typst project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    typstfmt = {
      url = "github:jeffa5/typstfmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    sponge-networks.url = "git+file:/home/heinwol/Documents/work/ipu/sponge_networks?ref=HEAD";
    # Example of downloading icons from a non-flake source
    # font-awesome = {
    #   url = "github:FortAwesome/Font-Awesome";
    #   flake = false;
    # };
  };

  outputs =
    inputs @ { nixpkgs
    , typix
    , flake-utils
    , typstfmt
    , sponge-networks
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;
      typixLib = typix.lib.${system};

      traceit = x: lib.trace x x;

      src = typixLib.cleanTypstSource ./typst;
      commonArgs = {
        typstSource = "main.typ";

        fontPaths = [
          # Add paths to fonts here
          "${pkgs.liberation_ttf}/share/fonts/truetype"
        ];

        virtualPaths = [
          # Add paths that must be locally accessible to typst here
          # {
          #   dest = "icons";
          #   src = "${inputs.font-awesome}/svgs/regular";
          # }
        ];
      };

      # Compile a Typst project, *without* copying the result
      # to the current directory
      build-drv = typixLib.buildTypstProject (commonArgs
        // {
        inherit src;
      });

      # Compile a Typst project, and then copy the result
      # to the current directory
      build-script = typixLib.buildTypstProjectLocal (commonArgs
        // {
        inherit src;
      });

      # Watch a project and recompile on changes
      watch-script = typixLib.watchTypstProject commonArgs;

      sn = sponge-networks.packages.${system}.default;
      sn-with-pkgs = sn.dependencyEnv.withPackages (ps: [
        sn
        ps.typer
      ]);
      shell = typixLib.devShell {
        inherit (commonArgs) fontPaths virtualPaths;
        packages = [
          # WARNING: Don't run `typst-build` directly, instead use `nix run .#build`
          # See https://github.com/loqusion/typix/issues/2
          # build-script
          watch-script
          # typstfmt.packages.${system}.typstfmt
          pkgs.typstfmt
          sn-with-pkgs
        ];
      };
    in
    {
      checks = {
        inherit build-drv build-script watch-script;
      };

      packages.default = build-drv;

      apps = rec {
        default = watch;
        build = flake-utils.lib.mkApp {
          drv = build-script;
        };
        watch = flake-utils.lib.mkApp {
          drv = watch-script;
        };
      };

      devShells = {
        default = shell;
      };

      pkgs = pkgs;
    });
}
