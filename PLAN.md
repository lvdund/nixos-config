# WireGuard Plan — `myserver` (hub) ← `workpc`, `macvd` (clients)

Star topology. `myserver` is the WireGuard **host** with a fixed listen port;
`workpc` and `macvd` are **clients** that dial in. All three machines reach each
other through the tunnel (client ↔ client traffic is forwarded by `myserver`).

---

## 1. Topology

```
                    workpc (NixOS)
                    wg0: 10.77.0.2/32
                         │  UDP :51820 (out)
                         │  PersistentKeepalive=25 (behind corp NAT)
        macvd (nix-darwin)│
        wg0: 10.77.0.3/32 │
             │  UDP :51820 (out)
             └────────────┼──────────────► Internet ◄─────┐
                          │                               │ UDP :51820 (in)
                          │        Home router (port forward)
                          │                │
                          ▼                ▼
                    ┌──────────────────────────┐
                    │ myserver (NixOS, hub)    │
                    │ wg0: 10.77.0.1/24        │
                    │ ListenPort 51820/udp     │
                    │ forwards client↔client   │
                    └──────────────────────────┘
```

## 2. Address & key allocation

| Host      | Machine file                          | wg0 address     | Role    | Key file (on that host)      |
|-----------|---------------------------------------|-----------------|---------|------------------------------|
| `myserver`| `nixos/myserver/configuration.nix`    | `10.77.0.1/24`  | hub     | `/etc/wireguard/wg0.key`     |
| `workpc`  | `nixos/workpc/configuration.nix`      | `10.77.0.2/32`  | client  | `/etc/wireguard/wg0.key`     |
| `macvd`   | `darwin/macvd` (conf file, see §7)    | `10.77.0.3/32`  | client  | `~/env/wireguard/wg0.key`    |

Fill in as keys are generated (public keys only — these are safe in the repo):

| Host      | Public key |
|-----------|------------|
| myserver  | `SERVER_PUB` = `__________` |
| workpc    | `WORKPC_PUB` = `__________` |
| macvd     | `MACVD_PUB`  = `__________` |

Fixed parameters:

- Subnet: `10.77.0.0/24`
- Port: `51820/udp` (only `myserver` listens; clients are outbound-only)
- Client `AllowedIPs` (phase 1): `10.77.0.0/24` — tunnel-only, no default-route change
- Client `AllowedIPs` (phase 2, optional): `0.0.0.0/0` — full exit-node via `myserver`

## 3. Secrets policy

- **Private keys never enter this repo.** They live only on the machine they
  belong to, root-owned, mode `600`. NixOS configs reference them via
  `privateKeyFile`.
- **Public keys are not secrets** — they go directly into the Nix configs.
- (Future improvement: manage private keys with `sops-nix` or `agenix` if
  full reproducibility is wanted. Not required for phase 1.)

---

## 4. Phase 0 — prerequisites (before touching any config)

1. **Router DHCP reservation** for `myserver`'s LAN MAC → stable LAN IP
   (e.g. `192.168.1.10`). Find MAC: `ip link` on the server.
2. **Router port forward**: `UDP 51820 → <myserver LAN IP> :51820`.
   Do **not** forward TCP.
3. **CGNAT check**: compare router WAN IP with `curl -4 ifconfig.me` run from
   home. If router WAN is in `100.64.0.0/10`, `10/8`, `172.16/12`,
   `192.168/16` while the external check differs → you are behind CGNAT;
   inbound forwarding will not work. Stop and reconsider (Tailscale, or ask
   ISP for a public IP) before continuing.
4. **Endpoint name**: note `myserver`'s public reachability as
   `<ENDPOINT>` = either static public IP `x.x.x.x` or a DDNS name
   `myserver.example.net` (router-integrated DDNS, DuckDNS, etc.).
   If the home IP is dynamic, set up DDNS **now** — clients will use it in
   `Endpoint`.
5. **Find `myserver`'s WAN interface name** (needed only for phase 2 NAT):
   ```bash
   ip route | grep default    # e.g. "default via 192.168.1.1 dev enp3s0"
   ```
   → `<WAN_IF>` = `enp3s0` (or whatever it says).

---

## 5. Phase 1a — generate keys (one-time, per machine)

On **each** of `myserver` and `workpc`:

```bash
sudo mkdir -p /etc/wireguard && sudo chmod 700 /etc/wireguard
umask 077
wg genkey | sudo tee /etc/wireguard/wg0.key | wg pubkey   # prints pubkey to stdout
sudo chmod 600 /etc/wireguard/wg0.key
```

Record each printed public key into the table in §2.

On **macvd**:

```bash
mkdir -p ~/env/wireguard && chmod 700 ~/env/wireguard
umask 077
wg genkey > ~/env/wireguard/wg0.key && wg pubkey < ~/env/wireguard/wg0.key
chmod 600 ~/env/wireguard/wg0.key
```

(If `wg` is missing, install first: `brew install wireguard-tools`.)

## 6. Phase 1b — `myserver` (hub) NixOS config

Add to `nixos/myserver/configuration.nix` (firewall is already enabled there —
good):

```nix
  # WireGuard hub must forward packets (client ↔ client relay via wg0)
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # --- WireGuard hub ---
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.77.0.1/24" ];
    listenPort = 51820;                     # fixed inbound port
    privateKeyFile = "/etc/wireguard/wg0.key";

    peers = [
      # workpc
      {
        publicKey = "WORKPC_PUB";
        allowedIPs = [ "10.77.0.2/32" ];
      }
      # macvd
      {
        publicKey = "MACVD_PUB";
        allowedIPs = [ "10.77.0.3/32" ];
      }
    ];
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ];            # WireGuard listen port
    # Trust the tunnel itself: SSH etc. over wg0 is fine
    trustedInterfaces = [ "wg0" ];
  };
```

Note: assigning each peer a `/32` in `allowedIPs` is what lets
client ↔ client traffic route through the hub.

Apply and verify:

```bash
sudo nixos-rebuild switch --flake .#myserver
sudo wg show wg0        # must list both peers with the keys above
ip addr show wg0        # must show 10.77.0.1/24
```

## 7. Phase 1c — `workpc` (NixOS client) config

Add to `nixos/workpc/configuration.nix`:

```nix
  # --- WireGuard client → myserver ---
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.77.0.2/32" ];
    privateKeyFile = "/etc/wireguard/wg0.key";

    peers = [
      {
        publicKey = "SERVER_PUB";
        endpoint = "<ENDPOINT>:51820";      # public IP or DDNS name of myserver
        allowedIPs = [ "10.77.0.0/24" ];    # phase 1: tunnel routes only
        persistentKeepalive = 25;           # keep NAT mapping alive
      }
    ];
  };
```

(workpc's firewall is currently disabled via `network_homepc.nix` — nothing
extra needed. If you later enable it, add `trustedInterfaces = [ "wg0" ];`.)

Apply:

```bash
sudo nixos-rebuild switch --flake .#workpc
```

## 8. Phase 1d — `macvd` (nix-darwin client) config

macOS has no nix-darwin WireGuard service; use `wg-quick` from Homebrew
(declaratively pinned in `darwin/macvd/configuration.nix`):

```nix
  homebrew.brews = [
    # ... existing entries ...
    "wireguard-tools"
  ];
```

Then `brew bundle`-style install happens on next `darwin-rebuild`, or run
`brew install wireguard-tools` directly once.

Create `/opt/homebrew/etc/wireguard/wg0.conf` (or `~/env/wireguard/wg0.conf`):

```ini
[Interface]
Address = 10.77.0.3/24
PrivateKey = <contents of ~/env/wireguard/wg0.key>

[Peer]
PublicKey = SERVER_PUB
Endpoint = <ENDPOINT>:51820
AllowedIPs = 10.77.0.0/24
PersistentKeepalive = 25
```

```bash
sudo chmod 600 /opt/homebrew/etc/wireguard/wg0.conf
sudo wg-quick up wg0          # uses utun device; sudo needed
# later: sudo wg-quick down wg0
```

Alternative for on-demand/GUI use: install the official **WireGuard.app**
(App Store) and import the same `[Interface]/[Peer]` block as a tunnel —
it handles DNS and activation without sudo.

## 9. Phase 1e — verification checklist

Run on **workpc** first, then **macvd**:

```bash
sudo wg show wg0
#  peer: <SERVER_PUB>
#    endpoint: <ENDPOINT>:51820
#    latest handshake: X seconds ago   ← THE success indicator
ping -c3 10.77.0.1            # hub
ssh vd@10.77.0.1              # SSH over tunnel (trustedInterfaces on server)
ping -c3 10.77.0.3            # from workpc → macvd, via hub forwarding
```

Also from `myserver`: `sudo wg show` should show handshakes from both peers.

If handshake never appears → endpoint/port-forward/CGNAT problem (§10).

## 10. Troubleshooting quick table

| Symptom | Check |
|---|---|
| No `latest handshake` | Router UDP 51820 forward exists? CGNAT (§4.3)? `<ENDPOINT>` current? `sudo tcpdump -ni <WAN_IF> udp port 51820` on server |
| Handshake OK, ping fails | `trustedInterfaces = [ "wg0" ]` applied on server? peer `allowedIPs` overlaps/mismatched? |
| Works, then dies after ~2 min | client missing `PersistentKeepalive = 25` |
| Client can't reach other client | `ip_forward` sysctl applied on server (`sysctl net.ipv4.ip_forward` = 1)? distinct `/32` peer `allowedIPs` on server? |
| DNS broken in phase 2 | see §11 DNS notes |
| workpc + cloudflare-warp conflict | warp (enabled in `network_homepc.nix`) and `0.0.0.0/0` both claim the default route — only run one at a time |

## 11. Phase 2 (optional) — full-tunnel exit node via `myserver`

Route all client internet traffic through home:

1. On `myserver` add:
   ```nix
     networking.nat = {
       enable = true;
       externalInterface = "<WAN_IF>";     # from §4.5, e.g. "enp3s0"
       internalInterfaces = [ "wg0" ];
     };
   ```
   (`ip_forward` is already set in §6; `networking.nat` additionally sets up
   masquerade rules.)
2. On each client change:
   ```
   AllowedIPs = 0.0.0.0/0
   ```
   (in Nix: `allowedIPs = [ "0.0.0.0/0" ];`; wg-quick handles policy routing
   so the tunnel endpoint itself stays reachable.)
3. Rebuild/down+up, then verify from client: `curl -4 ifconfig.me` must show
   the **home** public IP.
4. DNS: leave client DNS as-is (simplest, reliable). If you want home-side
   resolution later, add `DNS = 1.1.1.1` (or your home resolver) to the
   client `[Interface]` — supported by both wg-quick and WireGuard.app; on
   NixOS set it per-connection in NetworkManager instead.
5. Remember the cloudflare-warp conflict on workpc (§10).

## 12. Rollout order (summary)

```
1. §4  router reservation + UDP 51820 forward + DDNS + CGNAT check
2. §5  generate 3 key pairs, fill table in §2
3. §6  myserver config → rebuild → wg0 up, 2 peers listed
4. §7  workpc config → rebuild → handshake + ping 10.77.0.1
5. §8  macvd conf → wg-quick up → handshake + ping 10.77.0.1
6. §9  cross-pings workpc ↔ macvd through the hub
7. §11 (later, optional) exit-node + NAT
```

## 13. Future improvements (not now)

- `sops-nix` / `agenix` for private keys → fully declarative secrets
- DDNS updater on `myserver` (e.g. `ddclient`) instead of router-side
- Monitoring: `prometheus-wireguard-exporter` on the server
- Add `homepc` / `mylaptop` as peers `10.77.0.4` / `10.77.0.5` using the same
  hub snippet
