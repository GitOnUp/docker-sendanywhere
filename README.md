docker-sendanywhere
=========================

This was forked from the very helpful dorowu/ubuntu-desktop-lxde-vnc image.  The goal was to be able to run SendAnywhere in as close to a daemon-like manner as possible, for home-cloud purposes, with fewer image dependencies (i.e., we don't need LibreOffice).  VNC remains for debugging purposes as of now, but may be removed in the future.

The original purpose of this fork was to process images for my wife and I and copy non-image files without mangling them.  As such, this image comes with a by-the-minute cron job named process_uploads.sh.  The image contains imagemagick tools as well.

Every minute, the script runs on the contents of /home/ubuntu/Downloads, with the assumption SendAnywhere is storing its files there.  For image files, it resizes them to something web-acceptable, then strips EXIF and applies EXIF rotations.  It stores them in a "web" output directory.  The original file is moved to an "all" directory.  These directories are mapped on the host, to approximate a SendAnywhere daemon on said host.

Configure

SendAnywhere keeps a configuration file called config.ini.  In *NIX, this resides at:
```
~/.local/share/Estmob/Send Anywhere/config/config.ini
```
I haven't yet investigated where this lives on Windows or Mac, but I suspect they would be in the Application Data folder for the local profile in the former case, and in the /Applications bundle for SendAnywhere in the latter. Building the image requires the presence of config.ini in the same directory as Dockerfile.

This image requires you obtain a config.ini file from a machine on which you won't use SendAnywhere afterwards, after you've logged in.  SendAnywhere maintains a device ID and password in the configuration file and while it may work to run SendAnywhere while duplicate DEVIDs and DEVPASSWORDs are in effect I wouldn't expect it to *always* work.  

I've also only tested this when I've pulled a config file from a similar machine; i.e. a Debian-based one since that's what the docker image runs.  If you'd like to do the same, you could comment out the ADD line for config.ini in the Dockerfile and run this image, and VNC in to get SendAnywhere configured, then copy the config.ini file out.  (On my list of things to fix).

A sample config file looks as below.  Please note the comments.

```
[General]
DESKDISCOVERFLAG=true
DEVID=<redacted>                # SendAnywhere device ID
DEVPASSWORD=<redacted>          # SendAnywhere device password
ENABLETRAY=true
FIRSTSTARTEDFLAG=true
LASTUSERPUTNAME=<redacted>
OVERWRITEFLAG=false
PRESERVEFILETIMEFLAG=true
PROFILE=Home Cloud              # The name your device will show up as in the SendAnywhere app
RECVPATH=/home/ubuntu/Downloads # For this image to work, this MUST be set to this value
USERID=<redacted>               # This will be your SendAnywhere username
USERPASSWORD=<redacted>         # This will be a hash of your SendAnywhere password
```

Build
```
git clone https://github.com/GitOnUp/docker-sendanywhere.git
# copy the config file into docker-sendanywhere.git
docker build --rm -t GitOnUp/docker-sendanywhere docker-sendanywhere
```

Run
```
docker run --name home-cloud -d --restart=always -v <HOST_ALL_DIRECTORY>:/home/ubuntu/all_uploads -v <HOST_WEB_DIRECTORY>:/home/ubuntu/web_uploads -p 6080:6080 GitOnUp/docker-sendanywhere
```

Browse http://127.0.0.1:6080/vnc.html to log into VNC (no password).


Trobleshooting
==================

1. boot2docker connection issue, https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/2


License
==================

desktop-mirror is under the Apache 2.0 license. See the LICENSE file for details.
