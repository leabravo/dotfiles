```text
bind_to_address "/run/user/1000/mpd/socket"
```

```bash
systemctl --user enable mpd.service
systemctl --user enable mpd.socket
```
