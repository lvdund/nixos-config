{
  config,
  pkgs,
  ...
}: {
  # Font configuration for better typography
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    # Nerd Fonts for terminal and coding
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Hack" "Iosevka" ]; })
    
    # General fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    
    # Icon fonts
    font-awesome
    material-icons
    
    # Font management
    font-manager
  ];
}
