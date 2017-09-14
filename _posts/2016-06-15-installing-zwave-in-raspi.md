---
layout: post
title: Installing HomeAssistant.io with Z-Wave support on a RaspberryPi
date: 2016-06-14 11:45
tags: home-automation, fun, raspberry, python
---

How to install HomeAssistant with Z-Wave support on a RaspberyPi (Model B) ang get it
to work with a Aeon Z-Stick S2. Setup basic light switches.

## Pi system version

TLDR: Update to Jessie.

I've started with a pretty dated system:

~~~
Linux pibox1 3.6.11+ #538 PREEMPT Fri Aug 30 20:42:08 BST 2013 armv6l GNU/Linux
~~~

Doing the process from below I've crashed several walls, some of which were
easy do bypass, but some proved very hard. Later I've rememberd that HA
requires python 3.4, whereas the old PI had 3.2. I decided to update update Raspbian to a later version:

~~~
sudo apt-get dist-upgrade # 60 minutes
~~~

Alas - this helped very little. I've tried re-compiling python from sources but still ran into various issues that were hard to fix. You will save yourselves a lot of time by just [downloading the latest Raspbian Jessie and installing it.](https://www.raspberrypi.org/documentation/installation/installing-images/README.md).

I will be using the Jessie Lite version, since I don't need X or the pre-installs.

## ZWave setup

* ssh into RPi

~~~
ssh pi@192.168.1.32 # or whatever your IP is
~~~

* install zwave dependecies

~~~
sudo apt-get update
sudo apt-get -y install cython3 libudev-dev python3-sphinx python3-setuptools python-pip python-dev libsqlite3-dev git htop
sudo easy_install3 pip

cython -V # should be >= 0.24
~~~


* install python-zwave


~~~
git clone https://github.com/OpenZWave/python-openzwave.git
cd python-openzwave
git checkout python3

# I run the below commands together since they take the longest
# after running this, you have about 3 hours until it finishes
sudo pip3 install --upgrade cython && \•
PYTHON_EXEC=$(which python3) make build && \
sudo PYTHON_EXEC=$(which python3) make install

cython -V # should be >= 0.24
~~~

## Zwave dongle setup

* plug in dongle
* run `dmesg` and take note for the parameters in the last line like this:

~~~
$ dmesg
[   26.732893] New USB device found, idVendor=10c4, idProduct=ea60
~~~

* `sudo nano /etc/udev/rules.d/99-usb-serial.rules`
* paste this: (optionally changing the parameters if you dongle is other than
  mine)

~~~
SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60",
ATTRS{serial}=="0001", SYMLINK+="zwave"
~~~

* after restarting/unplugging the device you should have a `/dev/zwave` device

~~~
pi@pibox1 ~ $ ls /dev/zwave
/dev/zwave
~~~

## Home Assistant install & config

* install hass (at last)

~~~
sudo pip3 install homeassistant
~~~

* set openzwave path in configuration.yaml

You need to set the config_path to something like this - depends on your `openzwave` version

~~~
zwave:
  usb_path: /dev/zwave
  config_path: /usr/local/lib/python3.4/dist-packages/libopenzwave-0.3.1-py3.4-linux-armv6l.egg/config
  polling_interval: 60000
  customize:
    sensor.greenwave_powernode_6_port_energy_10:
      polling_intensity: 1
~~~

* run hass and check if everything is working

`hass`

You should now have a list of switches that all have a "Switch" name. Click on these and see if they are working (of you're using light switches, remember that they only work with the physical switch set to off). If all is well - continue.

* setup your switches with proper names

After running hass, you will see something resembling:

~~~
INFO:homeassistant.core:Bus:Handling <Event state_changed[L]: entity_id=switch.wenzhou_tkb_control_system_tz66d_dual_wall_switch_switch_5, new_state=<state switch.wenzhou_tkb_control_system_tz66d_dual_wall_switch_switch_5=off; friendly_name=Salon, node_id=5, icon=mdi:lightbulb @ 2016-06-12T23:59:36.209219+02:00>, old_state=None>
~~~

You will want to setup these in `configuration.yaml` like so:

~~~
homeassistant:
  customize:
    switch.wenzhou_tkb_control_system_tz66d_dual_wall_switch_switch_5:
      friendly_name: Salon
      icon: mdi:lightbulb

    switch.wenzhou_tkb_control_system_tz66d_dual_wall_switch_switch_6:
      friendly_name: Kitchen
      icon: mdi:food-fork-drink
~~~

## Setup autostart

* setup autostart using `systemd`

Just so that you don't have to SSH and run `hass` everytime you reset the Pi.

~~~
sudo su -c 'cat <<EOF >> /lib/systemd/system/home-assistant@pi.service
[Unit]
Description=Home Assistant
After=network.target

[Service]
Type=simple
User=%i
ExecStart=/usr/local/bin/hass

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl --system daemon-reload
sudo systemctl enable home-assistant@pi
sudo systemctl start home-assistant@pi
~~~
