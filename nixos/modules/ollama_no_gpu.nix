{
  config,
  pkgs,
  ...
}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cpu; # Correct way to force CPU-only mode
    openFirewall = true; # Optional: allows network access to Ollama
  };
}
