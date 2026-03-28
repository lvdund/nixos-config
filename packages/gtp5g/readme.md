# Check if module is loaded
lsmod | grep gtp5g
# Check module info
modinfo gtp5g
# If not loaded yet, load manually
sudo modprobe gtp5g
