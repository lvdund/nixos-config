{...}: {
  boot.kernel.sysctl = {
    # Global socket buffer caps/defaults
    "net.core.rmem_max" = 8388608;
    "net.core.wmem_max" = 8388608;
    "net.core.rmem_default" = 8388608;
    "net.core.wmem_default" = 8388608;

    # SCTP-specific memory tuning
    "net.sctp.sctp_rmem" = "4096 262144 8388608";
    "net.sctp.sctp_wmem" = "4096 262144 8388608";
  };
}
