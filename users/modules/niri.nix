{
  repoRoot ? "/etc/nixos/nixos-config",
  config,
  ...
}: {
  xfconf.settings = {
    thunar = {
      # Sets the default view to Detailed List View
      "default-view" = "ThunarDetailsView";
      # Configure visible columns in list view
      "last-details-view-visible-columns" = "THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE,THUNAR_COLUMN_DATE_MODIFIED";
      # Configure the order of the columns
      "last-details-view-column-order" = "THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE,THUNAR_COLUMN_DATE_MODIFIED";
      # Optional: Set preferred default column widths
      "last-details-view-column-widths" = "50,100,100,150";
    };
  };

  # Link your custom configs
  home.file = {
    ".config/mako".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/mako";
  };
}
