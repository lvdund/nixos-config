
Assuming this is permitted by your workplace, the clean setup is:

```text
work_pc
WireGuard: 10.77.0.2
      │
      │ encrypted UDP
      ▼
Internet
      │
Home router
UDP 51820 → home_pc
      │
      ▼
home_pc
WireGuard: 10.77.0.1
      │
      │ NAT / forwarding
      ▼
Home Internet → Google/etc.
```

Because your goal involves a company network that blocks sites, I can show the standard WireGuard configuration, but not techniques for disguising WireGuard or evading an employer's VPN/network controls.

## 1. Install WireGuard

### NixOS

Add:

```nix
environment.systemPackages = with pkgs; [
  wireguard-tools
];
```

Then:

```bash
sudo nixos-rebuild switch
```

Ubuntu/Debian:

```bash
sudo apt update
sudo apt install wireguard
```

macOS can use the WireGuard application or:

```bash
brew install wireguard-tools
```

We'll assume Linux for `home_pc`.

---

## 2. Give `home_pc` a stable LAN address

You do **not** need a static public IP.

You should, however, give the machine a stable address inside your home network, for example:

```text
Router:   192.168.1.1
home_pc:  192.168.1.10
```

The easiest method is a DHCP reservation in your router.

---

## 3. Generate keys

On `home_pc`:

```bash
sudo mkdir -p /etc/wireguard
cd /etc/wireguard

umask 077

wg genkey | sudo tee home_private.key \
  | wg pubkey | sudo tee home_public.key
```

View the public key:

```bash
sudo cat /etc/wireguard/home_public.key
```

Do **not** share:

```text
home_private.key
```

On `work_pc`:

```bash
umask 077

wg genkey > work_private.key
wg pubkey < work_private.key > work_public.key
```

You now have:

```text
HOME_PRIVATE
HOME_PUBLIC

WORK_PRIVATE
WORK_PUBLIC
```

Only public keys are exchanged.

---

# 4. Configure `home_pc`

Create:

```bash
sudo nano /etc/wireguard/wg0.conf
```

Use:

```ini
[Interface]
Address = 10.77.0.1/24
ListenPort = 51820
PrivateKey = HOME_PRIVATE_KEY

[Peer]
PublicKey = WORK_PUBLIC_KEY
AllowedIPs = 10.77.0.2/32
```

Replace the placeholders with the actual key strings.

Secure it:

```bash
sudo chmod 600 /etc/wireguard/wg0.conf
```

---

# 5. Enable IP forwarding

Your home PC needs to act as a router:

```text
wg0
 │
10.77.0.1
 │
home_pc
 │
eth0/wlan0
 │
Internet
```

Temporarily:

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

Check:

```bash
sysctl net.ipv4.ip_forward
```

You want:

```text
net.ipv4.ip_forward = 1
```

For a normal Linux installation, make it persistent in:

```bash
sudo nano /etc/sysctl.d/99-wireguard.conf
```

with:

```text
net.ipv4.ip_forward=1
```

Then:

```bash
sudo sysctl --system
```

On NixOS, don't manually modify `/etc/sysctl.d`. Put this in `configuration.nix`:

```nix
boot.kernel.sysctl = {
  "net.ipv4.ip_forward" = 1;
};
```

---

# 6. Configure NAT on `home_pc`

Suppose the Internet-facing interface is:

```text
enp3s0
```

Find yours:

```bash
ip route
```

For example:

```text
default via 192.168.1.1 dev enp3s0
```

means the interface is:

```text
enp3s0
```

For a conventional Linux firewall, you need masquerading from the WireGuard subnet:

```text
10.77.0.2
   ↓
home_pc
   ↓ NAT
192.168.1.10
   ↓
router
   ↓
Internet
```

If you're using NixOS, it's cleaner to configure this declaratively:

```nix
networking.nat = {
  enable = true;
  externalInterface = "enp3s0";
  internalInterfaces = [ "wg0" ];
};
```

Also:

```nix
networking.firewall.allowedUDPPorts = [ 51820 ];
```

Then:

```bash
sudo nixos-rebuild switch
```

---

# 7. Start WireGuard on home PC

For a standard Linux configuration:

```bash
sudo wg-quick up wg0
```

Check:

```bash
sudo wg
```

and:

```bash
ip addr show wg0
```

You should see:

```text
wg0
    inet 10.77.0.1/24
```

Enable at boot:

```bash
sudo systemctl enable wg-quick@wg0
```

---

# 8. Configure your home router

This is critical.

Your router receives Internet traffic first:

```text
Internet
    ↓
public IP
    ↓
HOME ROUTER
192.168.1.1
    ↓
home_pc
192.168.1.10
```

Create a port-forwarding rule:

```text
Protocol:     UDP
External:     51820
Internal IP:  192.168.1.10
Internal:     51820
```

Do **not** select TCP.

---

# 9. Find your home public IP

From your home network, use your router's WAN/status page or a reputable "what is my IP" service.

Suppose it is:

```text
123.45.67.89
```

Then the WireGuard server is reachable at:

```text
123.45.67.89:51820
```

If your ISP changes this address, use DDNS later.

---

# 10. Configure `work_pc`

Create:

```bash
sudo nano /etc/wireguard/wg0.conf
```

Initially, **do not route all Internet traffic through it**. First test only the VPN network:

```ini
[Interface]
Address = 10.77.0.2/24
PrivateKey = WORK_PRIVATE_KEY

[Peer]
PublicKey = HOME_PUBLIC_KEY
Endpoint = 123.45.67.89:51820

AllowedIPs = 10.77.0.0/24

PersistentKeepalive = 25
```

Start:

```bash
sudo wg-quick up wg0
```

---

# 11. Check the handshake

On `work_pc`:

```bash
sudo wg
```

A successful connection should show something like:

```text
peer: ABCDEFG...
  endpoint: 123.45.67.89:51820
  allowed ips: 10.77.0.0/24
  latest handshake: 12 seconds ago
  transfer: 1.3 KiB received, 2.1 KiB sent
```

The most important field is:

```text
latest handshake
```

Now:

```bash
ping 10.77.0.1
```

If that works:

```text
work_pc 10.77.0.2
       │
       │ ✓
       ▼
home_pc 10.77.0.1
```

WireGuard itself is working.

---

# 12. Route Internet traffic through home

Once the tunnel is confirmed and you're authorized to use it, change the client's:

```ini
AllowedIPs = 10.77.0.0/24
```

to:

```ini
AllowedIPs = 0.0.0.0/0
```

This means:

```text
0.0.0.0/0
   =
all IPv4 destinations
```

Restart:

```bash
sudo wg-quick down wg0
sudo wg-quick up wg0
```

The route becomes:

```text
work_pc
  │
  │ google.com
  ▼
wg0
  │
  │ encrypted
  ▼
home_pc
  │
  │ NAT
  ▼
home router
  │
  ▼
Internet
```

Check your public IP from `work_pc`. It should now match your **home Internet public IP**.

---

## 13. DNS

Routing Internet traffic and DNS are separate issues.

For a personal network you administer, you can specify a DNS resolver in the client configuration, for example your home DNS server:

```ini
[Interface]
Address = 10.77.0.2/24
PrivateKey = WORK_PRIVATE_KEY
DNS = 192.168.1.1
```

But `192.168.1.1` must actually be reachable through the tunnel and your routing/firewall rules.

A simpler architecture is to run a DNS resolver on the home side and give it a WireGuard-reachable address.

---

## 14. Dynamic home IP

If:

```text
today:     123.45.67.89
tomorrow:  123.45.68.21
```

your client configuration breaks.

Use DDNS:

```text
myhome.example.net
        │
        ▼
123.45.68.21
```

Then:

```ini
Endpoint = myhome.example.net:51820
```

Your router may already support providers such as DuckDNS, No-IP, or other DDNS services.

---

## 15. Check for CGNAT

Before spending much time debugging port forwarding, compare:

```text
Router WAN IPv4
```

with the public IPv4 reported by an external IP-checking service.

If the router says something such as:

```text
100.64.x.x
100.80.x.x
10.x.x.x
192.168.x.x
```

while the Internet reports something completely different, you may be behind CGNAT.

Then:

```text
Internet
   ↓
ISP CGNAT       ← you don't control this NAT
   ↓
home router
   ↓
home_pc
```

Normal inbound port forwarding may not work.

In that situation, direct WireGuard is inconvenient. A mesh VPN such as Tailscale is usually easier because it handles NAT traversal and can relay connections when direct peer-to-peer connectivity isn't possible.

### Recommended order

Don't configure everything simultaneously. Test progressively:

```text
1. Install WireGuard
        ↓
2. Generate keys
        ↓
3. Configure 10.77.0.1 ↔ 10.77.0.2
        ↓
4. Port-forward UDP 51820
        ↓
5. Confirm "latest handshake"
        ↓
6. ping 10.77.0.1
        ↓
7. Enable forwarding/NAT
        ↓
8. Test Internet routing
        ↓
9. Add DDNS
```

If both machines are **NixOS**, I can instead give you a complete `configuration.nix` for `home_pc` and `work_pc`, which is substantially cleaner than using `wg-quick` manually.
