{ ... }: {
  programs.brave = {
    enable = true;
    extensions = [
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "jlmpjdjjbgclbocgajdjefcidcncaied";} # daily.dev
      {id = "akkdefghgcakdgkmakeajmijjhlcofmk";} # Hide YouTube Fullscreen Controls
      {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # uBlock Origin Lite 
    ];
    commandLineArgs = [
      "--disable-features=PasswordManagerOnboarding"
      "--disable-features=AutofillEnableAccountWalletStorage"
    ];
  };
}
