{ pkgs }:
let dyanmicDeps = (import ../compile-deps.nix { inherit pkgs; }).dynamicDeps;

in with pkgs;
stdenv.mkDerivation {
  pname = "roc-wrapped";
  version = "0.1.0";

  # TODO: make arm build
  src = fetchurl {
    url =
      "https://github.com/roc-lang/roc/releases/download/nightly/roc_nightly-linux_x86_64-latest.tar.gz";
    hash = "sha256-bcIaIixVAWAoGNlKJi8a4yyO6tp9ubNB48zMcfYYBeQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = dyanmicDeps;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    install -m755 -D  roc  $out/bin/roc
    runHook postInstall
  '';

}
