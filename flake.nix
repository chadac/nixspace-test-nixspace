{
  description = "Test nixspace";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    arion.url = "github:hercules-ci/arion";
    nixspace-dev.url = "path:/home/chadac/code/github.com/chadac/nixspace";
  };

  outputs = { self, flake-parts, arion, systems, nixspace-dev, ... }@inputs: let
    ws = nixspace-dev.lib.mkWorkspace {
      src = ./.;
      systems = import systems;
      inherit inputs;
    };
  in flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;
    imports = [ ws.default.flakeModule ];
    perSystem = { pkgs, lib, system, ... }: {
      packages = {
        compose-file = inputs.arion.lib.build {
          inherit pkgs;
          modules = [ { project.name = "test-nixspace"; } ] ++ builtins.concatLists (map
            (project:
              if(builtins.hasAttr "lib" project && builtins.hasAttr "arionModule" project.lib)
              then [ project.lib.arionModule ]
              else [ ]
            ) (lib.attrValues ws.default.projects)
          );
        };
      };
    };
  };
}
