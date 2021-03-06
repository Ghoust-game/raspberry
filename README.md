# Raspberry Pi scripts

Some scripts that were created during the ghoust development.

These files are NOT the game itself but things like:

- startupscripts
- self-updatescripts
- readonly-mounting

Full documentation on how to setup a Raspebrry Pi from scratch will be available in the [wiki](https://github.com/Ghoust-game/raspberry/wiki) soon.


# Wanna see logs?

    $ sudo journalctl -u ghoust -f
    $ sudo journalctl -u ghoust-updater -f


# Pi Setup from Scratch

Start with a new Raspbian image.

    # set hostname, password, and enable SSH
    $ sudo raspi-config

From now on it is a good idea to work in a SSH session

    # install avahi to broadcast `{hostname}.local`
    $ sudo apt-get update
    $ sudo apt-get install avahi-daemon
    $ sudo systemctl enable avahi-daemon

    $ apt-get install git python3 python3-pip

    # Clone git repos into /server
    $ mkdir /server && cd /server
    $ git clone https://github.com/Ghoust-game/raspberry.git
    $ git clone https://github.com/Ghoust-game/ghoust.git
    $ git clone https://github.com/Ghoust-game/frontend.git

    # Setup mosquitto and hostapd
    apt-get install mosquitto mosquitto-clients
