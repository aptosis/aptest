{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  name = "devshell";
  # See: <https://github.com/move-language/move/blob/2dabc08cb115a2385d3844b681917dd3129a30fe/scripts/dev_setup.sh>
  buildInputs = [
    aptos
    move-cli-aptos
  ];
}
