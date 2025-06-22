{ system ? builtins.currentSystem
, pkgs ? import ./nix/pinned.nix { inherit system; }
}:

pkgs.dockerTools.buildImage {
  name = "rdkafka-node";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "rdkafka-node-env";
    paths = with pkgs; [
      rdkafka
      nodejs_22

      openssl
      cacert

      gcc
      gnumake
      python3
      pkg-config

      glibc
      stdenv.cc.cc.lib
      zlib

      bash
      coreutils
      curl
      fd
      findutils
      gawk
      gnugrep
      gnused
      ripgrep
      which
      git
    ];
    pathsToLink = [
      "/bin"
      "/config"
      "/dev"
      "/etc"
      "/include"
      "/lib"
      "/lib64"
      "/libexec"
      "/libs"
      "/share"
      "/usr"
    ];
  };

  config = {
    Env = [
      "PATH=/bin"
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "PKG_CONFIG_PATH=/lib/pkgconfig:/share/pkgconfig"
    ];
    WorkingDir = "/app";
    Cmd = [ "${pkgs.bash}/bin/bash" ];
  };
}
