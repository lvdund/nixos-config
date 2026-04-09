# Quick Reference Guide

## i3 Window Manager

> **Note**: `$mod` = Super (Windows) key

### Window Navigation
| Key | Action |
|-----|--------|
| `$mod + j` | Focus down |
| `$mod + k` | Focus up |
| `$mod + h` | Focus left |
| `$mod + l` | Focus right |
| `$mod + ↑↓←→` | Focus direction (arrows) |

### Applications
| Key | Action |
|-----|--------|
| `$mod + t` | Open terminal (kitty) |
| `$mod + b` | Open browser (firefox) |
| `$mod + e` | Open file manager (nautilus) |
| `$mod + a` | App launcher (rofi) |
| `$mod + Shift + e` | Powermenu (rofi) |

### Window Management
| Key | Action |
|-----|--------|
| `$mod + f` | Toggle fullscreen |
| `$mod + d` | Tabbed layout |
| `$mod + s` | Toggle split layout |
| `$mod + Shift + space` | Toggle floating |
| `$mod + Shift + q` | Kill focused window |

### Workspaces
| Key | Action |
|-----|--------|
| `$mod + 1-0` | Switch to workspace |
| `$mod + Tab` | Next workspace |
| `$mod + Shift + Tab` | Previous workspace |
| `$mod + Shift + 1-0` | Move window to workspace |

### Resize
| Key | Action |
|-----|--------|
| `$mod + -` | Shrink width |
| `$mod + =` | Grow width |
| `$mod + Shift + -` | Shrink height |
| `$mod + Shift + =` | Grow height |

### System
| Key | Action |
|-----|--------|
| `$mod + Shift + c` | Restart i3 |
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |

---

## Neovim

### Basic Motions
| Key | Action |
|-----|--------|
| `h j k l` | Left/Down/Up/Right |
| `w` | Word forward |
| `b` | Word backward |
| `e` | Word end |
| `0` | Line start |
| `$` | Line end |
| `gg` | File start |
| `G` | File end |
| `'` | Go to mark |

### Window Navigation
| Key | Action |
|-----|--------|
| `Ctrl + h/j/k/l` | Focus left/down/up/right |
| `Ctrl + ←↑↓→` | Focus direction |
| `Ctrl + \` | Cycle windows |
| `=` | Grow width |
| `-` | Shrink width |
| `+` | Grow height |
| `_` | Shrink height |

### Editing
| Key | Action |
|-----|--------|
| `jk` | Escape (insert mode) |
| `dw` | Delete word (backward) |
| `Ctrl + a` | Select all |
| `Alt + j/k` | Move line down/up |
| `Alt + ↑↓` | Move line up/down |
| `x` | Paste without overwrite (visual mode) |

### Search & Files (`sf` / `sg` / `sb`)
| Key | Action |
|-----|--------|
| `sf` | Search files |
| `sg` | Live grep |
| `sb` | Search buffers |
| `sn` | Search notifications |
| `ss` | Resume search |
| `sd` | Diagnostics (buffer) |
| `sD` | Diagnostics (workspace) |

### LSP Navigation
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `grr` | References |
| `gri` | Implementations |
| `gra` | Code actions |
| `gro` | Document symbols |
| `gr0` | Workspace symbols |
| `grt` | Type definition |

### Git
| Key | Action |
|-----|--------|
| `gs` | Git status |
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `grb` | Reset buffer |
| `grh` | Reset hunk |
| `gp` | Preview hunk |

### NvimTree
| Key | Action |
|-----|--------|
| `\` | Toggle tree |
| `l` | Open file |
| `a` | Create file/dir |
| `d` | Delete |
| `r` | Rename |
| `y` | Copy |
| `p` | Paste |
| `S` | Search node |
| `z` | Collapse all |
| `<BS>` | Close directory |

### Quickfix
| Key | Action |
|-----|--------|
| `Ctrl + n` | Next item |
| `Ctrl + p` | Previous item |
| `so` | Open list |
| `sc` | Close list |