- file `~/.ssh/config`:

```
Host etri
    HostName etri.lvdund.online
    User vd
    ProxyCommand cloudflared access ssh --hostname %h
```

- Then run:

```bash
ssh etri
```

- OR:

```bash
ssh -o 'ProxyCommand=cloudflared access ssh --hostname %h' vd@etri.lvdund.online
```
