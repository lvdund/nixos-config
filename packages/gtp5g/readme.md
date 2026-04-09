# Check if module is loaded
lsmod | grep gtp5g
# Check module info
modinfo gtp5g
# If not loaded yet, load manually
sudo modprobe gtp5g


nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url --unpack https://github.com/free5gc/gtp5g/archive/refs/tags/v0.9.16.tar.gz)
