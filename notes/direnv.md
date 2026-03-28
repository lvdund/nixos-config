## 1. flake.nix

```nix
{
  description = "Python LangChain development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python312;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            (python.withPackages (ps: with ps; [
              python312Packages.python # Use the base python
              python312Packages.pip
              python312Packages.virtualenv
            ]))
            
            # Milvus HuggingFace
            # pkgs.stdenv.cc.cc.lib
            # pkgs.zlib
          ];

          shellHook = ''
            if [ ! -d ".venv" ]; then
              python -m venv .venv
            fi
            source .venv/bin/activate.fish
            
            pip install --upgrade pip
            pip install -r ./requirements.txt
            echo "🚀 Python LangChain ready!"
          '';
          
          # Python vs C/C++
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib ];
        };
      });
}
```

## 2. envrc

```bash
echo "use flake" >> .envrc
```

## 3. Activate

```bash
direnv allow
```
