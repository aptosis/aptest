{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  name = "devshell";
  # See: <https://github.com/move-language/move/blob/2dabc08cb115a2385d3844b681917dd3129a30fe/scripts/dev_setup.sh>
  buildInputs = [
    aptos
    move-cli-aptos

    # Build tools
    rustup

    cmake
    clang
    pkg-config
    openssl
    nodejs

    # Git
    git
  ] ++ (lib.optionals stdenv.isDarwin ([
    libiconv
  ] ++ (with darwin.apple_sdk.frameworks; [
    DiskArbitration
    Foundation
  ])));

  shellHook = ''
    dotnet tool install --global boogie
    export PATH=$HOME/.dotnet/tools:$PATH
    export DOTNET_ROOT=${dotnet-sdk}
    export BOOGIE_EXE=$HOME/.dotnet/tools/boogie
  '';
}
