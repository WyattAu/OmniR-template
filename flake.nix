{
  description = "OmniR R Development Environment — nix owns system libraries, renv owns R packages";

  inputs = {
    # nixos-unstable, pinned via flake.lock
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # System libraries required by packages in renv.lock:
      #   libuv     -> fs
      #   hunspell  -> spelling
      #   mpfr      -> Rmpfr
      #   gmp       -> gmp (Rmpfr dependency)
      #   curl      -> curl
      #   openssl   -> openssl
      #   libxml2   -> xml2
      #   zlib      -> assorted
      # Everything links against nix store paths via RPATH inside this
      # shell, so no LD_LIBRARY_PATH and no Posit-binary workarounds are
      # needed (unlike bare-metal nix R outside a shell).
      systemLibs = with pkgs; [
        pandoc
        which
        pkg-config
        gnumake
        gfortran
        zlib
        libxml2
        openssl
        curl
        libuv
        hunspell
        mpfr
        gmp
      ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ pkgs.R ] ++ systemLibs;

        shellHook = ''
          # Inside the pure nix environment, renv-built packages link nix
          # libraries directly: PPM binaries are wrong here (they target
          # Ubuntu shared libraries the nix loader cannot resolve), and
          # renv's install sandbox hides the nix include paths.
          export RENV_CONFIG_PPM_ENABLED=false
          export RENV_CONFIG_SANDBOX_ENABLED=false
          # Share the machine-wide renv package cache.
          export RENV_PATHS_ROOT="''${RENV_PATHS_ROOT:-$HOME/.cache/R/renv}"
          # renv cache entries built on other machines link system
          # libraries by SONAME; make them resolvable from the nix store.
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath systemLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          echo "OmniR dev shell: R $(R --version | head -1 | cut -d' ' -f3), renv cache at \$RENV_PATHS_ROOT"
        '';
      };
    };
}
