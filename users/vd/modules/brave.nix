{ config, pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden password manager
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
    ];
  };
}
