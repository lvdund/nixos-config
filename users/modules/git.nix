{
  programs.git = {
    enable = true;
    settings = {
      # Git identity shared by every host importing this module
      # (homepc, mylaptop, macvd)
      user.name = "lvdund";
      user.email = "lvdund@gmail.com";
    };
  };
}
