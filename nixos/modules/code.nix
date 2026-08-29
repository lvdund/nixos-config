{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    vscode.fhs
    fzf
    nodejs
    go
    clang-tools # clangd
    gopls
    lua-language-server
    nixd
    pyright
    rust-analyzer
  ];

  # Per-user GOPATH so every account gets its own under $HOME.
  environment.shellInit = ''
    export GOPATH="$HOME/env/gopath_main"
  '';
}
