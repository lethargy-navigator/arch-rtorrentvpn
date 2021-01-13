**Forked from https://github.com/binhex/arch-rtorrentvpn - Thanks to binhex for all the excellent work.**

**Application**

[rTorrent-ps](https://github.com/pyroscope/rtorrent-ps)
[pyrocore](https://github.com/pyroscope/pyrocore)

**Description**

This Docker focuses on rTorrent-ps and the pyrocore utilities. I prefer to handle VPN using a separate container w/ network_mode, so I stripped all of the VPN functionality out. I've added a cronie service for scheduling cron job execution of pyrocore utilities.

Rtorrent is accessed via a socket file located at /scgi/.scgi_local

You can create a crontab file located at /rtbase/crontab and it will be consumed at runtime. With this you can schedule execution of pyrocore utilities to manage torrents such as:
/home/nobody/bin/rtcontrol message='*Unregistered*torrent*' --yes --cron --cull
/home/nobody/bin/rtcontrol custom_1=radarr completed=+365d --yes --cron --cull

**Usage via docker-compose**

```
services:
  rtorrent:
    image: lethargy-navigator/rtorrent:latest
    container_name: rtorrent
    volumes:
      - scgi:/scgi
      - /mnt/torrents:/downloads
      - /home/rtorrent/rtorrent:/rtbase
    environment:
      - PUID=1005
      - PGID=1005
      - TZ=America/New_York
    restart: unless-stopped
```
