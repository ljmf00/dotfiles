# ljmf00's dotfiles
Hopefully my last decent and simple dotfiles

---

## Minimal dependencies

To apply my dotfiles, you will need the following dependencies on Arch Linux:
```
bind-tools xdg-utils git rsync
```

## Additional steps

### Remarkable 2

Run this to apply `xochitl` patches:

```bash
sh -c "$(wget https://raw.githubusercontent.com/ddvk/remarkable-hacks/master/patch.sh -O-)"
```

Revert `xochitl` changes:

```bash
systemctl stop xochitl
rm -fr .cache/remarkable/xochitl/qmlcache/*
cp /home/rmhacks/xochitl.version /usr/bin/xochitl #where version is the current device version
systemctl start xochitl
```

More info, [here](https://github.com/ddvk/remarkable-hacks).
