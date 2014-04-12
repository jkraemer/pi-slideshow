# Pi-Slideshow

A slideshow application for the Raspberry Pi or similar setups involving Linux
and a framebuffer.


## Setup

We will use [fim](http://www.autistici.org/dezperado/fim/) to display images,
netcat for remote controlling fim, and Ruby for everything else.

On [Raspbian](http://www.raspbian.org/) you should be all set with

```
aptitude install fim netcat ruby1.9.1 ruby-dev libssl-dev
```
.

Any Ruby dependencies (basically that's Sinatra and Puma) will be pulled in
once you install the gem:

```
gem install pi-slideshow
```

This gives you @/usr/local/bin/pi-slides@:

```
pi@raspberrypi ~ $ pi-slides --help
Usage:
       pi-slides [options]
where [options] are:
        --path, -p <s>:   image base directory (default: .)
    --interval, -i <i>:   seconds between image changes (default: 30)
   --web, --no-web, -w:   enable built in web interface (default: true)
        --port, -o <i>:   listen port for the web interface (default: 4567)
        --testmode, -t:   run against echo server instead launching a real fim
    --fim-port, -f <i>:   port to use for communicating with fim (default: 9999)
  --fim-binary, -m <s>:   path to fim binary (default: /usr/bin/fim)
    --fim-opts, -s <s>:   fim options (default: -d /dev/fb0)
  --remote-fim, -r <s>:   do not spawn fim, instead connect to this ip
         --verbose, -v:   verbose mode
           --quiet, -q:   quiet mode
            --help, -h:   Show this message
```

Most of the time you will only need to bother with the @path@, @port@ and maybe
@interval@ options, which tell pi-slides where your images are, which port
the web interface should run on, and how long each image should be shown
initially.

Pi-slides scans the path given for JPGs and displays them in random
order. Once finished, the path is re-scanned, so any changes (i.e. new
pictures) will be picked up.

For launching the slideshow upon boot, call pi-slides from @/etc/rc.local@:

```
pi@raspberrypi ~ $ cat /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

/usr/local/bin/pi-slides --path=/home/pi/images --interval=90 --port=80 > /tmp/pim-slides.log

exit 0
```

Note that if you call it like this, pi-slides will stay in the foreground,
meaning the login prompt is never reached. This is a good thing since otherwise
the blinking cursor of the prompt would be very visible all the time.

Just make sure you can ssh into the Pi before you reboot if you made this
change to @rc.local@.

## Enjoy!

After a reboot, your Pi should start happily displaying images in random order.

Soon after all is up and running nicely you will most probably notice that it
would be nice to change the slide interval *without* having to ssh into that
tiny box. Or to hold the slideshow for a while at your favorite shot. Or to
turn of the automatic fill-screen scaling that fim does by default. Here you go
- point your browser (preferably on your phone) to port 4567 of your Raspberry
Pi and you should see the remote control web interface.


## Disclaimer / Security implications

Setup like this you will have fim listening on port 9999 (localhost), and a
webserver listening on port 4567 (all interfaces), both running as *root* on
your Pi.

Everybody on the same network may access the web frontend, and everybody on the
Pi can make fim execute whatever fim script they like. Any security leak in
fim's script parser or the puma, sinatra or the slideshow webapp can lead to
somebody gaining root on your Pi.

There are ways to do this better, i.e. it should be possible to run fim as a
non-root user without losing access to the framebuffer, and of course puma does
not need to run as root (at least as long as you don't want it to bind to a
privileged port).  It would be awesome if puma could drop privileges after
binding to port 80, however I didn't find any information regarding this.

Whether all this is a risk for you largely depends on your environment - my Pi
sits behind a NATting firewall in my home network, and serves no other purpose
than showing pictures, that's why I don't care too much. I for sure wouldn't
run it like this on a network with people I don't trust.



