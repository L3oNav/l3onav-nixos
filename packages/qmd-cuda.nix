{ lib, writeShellScriptBin, runCommand, coreutils, vulkan-loader, stdenv }:

let
  gccLib = lib.getLib stdenv.cc.cc;

in
writeShellScriptBin "qmd" ''
  export LD_LIBRARY_PATH="${vulkan-loader}/lib:${gccLib}/lib:/run/opengl-driver/lib:''${LD_LIBRARY_PATH:-}"
  export QMD_LLAMA_GPU="vulkan"
  exec /home/comrade/.npm-global/bin/qmd "$@"
''
