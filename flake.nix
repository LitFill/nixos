{
  description = "LitFill's dendritic NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrappers.url = "github:nix-community/nix-wrapper-modules";

    nixvim.url = "github:nix-community/nixvim";

    koki.url = "github:LitFill/koki";
  };

  outputs =
    inputs:
    let
      inherit (inputs) import-tree;
      inherit (inputs.flake-parts.lib) mkFlake;
    in
    mkFlake {
      inherit inputs;
    } (import-tree ./modules);
}
