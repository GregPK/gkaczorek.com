---
layout: post
title: Bodge of the day - NordVPN monitoring script
date: 2019-09-04 15:31
tags: BOTD scripts bash vpn monitoring
---


NordVPN is a pretty good service, however, it occasionally updates the client and the connection goes down. Since the client is so transparent, it can unnoticed for days before I catch up. It seems like a good idea to have a script to outsource that vigilance.

*The plan:*

1. Write a script to check NordVPN status and report on the issue if everything is not fine.
2. Run that script periodically.

## Source
`$ vim bin/nvpn-monitor`

```bash
#!/bin/bash
status_connected=$(nordvpn status | grep "Status: Connected" | wc -l);

export DISPLAY=:0.0
export $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep "mdm")/environ )

if [[ $status_connected = '0' ]]; then
  notify-send "NordVPN is disconnected" -u critical•
fi
```

Notes:
- The `export` commands are needed for `notify-send` to know which session user to notify. Nicked it off the internets. Depending on what session manager you're using you might need to change the `mdm` bit there.

## Run periodically

I briefly thought about making a daemon, but seems overkill. Just add this to cron.

`$ crontab -e`

```
* * * * * /home/gregpk/bin/nvpn-monitor 2> /home/gregpk/cron.txt >> /home/gregpk/cron.txt
```

Note: I output all cron scripts to the same file so that they can be debugged properly if they fail.

That's it! This will now 