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
}
