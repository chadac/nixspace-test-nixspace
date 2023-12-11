{
  description = "Test nixspace";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixspace.url = "github:chadac/nixspace";
  };

  outputs = { self, nixpkgs, nixspace }@inputs: nixspace.lib.mkWorkspace {
    src = ./.;
    inherit inputs;
  } ({ ... }: {
    perSystem = { pkgs, system, projects, ... }: {
      # merge all flakes together
      imports = map (project: project.lib.flakeModule) projects;
    };
  });
}
