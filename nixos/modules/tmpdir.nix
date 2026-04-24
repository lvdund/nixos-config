{...}: {
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "25%"; # or a fixed size like "8G"
}
