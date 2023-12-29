{
  description = "Test nixspace";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixspace.url = "path:/home/chadac/code/github.com/chadac/nixspace";
  };

  outputs = { self, flake-parts, systems, nixspace, ... }@inputs: let
    ws = nixspace.lib.mkWorkspace {
      src = ./.;
      inherit inputs;
    };
  in flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;
    imports = [ ws.flakeModule ];
  };
}
