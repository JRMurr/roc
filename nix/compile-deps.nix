{ pkgs }:
let
  zigPkg = pkgs.zig_0_11;
  llvmPkgs = pkgs.llvmPackages_16;
  llvmVersion = builtins.splitVersion llvmPkgs.release_version;
  llvmMajorMinorStr = builtins.elemAt llvmVersion 0
    + builtins.elemAt llvmVersion 1;
  libc = pkgs.stdenv.cc.cc.lib;
  # nix does not store libs in /usr/lib or /lib
  glibcPath = if pkgs.stdenv.isLinux then "${pkgs.glibc.out}/lib" else "";
  libGccSPath = if pkgs.stdenv.isLinux then "${libc}/lib" else "";

  dynamicDeps = with pkgs; [ libc libffi ncurses zlib ];
in {
  inherit zigPkg llvmPkgs llvmVersion llvmMajorMinorStr glibcPath libGccSPath
    dynamicDeps;

  darwinInputs = with pkgs;
    lib.optionals stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
      AppKit
      CoreFoundation
      CoreServices
      Foundation
      Security
    ]);
}
